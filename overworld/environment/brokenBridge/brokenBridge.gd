extends StaticBody2D

@export var iceBridge = false

var isComplete = false
var bridgeSprite : Sprite2D

func _ready():
	if iceBridge: bridgeSprite = $iceBridgeBody
	else: bridgeSprite = $bridgeBody

		
func _process(_delta):
	if isComplete: bridgeSprite.visible = true
		

func _on_area_2d_body_entered(body):
	if body is Duck:
		await get_tree().create_timer(1).timeout
		bridgeSprite.visible = true
		$CollisionShape2D.disabled = true
