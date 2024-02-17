extends CanvasLayer

@onready var animationsPlayer : AnimationPlayer = $AnimationPlayer
@onready var coloRect : ColorRect = $ColorRect

@export var backgroundColor : Color = Color(0,0,0,0)

var changeColor : Color

func _ready():
	coloRect.color = backgroundColor

func set_background_color(color):
	coloRect.color = color

func fade_out():
	layer = 10
	animationsPlayer.play("fade")
	changeColor = Color(0,0,0,1)
	
func fade_in():
	layer = 10
	animationsPlayer.play_backwards("fade")
	changeColor = Color(0,0,0,0)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade":
		coloRect.color = changeColor
		layer = -1
