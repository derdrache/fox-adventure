extends Node


const LEVEL_COUNT = 42
const MAX_SAVE_FILES = 3

var gameNumber = -1
var levelDetails : Array
var playerPosition = Vector2.ZERO
var playTimeSeconds = 0
var gameStart : Dictionary
var catMomsDone : Array = [false, false, false, false, false, false, false]
var backgroundMusicVolumen : int
var soundEffectsVolumen : int
var levelMaxGoldCoins = {
	"1": 34, "2": 58, "3": 31, "4": 76, "5": 79, "6": 51, "7": 68, "8": 42, 
	"9": 67, "10": 41, "11": 45, "12": 57, "13": 49, "14": 49, "15": 49, 
	"16": 35, "17": 39, "18": 56, "19": 45, "20": 27, "21": 43, "22": 42, 
	"23": 48, "24": 73, "25": 55, "26": 48, "27": 67, "28": 52, "29": 48, 
	"30": 57, "31": 55, "32": 65, "33": 56, "34": 50, "35": 47, "36": 75, 
	"37": 46, "38": 64, "39": 59, "40": 46, "41": 41, "42": 65
}

func _ready():	
	if !levelDetails.is_empty(): return

	levelDetails.resize(LEVEL_COUNT)
	for i in range(LEVEL_COUNT):
		levelDetails.fill({
			"isFinished" : false,
			"redCoins" : 0,
			"gems": 0,
			"cats": [false,false,false],
			"maxGoldCoins": levelMaxGoldCoins[str(i + 1)],
			"goldCoins": 0
		})
		

func updateLevelData(levelData : LevelDataClass):
	levelDetails[levelData["level"] - 1] = {
		"isFinished" : levelData.isFinished,
		"redCoins": levelData.redCoins,
		"gems": levelData.gems,
		"cats": levelData.cats,
		"goldCoins": levelData.goldCoins,
		"maxGoldCoins": levelMaxGoldCoins[str(levelData["level"] + 1)]
	}	
		
func getLevelStatus(level):
	return levelDetails[level -1];
		
func change_level_status(status : String, level : int, newValue):
	levelDetails[level -1][status] = newValue
	
func save_player_position_and_time(position):
	playerPosition = position
	
	var now = Time.get_datetime_dict_from_system()
	var nowSeconds = Time.get_unix_time_from_datetime_dict(now)
	var gameStartSeconds = Time.get_unix_time_from_datetime_dict(gameStart) if !gameStart.is_empty() else 0
	var playedSeconds = nowSeconds - gameStartSeconds
	
	playTimeSeconds += playedSeconds
	
