extends Control

#signal
signal start_game

func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BtnStart.connect("button_down",self,"on_BtnStart_down")
	$MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/BtnQuit.connect("button_down",self,"on_BtnQuit_down")

func on_BtnStart_down():
	SceneManager.load_scene("res://tscn/Main.tscn")
	
func on_BtnQuit_down():
	get_tree().quit()
	
