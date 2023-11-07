extends StaticBody2D
class_name Kiste

var used = false
@export var withGem = false
@export var spawningNode : Node2D


func _ready():
	if spawningNode != null:
		spawningNode.visible = false

func _on_bottom_area_body_entered(body):
	if body is Player:
		if used: return
		used = true
		
		if withGem: await dropGem(body)
		
		if spawningNode != null:
			var hitAnimation = await $boxSprite.hitAnimation()
			spawningNode.visible = true
		else:
			queue_free()
		

func _on_top_area_body_entered(body):
	if body is Player:
		var playerStomps = body.doStomp
		if playerStomps: 
			if withGem: await dropGem(body)
			
			if spawningNode != null:
				spawningNode.visible = true
			else:
				queue_free()


func dropGem(body):
	$CollisionShape2D.set_deferred("disabled", true)
	$boxSprite.visible = false
	$gemSprite.visible = true
	await get_tree().create_timer(0.5).timeout
	$gemSprite.visible = false
	body.pick_gem(body)	

