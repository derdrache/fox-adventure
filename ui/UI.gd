extends CanvasLayer


func _ready():
	LevelManager.gained_cherry.connect(update_cherry_display)
	LevelManager.gained_gem.connect(update_gem_display)
	LevelManager.gained_red_coin.connect(update_red_coin_display)
	LevelManager.gained_gold_coin.connect(update_gold_coin_display)

func update_cherry_display(cherries):
	$CherryCount/Label.text = "x " + str(cherries)

func update_gem_display(gems):
	for i in range(gems):
		var path = "GemCounter/gem" + str(i+1)
		var gemRect = get_node(path)
		gemRect.set_modulate(Color(1,1,1))

func update_red_coin_display(coins):
	for i in range(coins):
		var path = "RedCoinCounter/redCoin" + str(i+1)
		var gemRect = get_node(path)
		gemRect.set_modulate(Color(1,1,1))

func update_gold_coin_display(coins):
	$GoldCoinCounter/Label.text = "x " + str(coins)
