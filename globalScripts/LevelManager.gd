extends Node

signal gained_cherry(int)
signal gained_gem(int)
signal gained_red_coin(int)
signal gained_gold_coin(int)

var cherries : int
var gems : int
var redCoins : int
var goldCoins : int
var activeLevel : int
var activeLevelPosition : Vector2
var levelNewClear : int



func gain_gem(newGem:int):
	gems += newGem
	emit_signal("gained_gem", gems)

func gain_cherries(newCherries:int):
	cherries += newCherries
	emit_signal("gained_cherry", cherries)

func gain_red_coin(newCoin:int):
	redCoins += newCoin
	emit_signal("gained_red_coin", redCoins)

func gain_gold_coin(newCoins:int):
	goldCoins += newCoins
	emit_signal("gained_gold_coin", goldCoins)



func set_level(level : int, position: Vector2):
	levelNewClear = 0
	activeLevel = level
	activeLevelPosition = position
	
func level_done():
	if activeLevel < 0: print("error level -1")
	var levelFinished = GameManager.getLevelStatus(activeLevel)["isFinished"]
	
	_save_items()
	
	if !levelFinished: levelNewClear = activeLevel
	GameManager.change_level_status("isFinished", activeLevel, true)
	GameManager.save_player_position(activeLevelPosition)
	
	_reset_all_stats()
	Utils.save_game()

func check_level_already_done(level):
	var levelFinished = GameManager.getLevelStatus(int(level))["isFinished"]
	
	if levelFinished && not levelNewClear: true
	
	return false

func _save_items():
	var newLevelData = LevelDataClass.new()
	var oldLevelData = GameManager.getLevelStatus(activeLevel)
	
	newLevelData.level = activeLevel
	newLevelData.isFinished = true
	newLevelData.redCoins = redCoins
	newLevelData.gems = gems
	
	if newLevelData.redCoins < oldLevelData.redCoins:
		newLevelData.redCoins = oldLevelData.redCoins
	if newLevelData.gems < oldLevelData.gems:
		newLevelData.gems = oldLevelData.gems
	
	GameManager.updateLevelData(newLevelData)

func _reset_all_stats():
	cherries = 0
	gems = 0
	redCoins = 0
	goldCoins = 0
	activeLevel = 0

