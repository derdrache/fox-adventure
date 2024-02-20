extends CanvasLayer

@onready var controlNode : Control = $Control
@onready var backgroundRect = $Control/ColorRect
@onready var closeButtonRect = $Control/CloseButtonMenu
@onready var menuButton = $Control/MenuButtonContainer
@onready var menuSelection = $Control/VBoxContainer


func _on_close_button_pressed():
	controlNode.anchors_preset = 10
	menuButton.visible = true
	backgroundRect.visible = false
	closeButtonRect.visible = false
	menuSelection.visible = false	


func _on_menu_button_pressed():
	controlNode.anchors_preset = 15
	menuButton.visible = false
	backgroundRect.visible = true
	closeButtonRect.visible = true
	menuSelection.visible = true
	


func _on_exit_button_pressed():
	GameManager.gameNumber = 0
	get_tree().change_scene_to_file("res://ui/startMenu/startMenu.tscn")

func _on_setting_button_pressed():
	$Control/SettingMenu.visible = true
	layer = 10
	menuSelection.visible = false
	menuSelection.visible = false
	closeButtonRect.visible = false
	menuButton.visible = true


func _on_setting_menu_close_window():
	backgroundRect.visible = false
	layer = -1
