extends StaticBody2D
class_name Kiste

@export var withGem = false
@export var withRedCoin = false
@export var goldCoins = 0
@export var spawningNode : Node2D
@export var destroyable = true

@onready var animationSprite = $boxSprite

var used = false
var isEmpty = false

func _ready():
	if spawningNode != null: _changeSpawningNodeVisibility(false)

		
func _check_content():
		if used: return
		
		if withGem: _dropGem()
		elif withRedCoin: _dropRedCoin()
		elif spawningNode != null:
			used = true
			await animationSprite.hitAnimation()
			_changeSpawningNodeVisibility(true)
		elif goldCoins > 0: _dropGoldCoin()
		else: isEmpty = true	
		
		if isEmpty:	_box_destruction()

func _box_destruction():
	$CollisionShape2D.set_deferred("disabled", true)
	animationSprite.play("destruction")
	await get_tree().create_timer(0.2).timeout
	$BoxDestruction.play()	

func _on_bottom_area_body_entered(body):
	if body is Player && !isEmpty: 
		$HittingWood.play()
		_check_content()

func _on_top_area_body_entered(body):
	if body is Player && !isEmpty:
		var playerStomps = body.doStomp
		if playerStomps: 
			$HittingWood.play()
			_check_content()
			

func _changeSpawningNodeVisibility(show):
	spawningNode.visible = show
	for node : Area2D in spawningNode.get_children():
		node.set_collision_layer_value(1, show)


func _dropGem():
	isEmpty = true
	$specialItemCollect.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$gemSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$gemSprite.visible = false
	LevelManager.gain_gem(1)
	

func _dropRedCoin():
	isEmpty = true
	$specialItemCollect.play()
	$CollisionShape2D.set_deferred("disabled", true)
	$redCoinSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$redCoinSprite.visible = false
	LevelManager.gain_red_coin(1)
	

func _dropGoldCoin():
	$normalItemCollect.play()
	goldCoins -= 1
	gain_gold_coin()
	
	if goldCoins == 0: isEmpty = true

func gain_gold_coin():
	$goldCoinSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$goldCoinSprite.visible = false
	LevelManager.gain_gold_coin(1)	


func _on_box_sprite_animation_finished():
	queue_free()
