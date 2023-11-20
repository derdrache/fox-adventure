extends Node


const LEVEL_COUNT = 7
var levelDetails : Array
var playerPosition = Vector2.ZERO


func _ready():
	if !levelDetails.is_empty(): return

	levelDetails.resize(LEVEL_COUNT)
	for i in range(LEVEL_COUNT):
		levelDetails.fill({
			"isFinished" : false,
			"redCoins" : 0,
			"gems": 0
		})


func updateLevelData(levelData : LevelDataClass):
	levelDetails[levelData["level"] - 1] = {
		"isFinished" : levelData.isFinished,
		"redCoins": levelData.redCoins,
		"gems": levelData.gems
	}		
		
func getLevelStatus(level):
	return levelDetails[level -1];
		
func change_level_status(status : String, level : int, newValue):
	levelDetails[level -1][status] = newValue
	
func save_player_position(position):
	playerPosition = position

	
