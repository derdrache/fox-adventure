extends Node2D

@onready var player = $playerOverWorld
@onready var camera = $Camera2D
@onready var uiNodeWorld1 = $World1/ui


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


func _process(delta):		
	_check_start_interactions()
	
	
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
	
	var uiChildren = uiNodeWorld1.get_children()
	for ui in uiChildren:
		ui.update_ui(GameManager.levelDetails)

func changeCamera():
	var isOnBorderTop = player.position.y < camera.position.y - CAMERA_VERTICAL / 2
	var isOnBorderBottom = player.position.y > camera.position.y + CAMERA_VERTICAL / 2
	var isOnBorderRight = player.position.x > camera.position.x + CAMERA_HORIZONTAL / 2
	var isOnBorderLeft = player.position.x < camera.position.x - CAMERA_HORIZONTAL / 2

	if isOnBorderTop:
		camera.position.y -= CAMERA_VERTICAL
	elif isOnBorderBottom:
		camera.position.y += CAMERA_VERTICAL
	elif isOnBorderRight:
		camera.position.x += CAMERA_HORIZONTAL	
	elif isOnBorderLeft:
		camera.position.x -= CAMERA_HORIZONTAL		

func _check_start_interactions():
	var startLevelInteraction = LevelManager.levelNewClear
	
	if !level_interaction_dict.has(str(startLevelInteraction)): return
	
	LevelManager.levelNewClear = 0
	activeInteraction = true
	
	level_interaction_dict[str(startLevelInteraction)].call()
	
func _level_interaction0():
	$World1/Ducks/PathStone/PathFollow2D/Duck.move()
	$World1/Ducks/PathStone/PathFollow2D/Duck.connect("interactionDone", interaction_done)
		
func _level_interaction1():
	$World1/Ducks/PathBridge/PathFollow2D/Duck2.move()
	$World1/Ducks/PathBridge/PathFollow2D/Duck2.connect("interactionDone", interaction_done)
	
func _check_interactions_disables():
	for level in LEVEL_INTERACTION_Disable_DICT:
		if LevelManager.check_level_already_done(int(level)): 
			LEVEL_INTERACTION_Disable_DICT[level].call()
				
	
func _disable_level_interaction0():	
	$Ducks/PathStone.visible = false
	$Obstacle/bigStone.visible = false

func _disable_level_interaction1():
	$Ducks/PathBridge.visible = false
	$Obstacle/brokenBridge.isComplete = true


func _disable_ui():
	var allUi = $World1/ui.get_children()
	
	for ui in allUi:
		if ui.visible: lastLevelUi = ui
		ui.visible = false

func interaction_done():
	activeInteraction = false
