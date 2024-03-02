extends Control


func _ready():
	if !DisplayServer.is_touchscreen_available():
		$VBoxContainer/VBoxContainer/StartButton.grab_focus()

func _on_start_button_pressed():
	Utils.load_game("settings")
	get_tree().change_scene_to_file("res://ui/load_window/SelectLoadData.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

