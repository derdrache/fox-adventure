extends Node2D

@onready var procentLabel = $Player/ProcentMessageBox/NinePatchRect/MarginContainer/Label

var fullDone = GameManager.full_done_check()
var backgroundCount = 1
var babyCatRessource = preload("res://chars/babyCat.tscn")
var creditDuration = 40


func _ready():
	_move_player()
	
	var procentDone = GameManager.procent_done()
	
	if fullDone || procentDone == 100: 
		$Player/ShortMessageBox.visible = true
		$Player/ProcentMessageBox.visible = false
		$SpawnCats.start()
	else:
		procentLabel.text = str(procentDone) + "%"

func _process(delta):
	$Credits.position.y -= 90 * delta

func _move_player():
	var screenWidth = get_viewport().size.x
	var tween = get_tree().create_tween()
	
	tween.tween_property($Player, "position", Vector2(screenWidth + 50,631), creditDuration)
	tween.tween_callback(_credits_done)	
	
func _spawn_baby_cats():
	var babyCatNode = babyCatRessource.instantiate()
	babyCatNode.scale = Vector2(3,3)
	babyCatNode.position = Vector2(0, 650)
	add_child(babyCatNode)
	
	var screenWidth = get_viewport().size.x
	var tween = get_tree().create_tween()
	
	tween.tween_property(babyCatNode, "position", Vector2(screenWidth + 50,650), creditDuration)
	
func _credits_done():
	$CanvasLayer/CircleTransition.transition("out", 1)
	await  get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")
	
func _change_backgrounds():
	var backgroundList = $Backgrounds.get_children()
	
	if backgroundCount == len(backgroundList): return
	
	if backgroundCount > 0:
		backgroundList[backgroundCount-1].visible = false
		backgroundList[backgroundCount].visible = true
	
	backgroundCount += 1

func _on_timer_timeout():
	_change_backgrounds()


func _on_spawn_cats_timeout():
	_spawn_baby_cats()
