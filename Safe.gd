extends StaticBody2D

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
	pass
#	$Sprite.visible = !$Sprite.visible
	
func on_body_entered(body):
	print_debug("碰撞了："+body.collision_mask)
	emit_signal("safe")
	$FoodClip.play()
	queue_free()	

func on_start_game():
	queue_free()

func on_LiveTimer_timeout():
	queue_free()