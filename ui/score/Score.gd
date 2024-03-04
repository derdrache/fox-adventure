extends CanvasLayer


@onready var titleLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/totalProcent/Label
@onready var goldCoinLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/goldCoinScore/Score
@onready var redCoinLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/redCoinScore/Score
@onready var gemLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/gemScore/Score
@onready var totalScoreEndLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/totalScore/Label2
@onready var catRect = "Control/ScoreBoard/MarginContainer/VBoxContainer/catScore/cat"
@onready var circleTransitionRect = $Control/CircleTransition
@onready var timeLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/time/TimeInMin

var levelName = LevelManager.activeLevelName
var goldCoinsMax = LevelManager.maxGoldCoins

func _ready():
	titleLabel.text = levelName
	goldCoinLabel.text = "0 / " + str(goldCoinsMax)
	
	circleTransitionRect.transition("in", 2)
	await get_tree().create_timer(2).timeout
	
	await _show_score_board()
	
	await get_tree().create_timer(0.5).timeout
	
	circleTransitionRect.transition("out", 2)
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")

func _show_score_board():
	var goldCoins = LevelManager.goldCoins
	var goldCoinsMax = LevelManager.maxGoldCoins
	var redCoins = LevelManager.redCoins
	var gems = LevelManager.gems
	var cats = LevelManager.catArray
	var catCount = len(cats.filter(func(boolean): return boolean != false))
	var totalMaxScore = 5 * 10 + 5 * 10 + 3 * 10 + goldCoinsMax
	var totalScore = redCoins * 10 + gems * 10 + catCount * 10 + goldCoins
	
	var goldCoinProcent = goldCoins * 100 / totalMaxScore
	var redCoinProcent = redCoins * 100 / totalMaxScore
	var gemsProcent = gems * 100 / totalMaxScore
	
	var endTimeInSeconds = Time.get_unix_time_from_datetime_dict(LevelManager.endTime)
	var startTimeInSeconds = Time.get_unix_time_from_datetime_dict(LevelManager.startTime)
	var timeDifference = endTimeInSeconds - startTimeInSeconds
	
	timeLabel.text = HelperFunctions.time_convert(timeDifference, "minutes")
	
	await _gold_coin_animation(goldCoins,  goldCoinsMax)
	await _number_animation(redCoinLabel, redCoins)
	await _number_animation(gemLabel, gems)
	await _cat_animation(cats)

	totalScoreEndLabel.text = str(totalScore * 100 / totalMaxScore) + "%"
	


func _number_animation(label, number):
	for i in number +1:
		label.text = str(i) + " / 5"
		await get_tree().create_timer(0.1).timeout

func _gold_coin_animation(number, maxCoins):
	for i in number +1:
		goldCoinLabel.text = str(i) + " / " + str(maxCoins)
		await get_tree().create_timer(0.025).timeout	

func _cat_animation(cats):
	var catCounter = 0
	
	for i in len(cats):
		if cats[i]:
			catCounter += 1
			var path = catRect + str(i+1)
			var catNode = get_node(path)		
			catNode.set_modulate(Color(1,1,1))
		await get_tree().create_timer(0.25).timeout	

