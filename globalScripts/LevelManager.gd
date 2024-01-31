extends Node

signal gained_gem(int)
signal gained_red_coin(int)
signal gained_gold_coin(int)
signal gained_cat(Array)

var gems : int
var redCoins : int
var goldCoins : int
var activeLevel : int
var activeLevelPosition : Vector2
var levelNewClear : bool
var catArray: Array = [false, false, false]



func gain_gem(newGem:int):
	gems += newGem
	emit_signal("gained_gem", gems)

func gain_red_coin(newCoin:int):
	redCoins += newCoin
	emit_signal("gained_red_coin", redCoins)

func gain_gold_coin(newCoins:int):
	goldCoins += newCoins
	emit_signal("gained_gold_coin", goldCoins)

func gain_cat(catNumber: int):
	catArray[catNumber-1] = true
	emit_signal("gained_cat", catArray)


func set_level(level : int, position: Vector2):
	reset_all_stats()
	
	activeLevel = level
	activeLevelPosition = position
	
func level_done():
	if activeLevel < 0: print("error level -1")
	var levelFinished = GameManager.getLevelStatus(activeLevel)["isFinished"]
	
	_save_items()

	if !levelFinished: levelNewClear = true
	
	GameManager.change_level_status("isFinished", activeLevel, true)
	GameManager.save_player_position(activeLevelPosition)
	
	Utils.save_game()

func check_level_already_done(level):
	var levelFinished = GameManager.getLevelStatus(int(level))["isFinished"]

	return levelFinished

func _save_items():
	var newLevelData = LevelDataClass.new()
	var oldLevelData = GameManager.getLevelStatus(activeLevel)
	
	newLevelData.level = activeLevel
	newLevelData.isFinished = true
	newLevelData.redCoins = redCoins
	newLevelData.gems = gems
	newLevelData.cats = catArray
	newLevelData.goldCoins = goldCoins
	
	if newLevelData.redCoins < oldLevelData.redCoins:
		newLevelData.redCoins = oldLevelData.redCoins
	if newLevelData.gems < oldLevelData.gems:
		newLevelData.gems = oldLevelData.gems
	
	GameManager.updateLevelData(newLevelData)

func reset_all_stats():
	gems = 0
	redCoins = 0
	goldCoins = 0
	activeLevel = 0
	levelNewClear = false
	catArray = [false, false, false]
