extends Area2D




func _on_body_entered(body):
	if body is Player:
		LevelManager.level_done()
		get_tree().change_scene_to_file("res://level/over_world/overWorld.tscn")
