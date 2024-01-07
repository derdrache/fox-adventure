extends Node2D

@onready var player = $playerOverWorld
@onready var camera = $Cameras/Camera2D
@onready var uiNodesWorld1 = $"World1 - Wood/ui"

@onready var duckWorld1_1 = $"World1 - Wood/Ducks/Duck"
@onready var duckWorld1_2 = $"World1 - Wood/Ducks/Duck2"
@onready var duckWorld2_1 = $"World2 - Swamp/Ducks/Duck"
@onready var duckWorld2_2 = $"World2 - Swamp/Ducks/Duck2"

@onready var obstacle1_1 = $"World1 - Wood/Obstacle/bigStone"
@onready var obstacle1_2 = $"World1 - Wood/Obstacle/brokenBridge"
@onready var obstacle2_1 = $"World2 - Swamp/Obstacles/bridge1/brokenBridge"
@onready var obstacle2_2 = $"World2 - Swamp/Obstacles/bridge2"


const CAMERA_VERTICAL = 365
const CAMERA_HORIZONTAL = 650 

var interactionsList: Array
var obstaclesList : Array
const LEVEL_INTERACTION_Disable_DICT : Dictionary = {
	"2": 0,
	"4": 1,
	"9": 2,
	"11": 3
}
const LEVEL_INTERACTION_DICT: Dictionary = {
	"2": 0,
	"4": 1,
	"9": 2,
	"11": 3
}
var activeInteraction = false
var lastLevelUi
var levelStatusList = []
var cameraOnChange = false


func _ready():
	interactionsList = [duckWorld1_1, duckWorld1_2, duckWorld2_1, duckWorld2_2]
	obstaclesList = [obstacle1_1, obstacle1_2, obstacle2_1, obstacle2_2]

	_load_data()
	_check_interactions_disables()
	_check_start_interactions()
	
	_disable_level_interaction(0)

func _process(_delta):		
	changeCamera()
	
	if activeInteraction : 
		_disable_ui()
		player.blockMovement = true
	
	if !activeInteraction:
		player.blockMovement = false
		
		if lastLevelUi != null: 
			lastLevelUi.visible = true
			lastLevelUi = null
		
func _load_data():
	var savedPlayerPosition = GameManager.playerPosition
	
	if savedPlayerPosition != Vector2.ZERO:
		player.position = savedPlayerPosition
	
	var uiWorld1Children = uiNodesWorld1.get_children()
	for ui in uiWorld1Children:
		ui.update_ui(GameManager.levelDetails)

func changeCamera():
	if cameraOnChange: return
	
	var isOnBorderTop = player.position.y < camera.position.y +5 - CAMERA_VERTICAL / 2.0
	var isOnBorderBottom = player.position.y > camera.position.y -5 + CAMERA_VERTICAL / 2.0
	var isOnBorderRight = player.position.x > camera.position.x -5  + CAMERA_HORIZONTAL / 2.0
	var isOnBorderLeft = player.position.x < camera.position.x +5 - CAMERA_HORIZONTAL / 2.0
	
	if !isOnBorderTop && !isOnBorderBottom && !isOnBorderRight && !isOnBorderLeft: return

	var tween = create_tween()
	if isOnBorderTop:
		tween.tween_property(
			camera, "position:y", camera.position.y - CAMERA_VERTICAL, 1.0).set_trans(
				Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	elif isOnBorderBottom:
		tween.tween_property(
			camera, "position:y", camera.position.y + CAMERA_VERTICAL, 1.0).set_trans(
				Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	elif isOnBorderRight:
		tween.tween_property(
			camera, "position:x", camera.position.x + CAMERA_HORIZONTAL, 1.0).set_trans(
				Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	elif isOnBorderLeft:
		tween.tween_property(
			camera, "position:x", camera.position.x - CAMERA_HORIZONTAL, 1.0).set_trans(
				Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)	

	if isOnBorderTop || isOnBorderBottom || isOnBorderRight || isOnBorderLeft:
		cameraOnChange = true
		await get_tree().create_timer(2.0).timeout
		cameraOnChange = false
		
func _check_start_interactions():
	var startLevelInteraction = LevelManager.activeLevel
	
	if !LEVEL_INTERACTION_DICT.has(str(startLevelInteraction)): return
	
	activeInteraction = true
	
	_level_interaction(LEVEL_INTERACTION_DICT[str(startLevelInteraction)])
	
func _check_interactions_disables():
	for level in LEVEL_INTERACTION_Disable_DICT:
		var firstTimeClear = LevelManager.activeLevel == int(level) && LevelManager.levelNewClear
		if LevelManager.check_level_already_done(int(level)) && !firstTimeClear:
			_disable_level_interaction(LEVEL_INTERACTION_Disable_DICT[level])


func _level_interaction(i):
	interactionsList[i].move()
	interactionsList[i].connect("interactionDone", interaction_done)

func _disable_level_interaction(i):
	interactionsList[i].visible = false
	var obstacle = obstaclesList[i]

	if obstacle is StaticBody2D:
		obstacle.done()
	else: 
		for child in obstacle.get_children():
			child.done()
		
	
func _disable_ui():
	var allUi = $"World1 - Wood/ui".get_children()
	
	for ui in allUi:
		if ui.visible: lastLevelUi = ui
		ui.visible = false

func interaction_done():
	activeInteraction = false
