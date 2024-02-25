extends Node2D

var fullDone = GameManager.full_done_check()
var backgroundCount = 1

func _ready():
	_move_player()

func _move_player():
	var screenWidth = get_viewport().size.x
	var tween = get_tree().create_tween()
	
	tween.tween_property($Player, "position", Vector2(screenWidth + 50,631), 14)
	tween.tween_callback(_credits_done)	
	
func _credits_done():
	print("done")
	#$Camera2D/CanvasLayer/CircleTransition.transition("out", 1)
	
func _change_backgrounds():
	var backgroundList = [$CityBackground, $BeachBackground, $WinterBackground, 
		$CaveBackground, $DesertBackground, $SwampBackground, $Background
	]
	
	if backgroundCount == len(backgroundList): return
	
	if backgroundCount > 0:
		backgroundList[backgroundCount-1].visible = false
		backgroundList[backgroundCount].visible = true
	
	backgroundCount += 1


func _on_timer_timeout():
	print("test")
	_change_backgrounds()
