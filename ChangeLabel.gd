extends Node2D

func _ready():
	$Button.connect("pressed",self,"on_button_press")

func on_button_press():
	$Label.text = "按钮被点击"
