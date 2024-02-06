extends CanvasLayer

@onready var backgroundRect = $Control/ColorRect
@onready var closeButtonRect = $Control/CloseButtonMenu
@onready var menuButton = $Control/MenuButtonContainer
@onready var menuSelection = $Control/VBoxContainer


func _on_close_button_pressed():
	menuButton.visible = true
	backgroundRect.visible = false
	closeButtonRect.visible = false
	menuSelection.visible = false	


func _on_menu_button_pressed():
	menuButton.visible = false
	backgroundRect.visible = true
	closeButtonRect.visible = true
	menuSelection.visible = true


func _on_exit_button_pressed():
	GameManager.gameNumber = 0
	get_tree().change_scene_to_file("res://ui/startMenu.tscn")
