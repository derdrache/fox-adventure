extends CanvasLayer

@onready var titleScoreLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/totalProcent/Score
@onready var goldCoinLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/goldCoinScore/Score
@onready var redCoinLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/redCoinScore/Score
@onready var gemLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/gemScore/Score
@onready var totalScoreEndLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/totalScore/Label2
@onready var catRect = "Control/ScoreBoard/MarginContainer/VBoxContainer/catScore/cat"
@onready var circleTransitionRect = $Control/CircleTransition

var goldCoinsMax = LevelManager.maxGoldCoins
var isLoaded = false

func _ready():
	goldCoinLabel.text = "0 / " + str(goldCoinsMax)
	circleTransitionRect.transition("in", 2)
	await get_tree().create_timer(2).timeout
	
	await _show_score_board()
	
	isLoaded = true

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
	var catsProcent = catCount * 100 / totalMaxScore
	
	await _gold_coin_animation(goldCoins,  goldCoinsMax)
	await _number_animation(redCoinLabel, redCoins, totalMaxScore)
	await _number_animation(gemLabel, gems, totalMaxScore)
	await _cat_animation(cats)

	totalScoreEndLabel.text = str(totalScore * 100 / totalMaxScore) + "%" 
	
	await get_tree().create_timer(1).timeout	
	
	titleScoreLabel.text = totalScoreEndLabel.text

func _input(event):
	if event.is_action_pressed("ui_accept") && isLoaded: 
		var circleTransitionShader: ShaderMaterial = circleTransitionRect.get_material()
		var tween = get_tree().create_tween()
		
		tween.tween_property(circleTransitionShader, "shader_parameter/circle_size", 0, 1.9)
		await get_tree().create_timer(2).timeout
		
		get_tree().change_scene_to_file("res://overworld/overWorld.tscn")
		
func _number_animation(label, number, totalScore):
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
			var catRect = get_node(path)		
			catRect.set_modulate(Color(1,1,1))
		await get_tree().create_timer(0.25).timeout	

