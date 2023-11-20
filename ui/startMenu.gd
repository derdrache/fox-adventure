extends Node2D


func _on_start_button_pressed():
	Utils.load_game()
	get_tree().change_scene_to_file("res://level/over_world/overWorld.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
