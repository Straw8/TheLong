extends Node2D

export (PackedScene) var Mob = preload("res://Mob.tscn")
export (PackedScene) var Safe = preload("res://Safe.tscn")
#signal
signal accelerate
#var
var score
var current_count	#统计当前生成的所有敌人
var max_speed
var min_speed
var max_count


func _ready():
	randomize()
	$Engine_Label.text = "Godot version: " + Engine.get_version_info()["string"]
	$ScoreTimer.connect("timeout",self,"on_ScoreTimer_timeout")
	$StartTimer.connect("timeout",self,"on_StartTimer_timeout")
	$MobTimer.connect("timeout",self,"on_MobTimer_timeout")
	$Player.connect("hit",self,"game_over")
	self.connect("accelerate",$Player,"on_accelerate")
	$HUD.connect("start_game",self,"new_game")
	
func _process(delta):
	$DebugLabel.text = "FPS: " + str(Engine.get_frames_per_second())
		
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	self.init()
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func init():
	score = 0
	current_count = 0
	min_speed = ProjectConstant.mob_min_speed
	max_speed = ProjectConstant.mob_max_speed
	max_count = ProjectConstant.mob_max_count

func on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	if score/10 > (score-1)/10:
		min_speed += score/10*50
		max_speed += score/10*50
		max_count += score/10*2
		emit_signal("accelerate")
		self.spawn_food()

func spawn_food():
	var safe = Safe.instance()
	add_child(safe)
	var screen_size = get_viewport_rect().size
	safe.connect("safe",$Player,"on_get_food")
	safe.position = Vector2(rand_range(100,screen_size.x-100),rand_range(100,screen_size.y-100))
	$HUD.connect("start_game", safe, "on_start_game")
	print_debug(safe.position)

func dec_count():
	current_count -= 1
	
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