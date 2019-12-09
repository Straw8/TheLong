extends Node
export (PackedScene) var Dialog = preload("res://tscn/Dialog.tscn")

var title
var content
var BtnOkFunc
var BtnOneFunc
var dialog

func _ready():
	self.BtnOkFunc = "close_dialog"
	title = "提示"
	dialog = Dialog.instance()

func show_dialog(content=Node,okFunc="close_dialog"):
	self.content = content
	dialog.get_node("PanelContainer/VBoxContainer/HBoxContainer/BtnOne").visible = false
	self.BtnOkFunc = okFunc
	self.open_dialog()

func open_dialog():
	dialog.get_node("PanelContainer/VBoxContainer/Title").text = title
	dialog.get_node("PanelContainer/VBoxContainer/Content").text = content
	dialog.get_node("PanelContainer/VBoxContainer/HBoxContainer/BtnOk").connect("button_down",self,BtnOkFunc)
	dialog.get_node("PanelContainer/VBoxContainer/HBoxContainer/BtnCancle").connect("button_down",self,"close_dialog")
	dialog.get_node("PanelContainer/VBoxContainer/HBoxContainer/BtnOne").connect("button_down",self,BtnOneFunc)
	dialog.visible = true
	if dialog.get_parent():
		dialog.get_parent().remove_child(dialog)
	add_child(dialog)

func close_dialog():
	if dialog.get_parent():
		dialog.get_parent().remove_child(dialog)

func show_dialog_one(content=Node,oneFunc="close_dialog"):
	self.content = content
	self.BtnOneFunc = oneFunc
	dialog.get_node("PanelContainer/VBoxContainer/HBoxContainer/BtnOk").visible = false
	dialog.get_node("PanelContainer/VBoxContainer/HBoxContainer/BtnCancle").visible = false
	self.open_dialog()
	
func cancle_pause():
	print_debug("cancle_pause")
	get_tree().paused = false
	self.close_dialog()
