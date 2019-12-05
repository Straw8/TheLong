extends Control

signal start_game

func _ready():
	$StartButton.connect("button_down",self,"on_StartButton_pressed")
	$MessageTimer.connect("timeout",self,"on_MessageTimer_timeout")
	$FlashTimer.connect("timeout",self,"on_FlashTimer_timeout")
	$FlashTimer.start()
	
func on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")

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
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func on_MessageTimer_timeout():
	$MessageLabel.hide()
