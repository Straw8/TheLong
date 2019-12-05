extends RigidBody2D

#signal
signal mob_dead

var mob_types = ["walk", "swim", "fly"]

func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	$Visibility.connect("screen_exited",self,"on_screen_exited")
	
func on_screen_exited():
	emit_signal("mob_dead")
	queue_free()

func on_start_game():
	queue_free()
