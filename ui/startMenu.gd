extends Control


func _on_start_button_pressed():
	Utils.load_game()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_tester_reset_pressed():
	Utils.delete_game()
	print("deleted")
