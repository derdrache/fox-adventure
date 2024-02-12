extends CanvasLayer

@onready var animationsPlayer : AnimationPlayer = $AnimationPlayer


func fade_out():
	animationsPlayer.play("fade")
	
func fade_in():
	animationsPlayer.play_backwards("fade")
