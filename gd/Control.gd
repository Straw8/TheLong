extends Control

signal start_game

func _ready():
	$StartButton.connect("button_down",self,"on_StartButton_pressed")
	$MessageTimer.connect("timeout",self,"on_MessageTimer_timeout")
	$FlashTimer.connect("timeout",self,"on_FlashTimer_timeout")
	$FlashTimer.start()
	$TextureButton.connect("button_down",self,"on_TextureButton_down")
	
func on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
#	$TextureButton.show()

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func on_FlashTimer_timeout():
	$FlashLabel.visible = !$FlashLabel.visible

func show_flash():
	if $FlashTimer and !$FlashTimer.is_stopped():
		$FlashLabel.hide()
		$FlashTimer.stop()

func show_game_over(text):
	show_message("游戏结束！")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = text
	$MessageLabel.show()
	yield(get_tree().create_timer(1), 'timeout')
	$StartButton.text = "Continue"
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func on_MessageTimer_timeout():
	$MessageLabel.hide()

func on_TextureButton_down():
	get_tree().paused = true
	DialogManager.show_dialog_one("游戏已暂停，点击按钮继续游戏","cancle_pause")

func update_life(delta_life):
	var life_container = get_node("LifeContainer")
	var children = life_container.get_children()
	if delta_life > 0:
		for child in children:
			if !child.visible:
				child.show()
				break
	else:
		var length = len(children) 
		for i in range(0,length):
			if children[length-1-i].visible:
				children[length-1-i].hide()
				break
	
