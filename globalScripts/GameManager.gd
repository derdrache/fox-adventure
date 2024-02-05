extends Node


const LEVEL_COUNT = 42
const MAX_SAVE_FILES = 3

var gameNumber = 0
var levelDetails : Array
var playerPosition = Vector2.ZERO
var playTimeSeconds = 0
var gameStart : Dictionary


func _ready():
	gameStart = Time.get_datetime_dict_from_system()
	
	if !levelDetails.is_empty(): return

	levelDetails.resize(LEVEL_COUNT)
	for i in range(LEVEL_COUNT):
		levelDetails.fill({
			"isFinished" : false,
			"redCoins" : 0,
			"gems": 0,
			"cats": [false,false,false],
			"goldCoins": 0
		})

func updateLevelData(levelData : LevelDataClass):
	levelDetails[levelData["level"] - 1] = {
		"isFinished" : levelData.isFinished,
		"redCoins": levelData.redCoins,
		"gems": levelData.gems,
		"cats": levelData.cats,
		"goldCoins": levelData.goldCoins
	}		
		
func getLevelStatus(level):
	return levelDetails[level -1];
		
func change_level_status(status : String, level : int, newValue):
	levelDetails[level -1][status] = newValue
	
func save_player_position_and_time(position):
	playerPosition = position
	
	var now = Time.get_datetime_dict_from_system()
	var nowSeconds = Time.get_unix_time_from_datetime_dict(now)
	var gameStartSeconds = Time.get_unix_time_from_datetime_dict(gameStart)
	var playedSeconds = nowSeconds - gameStartSeconds
	
	playTimeSeconds += playedSeconds
	
