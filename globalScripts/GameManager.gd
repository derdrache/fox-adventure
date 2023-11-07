extends Node

signal gained_cherry(int)
signal gained_gem(int)
signal gained_red_coin(int)
signal gained_gold_coin(int)

var cherries : int
var gems : int
var redCoins : int
var goldCoins : int

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
