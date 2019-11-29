extends RigidBody2D

export var min_speed = 150  # Minimum speed range.
export var max_speed = 250  # Maximum speed range.
var mob_types = ["walk", "swim", "fly"]

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	$Visibility.connect("screen_exited",self,"on_screen_exited")

func on_screen_exited():
	queue_free()