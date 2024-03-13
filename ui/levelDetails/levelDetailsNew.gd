extends Control

@export var level_name : String
@export var level : int 
@export var levelPath : String
@export var maxGoldCoins : int = 99

@onready var levelNameLabel = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var levelDetails = $PanelContainer/MarginContainer/VBoxContainer/LevelDetails
@onready var gemPath = "PanelContainer/MarginContainer/VBoxContainer/LevelDetails/Gems/gem"
@onready var redCoinPath = "PanelContainer/MarginContainer/VBoxContainer/LevelDetails/RedCoins/redCoin"
@onready var catPath = "PanelContainer/MarginContainer/VBoxContainer/LevelDetails/Cats/cat"
@onready var goldCoinLabel = $PanelContainer/MarginContainer/VBoxContainer/LevelDetails/HBoxContainer2/Label
@onready var percentDoneLabel = $PanelContainer/MarginContainer/VBoxContainer/Label


var showDetails = false

func _ready():
	levelNameLabel.text = level_name
	maxGoldCoins = GameManager.levelMaxGoldCoins[str(level)]

func _input(event):
	if event.is_action_pressed("ui_accept") && visible:
		_enter_level()
		
func _enter_level():
	LevelManager.set_level(level, level_name)
	GameManager.save_player_position_and_time($"../../../PlayerOverWorld".position)
	get_tree().change_scene_to_file(levelPath)

func update_ui(allLevelData):
	var levelData = allLevelData[level -1]
	var gems = levelData["gems"]
	var redCoins = levelData["redCoins"]
	var catsArray : Array = levelData["cats"]
	var catCount = len(catsArray.filter(func(boolean): return boolean != false))
	var goldCoins = levelData["goldCoins"] if 'goldCoins' in levelData else 0
	var fullScore = 50 + 50 + 30 + maxGoldCoins
	var score = gems * 10 + redCoins * 10 + catCount * 10 + goldCoins

	_activate_sprite(gems, gemPath)
	_activate_sprite(redCoins, redCoinPath)		
	_activate_cats(catsArray)	
	_update_gold_coins(goldCoins)	
	
	percentDoneLabel.text = str(floor(score * 100 / fullScore)) + " %"
		
func _activate_sprite(count, spritePath):
	for i in range(count):
		var path = spritePath + str(i+1)
		var itemRect = get_node(path)
		itemRect.set_modulate(Color(1,1,1))		

func _activate_cats(cats):
	for i in len(cats):
		if cats[i]:
			var path = catPath + str(i+1)
			var carRect = get_node(path)
			carRect.set_modulate(Color(1,1,1))	

func _update_gold_coins(goldCoins):
	goldCoinLabel.text = str(goldCoins) + " / " + str(maxGoldCoins)


func _on_texture_button_pressed():
	if showDetails:
		levelDetails.visible = false
	else:
		levelDetails.visible = true		

	showDetails = !showDetails

