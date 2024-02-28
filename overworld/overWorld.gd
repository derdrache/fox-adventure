extends Node2D

@onready var player = $PlayerOverWorld
@onready var camera : Camera2D = $Cameras/Camera2D
@onready var screenshotCamera : Camera2D = $ScreenshotCamera

@onready var uiNodesWorld1 = $"World1 - Wood/ui"
@onready var uiNodesWorld2 = $"World2 - Swamp/ui"
@onready var uiNodesWorld3 = $"World3 - Desert/ui"
@onready var uiNodesWorld4 = $"World4 - Cave/ui"
@onready var uiNodesWorld5 = $"World5 - Winter/ui"
@onready var uiNodesWorld6 = $"World6 - Beach/ui"
@onready var uiNodesWorld7 = $"World7 - City/ui"

@onready var duckWorld1_1 = $"World1 - Wood/Ducks/Duck"
@onready var duckWorld1_2 = $"World1 - Wood/Ducks/Duck2"
@onready var duckWorld2_1 = $"World2 - Swamp/Ducks/Duck"
@onready var duckWorld2_2 = $"World2 - Swamp/Ducks/Duck2"

@onready var obstacle1_1 = $"World1 - Wood/Obstacle/bigStone"
@onready var obstacle1_2 = $"World1 - Wood/Obstacle/brokenBridge"
@onready var obstacle2_1 = $"World2 - Swamp/Obstacles/bridge1/brokenBridge"
@onready var obstacle2_2 = $"World2 - Swamp/Obstacles/bridge2"

@onready var duckWorld3_1 = $"World3 - Desert/ducks/Duck"
@onready var duckWorld3_2 = $"World3 - Desert/ducks/Duck2"
@onready var obstacle3_1 = $"World3 - Desert/Obstacales/catuse"
@onready var obstacle3_2 = $"World3 - Desert/Obstacales/BigStoneDesert"

@onready var duckWorld4_1 = $"World4 - Cave/Ducks/Duck1"
@onready var duckWorld4_2 = $"World4 - Cave/Ducks/Duck2"
@onready var duckWorld4_3 = $"World4 - Cave/Ducks/Duck3"
@onready var duckWorld4_4 = $"World4 - Cave/Ducks/Duck4"
@onready var obstacle4_1 = $"World4 - Cave/Obstacales/GoodsWagon2"
@onready var obstacle4_2 = $"World4 - Cave/Obstacales/GoodsWagon"
@onready var obstacle4_3 = $"World4 - Cave/Obstacales/Crystals"
@onready var obstacle4_4 = $"World4 - Cave/Obstacales/Crystals2"

@onready var duckWorld5_1 = $"World5 - Winter/Ducks/Duck2"
@onready var duckWorld5_2 = $"World5 - Winter/Ducks/Duck"
@onready var obstacle5_1 = $"World5 - Winter/Obstacels/brokenBridge"
@onready var obstacle5_2 = $"World5 - Winter/Obstacels/Iceberg"

@onready var duckWorld6_1 = $"World6 - Beach/Ducks/Duck"
@onready var duckWorld6_2 = $"World6 - Beach/Ducks/Duck2"
@onready var duckWorld6_3 = $"World6 - Beach/Ducks/Duck3"
@onready var obstacle6_1 = $"World6 - Beach/Obstacales/BeachWood"
@onready var obstacle6_2 = $"World6 - Beach/Obstacales/BeachWood2"
@onready var obstacle6_3 = $"World6 - Beach/Obstacales/Bushes"

@onready var duckWorld7_1 = $"World7 - City/Ducks/Duck1"
@onready var duckWorld7_2 = $"World7 - City/Ducks/Duck2"
@onready var obstacle7_1 = $"World7 - City/Obstacales/RoadBlock"
@onready var obstacle7_2 = $"World7 - City/Obstacales/CarBlock"

const CAMERA_VERTICAL = 365
const CAMERA_HORIZONTAL = 650 
const LEVEL_INTERACTIONS = [2, 4, 9, 11, 15, 17, 20, 21, 22, 23, 27, 29, 32, 34, 35, 40, 41]

var interactionsList: Array
var obstaclesList : Array
var levelUis : Array

var activeInteraction = false
var lastLevelUi
var disableInteractions = []
var cameraOnChange = false


func _ready():
	levelUis = [uiNodesWorld1, uiNodesWorld2, uiNodesWorld3, uiNodesWorld4,
		uiNodesWorld5, uiNodesWorld6, uiNodesWorld7]
	interactionsList = [duckWorld1_1, duckWorld1_2, duckWorld2_1, duckWorld2_2, 
		duckWorld3_1, duckWorld3_2, duckWorld4_1, duckWorld4_2, duckWorld4_3, duckWorld4_4, 
		duckWorld5_1, duckWorld5_2, duckWorld6_1, duckWorld6_2, duckWorld6_3, 
		duckWorld7_1, duckWorld7_2]
	obstaclesList = [obstacle1_1, obstacle1_2, obstacle2_1, obstacle2_2, 
		obstacle3_1, obstacle3_2, obstacle4_1, obstacle4_2, obstacle4_3, obstacle4_4, 
		obstacle5_1, obstacle5_2, obstacle6_1, obstacle6_2, obstacle6_3, obstacle7_1, 
		obstacle7_2]

	_load_and_update_data()
	Utils.load_game("settings")
	_check_cat_mom_done()
	_set_full_complete()
	_check_interactions_disables()
	_check_start_interactions()

func _process(_delta):	
	changeCamera()
	
	_all_cats_founded()
	
	if LevelManager.levelCleared: 
		make_save_screenshot()
		_show_credits()
	
	if activeInteraction : 
		set_ui_visible(false)
		player.blockMovement = true
	
	if !activeInteraction:
		set_ui_visible(true)
		player.blockMovement = false

func _all_cats_founded():
	var allCatMoms = get_tree().get_nodes_in_group("catMoms")
	
	if allCatMoms.is_empty(): 
		get_tree().change_scene_to_file("res://ui/credits/Credits.tscn")
		
func _load_and_update_data():
	var savedPlayerPosition = GameManager.playerPosition
	
	if savedPlayerPosition != Vector2.ZERO:
		player.position = savedPlayerPosition
		
	_update_camera()
	
	_update_cat_moms()
	
	for levelUi in levelUis:
		var urChildren = levelUi.get_children()
		for ui in urChildren:
			ui.update_ui(GameManager.levelDetails)

func _check_cat_mom_done():
	var allCatMoms = get_tree().get_nodes_in_group("catMoms")
	
	for i in len(GameManager.catMomsDone):
		if i == 6: return
		if GameManager.catMomsDone[i]:
			allCatMoms[i].queue_free()

func _set_full_complete():
	var allLevelTiles = []
	var allLevelDetails = GameManager.levelDetails
	
	for node in get_children():
		if "World" in node.name:
			for worldNodes in node.get_children():
				if "levels" in worldNodes.name:
					for levelNode in worldNodes.get_children():
						if not "start" in levelNode.name:
							allLevelTiles.append(levelNode)
	
	for i in len(allLevelTiles):
		var allRedCoins = allLevelDetails[i].redCoins >= 5
		var allGems = allLevelDetails[i].gems >= 5
		var allCats = len(allLevelDetails[i].cats.filter(func(boolean): return boolean != false)) >= 3
		var allGoldCoins = allLevelDetails[i].goldCoins >= allLevelDetails[i].maxGoldCoins
		
		if allRedCoins && allGems && allCats && allGoldCoins:
			allLevelTiles[i].set_level_full_done()

func _update_camera():
	for mapCamera in $Cameras.get_children():
		var cameraMinWidth = mapCamera.position.x - CAMERA_HORIZONTAL / 2.0
		var cameraMaxWidth = mapCamera.position.x + CAMERA_HORIZONTAL / 2.0
		var cameraMinHeight = mapCamera.position.y - CAMERA_VERTICAL / 2.0
		var cameraMaxHeight = mapCamera.position.y + CAMERA_VERTICAL / 2.0
		
		if (player.position.x > cameraMinWidth && player.position.x < cameraMaxWidth 
			&& player.position.y >cameraMinHeight && player.position.y < cameraMaxHeight):
			camera.position = mapCamera.position

func _update_cat_moms():
	var allCatMoms = get_tree().get_nodes_in_group("catMoms")

	for i in len(allCatMoms):
		var levelData = GameManager.levelDetails.slice(i + i*5, i + 6 + i*5)
		
		var foundedCats = 0
		
		for level in levelData:
			for cat in level["cats"]:
				if cat: foundedCats += 1
				
		allCatMoms[i].catsFounded = foundedCats

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
	
	if !LEVEL_INTERACTIONS.has(startLevelInteraction) || disableInteractions.has(startLevelInteraction): 
		return
	
	activeInteraction = true
	
	var index = LEVEL_INTERACTIONS.find(startLevelInteraction,0)
	_level_interaction(index)
	
func _check_interactions_disables():
	for i in len(LEVEL_INTERACTIONS):
		var level = LEVEL_INTERACTIONS[i]
		var firstTimeClear = LevelManager.activeLevel == level && LevelManager.levelNewClear
		if LevelManager.check_level_already_done(level) && !firstTimeClear:
			disableInteractions.append(level)
			_disable_level_interaction(i)

func _level_interaction(i):
	await get_tree().create_timer(1.5)
	interactionsList[i].move()
	interactionsList[i].connect("interactionDone", interaction_done)

func _disable_level_interaction(i):
	interactionsList[i].visible = false
	var obstacle = obstaclesList[i]

	if obstacle is StaticBody2D || obstacle is Path2D:
		obstacle.done()
	else: 
		for child in obstacle.get_children():
			child.done()
		
		
func set_ui_visible(boolean):
	for ui in levelUis:
		if boolean:
			ui.show()
		else:
			ui.hide()

func interaction_done():
	activeInteraction = false


func make_save_screenshot():
	LevelManager.levelCleared = false
	
	activeInteraction = true
	player.set_control_ui(false)
	screenshotCamera.global_position = player.global_position
	screenshotCamera.make_current()
	screenshotCamera.zoom = Vector2(7.5, 7.5)
	
	await get_tree().create_timer(0.15).timeout
	
	var image = get_viewport().get_texture().get_image()
	image.resize(640, 360)
	image.save_png("user://screenshot"+ str(GameManager.gameNumber) +".png")
	
	var tween = get_tree().create_tween()
	var tween2 = get_tree().create_tween()
	
	tween.tween_property(screenshotCamera, "zoom", Vector2(2,2), 1)
	tween2.tween_property(screenshotCamera, "global_position", camera.global_position, 1)
	
	await get_tree().create_timer(1).timeout
	
	camera.make_current()
	player.set_control_ui(true)
	
	if !LEVEL_INTERACTIONS.has(LevelManager.activeLevel): 	activeInteraction = false

func _show_credits(showCredits = false):
	var gameFullDone = GameManager.full_done_check()
	
	if (gameFullDone && !GameManager.hasFullDone) || showCredits:
		await get_tree().create_timer(1).timeout
		$Cameras/Camera2D/CanvasLayer.layer = 15
		$Cameras/Camera2D/CanvasLayer/CircleTransition.transition("out", 2)
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://ui/credits/Credits.tscn")

func _on_overworld_ui_close_menu():
	activeInteraction = false


func _on_overworld_ui_open_menu():
	activeInteraction = true	

func _on_cat_mom_game_done():
	_show_credits(true)
