extends Area2D


var scoreResource = preload("res://ui/score/Score.tscn")
var circleTransition = preload("res://ui/CircleTransition.tscn")
var scoreBoardDone = false


func _on_body_entered(body):
	if body is Player:
		body.level_end()
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BackgroundMusic"), true)
		LevelManager.level_done()
		$AudioStreamPlayer.play()
		
		body.circle_transition("out", 3)		
			
		await get_tree().create_timer(3).timeout
		AudioServer.set_bus_mute(AudioServer.get_bus_index("BackgroundMusic"), false)
		get_tree().change_scene_to_file("res://ui/score/Score.tscn")
		
		
	
		
		
