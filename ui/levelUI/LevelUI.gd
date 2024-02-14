extends CanvasLayer

@onready var goldCoinLabel = $Control/MarginContainer/VBoxContainer/HBoxContainer/GoldContainer/Label

func _ready():
	LevelManager.gained_gem.connect(update_gem_display)
	LevelManager.gained_red_coin.connect(update_red_coin_display)
	LevelManager.gained_gold_coin.connect(update_gold_coin_display)
	LevelManager.gained_cat.connect(update_cat_display)

func update_gem_display(gems):
	for i in range(gems):
		var path = "Control/MarginContainer/VBoxContainer/HBoxContainer/GemContainer/Gem" + str(i+1)
		var gemRect = get_node(path)
		gemRect.set_modulate(Color(1,1,1))

func update_red_coin_display(coins):
	for i in range(coins):
		var path = "Control/MarginContainer/VBoxContainer/HBoxContainer/RedCoinContainer/RedCoin" + str(i+1)
		var redCoinRect = get_node(path)
		redCoinRect.set_modulate(Color(1,1,1))
		
func update_cat_display(catArray):
	for i in len(catArray):
		if catArray[i]: 
			var path = "Control/MarginContainer/VBoxContainer/HBoxContainer2/CatContainer/Cat" + str(i+1)
			var catRect = get_node(path)		
			catRect.set_modulate(Color(1,1,1))

func update_gold_coin_display(coins):
	goldCoinLabel.text = "x " + str(coins)


func _on_texture_button_pressed():
	LevelManager.reset_all_stats()
	get_tree().change_scene_to_file("res://overworld/overWorld.tscn")
