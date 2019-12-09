extends Area2D

#signal
signal life
signal add_life_score
var score = 10

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
	emit_signal("life")
	emit_signal("add_life_score",self.score)
	$FoodClip.play()
	queue_free()

func on_start_game():
	queue_free()

func on_LiveTimer_timeout():
	queue_free()
