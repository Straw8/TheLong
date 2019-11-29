extends Node2D

export (PackedScene) var Mob = preload("res://Mob.tscn")
var score

func _ready():
	randomize()
	$ScoreTimer.connect("timeout",self,"_on_ScoreTimer_timeout")
	$StartTimer.connect("timeout",self,"_on_StartTimer_timeout")
	$MobTimer.connect("timeout",self,"_on_MobTimer_timeout")
	$Player.connect("hit",self,"game_over")
	new_game()
	
func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1

func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	$MobPath/MobSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var mob = Mob.instance()
	add_child(mob)
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = $MobPath/MobSpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Set the velocity (speed & direction).
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)