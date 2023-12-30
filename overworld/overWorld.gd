extends Node2D

@onready var player = $playerOverWorld
@onready var camera = $Cameras/Camera2D
@onready var uiNodesWorld1 = $"World1 - Wood/ui"
@onready var duckWorld1_1 = $"World1 - Wood/Ducks/Duck"
@onready var duckWorld1_2 = $"World1 - Wood/Ducks/Duck2"

const CAMERA_VERTICAL = 365
const CAMERA_HORIZONTAL = 650 

var LEVEL_INTERACTION_Disable_DICT : Dictionary = {
	"2": _disable_level_interaction0,
	"4": _disable_level_interaction1
}
var level_interaction_dict : Dictionary = {
	"2": _level_interaction0,
	"4": _level_interaction1
}
var activeInteraction = false
var lastLevelUi
var levelStatusList = []


func _ready():
	_load_data()
	_check_interactions_disables()
	_check_start_interactions()

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
	var isOnBorderTop = player.position.y < camera.position.y +5 - CAMERA_VERTICAL / 2.0
	var isOnBorderBottom = player.position.y > camera.position.y -5 + CAMERA_VERTICAL / 2.0
	var isOnBorderRight = player.position.x > camera.position.x -5  + CAMERA_HORIZONTAL / 2.0
	var isOnBorderLeft = player.position.x < camera.position.x +5 - CAMERA_HORIZONTAL / 2.0

	if isOnBorderTop:
		camera.position.y -= CAMERA_VERTICAL
	elif isOnBorderBottom:
		camera.position.y += CAMERA_VERTICAL
	elif isOnBorderRight:
		camera.position.x += CAMERA_HORIZONTAL	
	elif isOnBorderLeft:
		camera.position.x -= CAMERA_HORIZONTAL		

func _check_start_interactions():
	var startLevelInteraction = LevelManager.activeLevel
	
	if !level_interaction_dict.has(str(startLevelInteraction)): return
	
	activeInteraction = true
	
	level_interaction_dict[str(startLevelInteraction)].call()
	
func _level_interaction0():
	duckWorld1_1.move()
	duckWorld1_1.connect("interactionDone", interaction_done)
		
func _level_interaction1():
	duckWorld1_2.move()
	duckWorld1_2.connect("interactionDone", interaction_done)
	
func _check_interactions_disables():
	for level in LEVEL_INTERACTION_Disable_DICT:
		var firstTimeClear = LevelManager.activeLevel == int(level) && LevelManager.levelNewClear
		if LevelManager.check_level_already_done(int(level)) && !firstTimeClear:
			LEVEL_INTERACTION_Disable_DICT[level].call()
				
	
func _disable_level_interaction0():	
	duckWorld1_1.visible = false
	$"World1 - Wood/Obstacle/bigStone".done()

func _disable_level_interaction1():
	duckWorld1_1.visible = false
	$"World1 - Wood/Obstacle/brokenBridge".done()

func _disable_ui():
	var allUi = $"World1 - Wood/ui".get_children()
	
	for ui in allUi:
		if ui.visible: lastLevelUi = ui
		ui.visible = false

func interaction_done():
	activeInteraction = false
