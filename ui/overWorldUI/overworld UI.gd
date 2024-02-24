extends CanvasLayer

@onready var controlNode : Control = $Control
@onready var backgroundRect = $Control/ColorRect
@onready var closeButtonRect = $Control/CloseButtonMenu
@onready var menuButton = $Control/MenuButtonContainer
@onready var menuSelection = $Control/VBoxContainer

signal openMenu
signal closeMenu


func _input(event):
	if event.is_action_released("open_menu"):
		if menuButton.visible: 
			_on_menu_button_pressed()
			$Control/VBoxContainer/SettingButton.grab_focus()
		else: 
			if $Control/SettingMenu.visible: _on_setting_menu_close_window()
			else: _on_close_button_pressed()
		

func _on_close_button_pressed():
	closeButtonRect.visible = false
	backgroundRect.visible = false
	menuSelection.visible = false

	menuButton.visible = true
	closeMenu.emit()

func _on_menu_button_pressed():
	controlNode.anchors_preset = 15
	menuButton.visible = false
	backgroundRect.visible = true
	closeButtonRect.visible = true
	menuSelection.visible = true
	openMenu.emit()
	



func _on_setting_button_pressed():
	$Control/SettingMenu.visible = true
	layer = 10
	menuSelection.visible = false
	closeButtonRect.visible = false
	menuButton.visible = false


func _on_setting_menu_close_window():
	layer = 0
	$Control/SettingMenu.visible = false
	closeButtonRect.visible = true
	menuSelection.visible = true
	menuButton.visible = false
	$Control/VBoxContainer/SettingButton.grab_focus()


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://ui/startMenu/startMenu.tscn")
