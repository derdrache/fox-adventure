extends Panel
class_name LevelDetailsUI

@export var level_name : String = ""
@export var level : int 
@export var levelPath : String


func _ready():
	$RichTextLabel.text = "[center] "+ level_name

func _on_button_pressed():
	LevelManager.set_level(level, $"../../playerOverWorld".position)
	get_tree().change_scene_to_file(levelPath)
	
func update_ui(allLevelData):
	var levelData = allLevelData[level -1]
	var gems = levelData["gems"]
	var redCoins = levelData["redCoins"]
	
	_activate_sprite(gems, "GemPanel/gem")
	_activate_sprite(redCoins, "RedCoinPanel/redCoin")		
		
		
func _activate_sprite(count, spritePath):
	for i in range(count):
		var path = spritePath + str(i+1)
		var gemSprite = get_node(path)
		gemSprite.set_modulate(Color(1,1,1))		
