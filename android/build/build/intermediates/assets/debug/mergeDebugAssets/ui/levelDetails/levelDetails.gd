extends CanvasLayer
class_name LevelDetailsUI

@export var level_name : String = ""
@export var level : int 
@export var levelPath : String

@onready var gemPath = "Panel/VBoxContainer/Gems/GemPanel/MarginContainer/Gems/gem"
@onready var redCoinPath = "Panel/VBoxContainer/RedCoins/RedCoinPanel/MarginContainer/RedCoins/redCoin"
@onready var catPath = "Panel/VBoxContainer/Cats/RedCoinPanel/MarginContainer/Cats/cat"

func _ready():
	$Panel/VBoxContainer/Title/Label.text = level_name
	
	
func _input(event):
	if event.is_action_pressed("ui_accept") && visible: _on_button_pressed()

func _on_button_pressed():
	LevelManager.set_level(level, $"../../../playerOverWorld".position)
	GameManager.save_player_position($"../../../playerOverWorld".position)
	get_tree().change_scene_to_file(levelPath)
	
func update_ui(allLevelData):
	var levelData = allLevelData[level -1]
	var gems = levelData["gems"]
	var redCoins = levelData["redCoins"]
	var cats = levelData["cats"]
	
	_activate_sprite(gems, gemPath)
	_activate_sprite(redCoins, redCoinPath)		
	_activate_cats(cats)	
		
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
