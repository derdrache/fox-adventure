extends StaticBody2D
class_name Kiste

@export var withGem = false
@export var withRedCoin = false
@export var goldCoins = 0
@export var spawningNode : Node2D
@export var destroyable = true

var used = false

func _ready():
	if spawningNode != null:
		spawningNode.visible = false

func _on_bottom_area_body_entered(body):
	if body is Player:
		if used: return
		used = true
		
		if withGem: await _dropGem()
		elif withRedCoin: _dropRedCoin()
		elif goldCoins > 0: _dropGoldCoin()
		
		if spawningNode != null:
			var hitAnimation = await $boxSprite.hitAnimation()
			spawningNode.visible = true
		

func _on_top_area_body_entered(body):
	if body is Player:
		var playerStomps = body.doStomp
		if playerStomps: 
			if withGem: _dropGem()
			elif withRedCoin: _dropRedCoin()
			elif goldCoins > 0: _dropGoldCoin()
			
			if spawningNode != null:
				spawningNode.visible = true



func _dropGem():
	$CollisionShape2D.set_deferred("disabled", true)
	$boxSprite.visible = false
	$gemSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$gemSprite.visible = false
	LevelManager.gain_gem(1)
	queue_free()

func _dropRedCoin():
	$CollisionShape2D.set_deferred("disabled", true)
	$boxSprite.visible = false
	$redCoinSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$redCoinSprite.visible = false
	LevelManager.gain_red_coin(1)
	queue_free()

func _dropGoldCoin():
	$CollisionShape2D.set_deferred("disabled", true)
	$boxSprite.visible = false
	$goldCoinSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$goldCoinSprite.visible = false
	LevelManager.gain_gold_coin(1)
	queue_free()
