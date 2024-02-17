extends CanvasLayer

@onready var titleScoreLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/totalProcent/Score
@onready var goldCoinLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/goldCoinScore/Score
@onready var redCoinLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/redCoinScore/Score
@onready var gemLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/gemScore/Score
@onready var catLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/catScore/Score
@onready var totalScoreEndLabel = $Control/ScoreBoard/MarginContainer/VBoxContainer/totalScore/Label2
@onready var catRect = "Control/ScoreBoard/MarginContainer/VBoxContainer/catScore/cat"
@onready var circleTransitionRect = $Control/CircleTransition


func _ready():
	circleTransitionRect.transition("in", 2)
	await get_tree().create_timer(2).timeout
	
	_show_score_board()

func _show_score_board():
	var goldCoins = LevelManager.goldCoins
	var goldCoinsMax = LevelManager.maxGoldCoins
	var redCoins =LevelManager.redCoins
	var gems = LevelManager.gems
	var cats = LevelManager.catArray
	var catCount = len(cats.filter(func(boolean): return boolean != false))
	var totalMaxScore = 5 * 10 + 5 * 10 + 3 * 10 + goldCoinsMax
	var totalScore = redCoins * 10 + gems * 10 + catCount * 10 + goldCoins
	
	var goldCoinProcent = goldCoins * 100 / totalMaxScore
	var redCoinProcent = redCoins * 100 / totalMaxScore
	var gemsProcent = gems * 100 / totalMaxScore
	var catsProcent = catCount * 100 / totalMaxScore
	
	await _gold_coin_animation(goldCoins,  goldCoinsMax, totalMaxScore)
	await _number_animation(redCoinLabel, redCoins, totalMaxScore)
	await _number_animation(gemLabel, gems, totalMaxScore)
	await _cat_animation(cats, totalMaxScore)

	totalScoreEndLabel.text = str(totalScore * 100 / totalMaxScore) + "%" 
	
	await get_tree().create_timer(1).timeout	
	
	titleScoreLabel.text = totalScoreEndLabel.text

func _input(event):
	if event.is_action_pressed("ui_accept"): 
		var circleTransitionShader: ShaderMaterial = circleTransitionRect.get_material()
		var tween = get_tree().create_tween()
		
		tween.tween_property(circleTransitionShader, "shader_parameter/circle_size", 0, 2)
		await get_tree().create_timer(2.1).timeout
		
		get_tree().change_scene_to_file("res://overworld/overWorld.tscn")
		queue_free()
		
func _number_animation(label, number, totalScore):
	for i in number:
		var procent = i *10 * 100 / totalScore
		label.text = str(i) + "/ 5" + " = " + str(procent) + "%"
		await get_tree().create_timer(0.1).timeout

func _gold_coin_animation(number, maxCoins, totalScore):
	for i in number:
		var procent = i * 100 / totalScore
		goldCoinLabel.text = str(i) + "/" + str(maxCoins) + " = " + str(procent) + "%"
		await get_tree().create_timer(0.025).timeout	

func _cat_animation(cats, totalScore):
	var catCounter = 0
	
	for i in len(cats):
		if cats[i]:
			catCounter += 1
			var procent = catCounter * 10 * 100 / totalScore
			catLabel.text = " = " + str(procent) + "%"
			
			var path = catRect + str(i+1)
			var catRect = get_node(path)		
			catRect.set_modulate(Color(1,1,1))
		await get_tree().create_timer(0.25).timeout	

