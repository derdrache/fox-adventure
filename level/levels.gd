extends Node2D

func _ready():
	_count_gold_coins()

func _count_gold_coins():
	var maxGoldCoins = 0
	var goldCoinObjects = $items/goldCoins.get_children()
	
	for object in goldCoinObjects:
		if "GoldCoin" in object.name:
			maxGoldCoins += 1
		if "kiste" in object.name:
			maxGoldCoins += object.goldCoins	
	
	
