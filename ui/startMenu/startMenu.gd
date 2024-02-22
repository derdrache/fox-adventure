extends Control


func _on_start_button_pressed():
	Utils.load_game("settings")
	get_tree().change_scene_to_file("res://ui/load_window/SelectLoadData.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
