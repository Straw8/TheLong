extends Area2D

#signal
signal safe
signal add_safe_score
var score = 5

func _ready():
	self.init()
	
func init():
	self.connect("area_entered",self,"on_area_entered")
	$ShaderTimer.connect("timeout",self,"on_ShaderTimer_timeout")
	$ShaderTimer.start()
	$LiveTimer.connect("timeout",self,"on_LiveTimer_timeout")
	$LiveTimer.start()

func on_ShaderTimer_timeout():
	$Sprite.visible = !$Sprite.visible
	
func on_area_entered(_body):
	emit_signal("safe")
	emit_signal("add_safe_score",self.score)
	$FoodClip.play()
	queue_free()

func on_start_game():
	queue_free()

func on_LiveTimer_timeout():
	queue_free()
