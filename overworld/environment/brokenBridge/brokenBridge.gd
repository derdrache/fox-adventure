extends StaticBody2D

@export var iceBridge = false

var bridgeSprite : Sprite2D

func _ready():
	if iceBridge: bridgeSprite = $iceBridgeBody
	else: bridgeSprite = $bridgeBody
				
func done():
	bridgeSprite.visible = true
	$CollisionShape2D.disabled = true

func _on_area_2d_body_entered(body):
	if "Duck" in body.name:
		await get_tree().create_timer(1.6).timeout
		bridgeSprite.visible = true
		$CollisionShape2D.disabled = true
