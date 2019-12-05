extends Node2D

export (PackedScene) var Mob = preload("res://Mob.tscn")
export (PackedScene) var Safe = preload("res://Safe.tscn")
#signal
signal accelerate
signal show_flash
#var
var score	#得分
var current_count	#统计当前生成的所有敌人
var max_speed
var min_speed
var max_count	#最大敌人数量
var game_time	#游戏时间，根据时间来增加游戏难度
var has_start
var food_count	#吃到道具数量

func _ready():
	randomize()
	has_start = false
	$Engine_Label.text = "Godot version: " + Engine.get_version_info()["string"]
	$StartTimer.connect("timeout",self,"on_StartTimer_timeout")
	$MobTimer.connect("timeout",self,"on_MobTimer_timeout")
	$Player.connect("hit",self,"game_over")
	self.connect("accelerate",$Player,"on_accelerate")
	$HUD.connect("start_game",self,"new_game")
	self.connect("show_flash",$HUD,"show_flash")
	
func _process(delta):
	$DebugLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	if has_start == true:
		game_time += delta
		self.add_level()

func add_level():
	if game_time > rand_range(5,15):
		min_speed += score/10*50
		max_speed += score/10*50
		max_count += score/10*2
		emit_signal("accelerate")
		self.spawn_food()
		game_time = 0
		
func game_over():
	$MobTimer.stop()
	$HUD.show_game_over("总分:"+str(self.score)+"\n道具："+str(self.food_count))
	$Music.stop()
	$DeathSound.play()
	has_start = false

func new_game():
	self.init_game()
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	emit_signal("show_flash")
	$HUD.show_message("Get Ready")

func init_game():
	score = 0
	current_count = 0
	game_time = 0
	food_count = 0
	has_start = true
	min_speed = ProjectConstant.mob_min_speed
	max_speed = ProjectConstant.mob_max_speed
	max_count = ProjectConstant.mob_max_count

func on_StartTimer_timeout():
	$MobTimer.start()

func on_ScoreTimer_timeout():
	self.add_score(1)
		
func add_score(delta_score):
	score += delta_score
	$HUD.update_score(score)

func add_food_count(delta_score):
	self.food_count += 1
	self.add_score(delta_score)

func spawn_food():
	var safe = Safe.instance()
	add_child(safe)
	var screen_size = get_viewport_rect().size
	safe.connect("safe",$Player,"on_get_food")
	safe.connect("add_safe_score",self,"add_food_count")
	safe.position = Vector2(rand_range(50,screen_size.x-50),rand_range(50,screen_size.y-50))
	$HUD.connect("start_game", safe, "on_start_game")

func dec_count():
	if has_start == true:
		current_count -= 1
		self.add_score(1)
	
func inc_count():
	current_count += 1

func check_count():
	return current_count >= max_count

func on_MobTimer_timeout():
	if self.check_count():
		return
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	mob.connect("mob_dead",self,"dec_count")
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(min_speed, max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "on_start_game")
	self.inc_count()
