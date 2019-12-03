extends Node2D

#signal
signal safe

func _ready():
	self.init()

func init():
	self.connect("body_entered",self,"on_body_entered")
	$ShaderTimer.connect("timeout",self,"on_ShaderTimer_timeout")
	$ShaderTimer.start()
	$LiveTimer.connect("timeout",self,"on_LiveTimer_timeout")
	$LiveTimer.start()

func on_ShaderTimer_timeout():
	$Sprite.visible = !$Sprite.visible
	
func on_body_entered(body):
	"""
	区分一下，只能被玩家吃到
	"""
	print_debug("发生碰撞：",body.name)
	if body.name == "Player":
		emit_signal("safe")
		queue_free()

func on_start_game():
	queue_free()

func on_LiveTimer_timeout():
	queue_free()