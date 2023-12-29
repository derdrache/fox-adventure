extends StaticBody2D

@onready var sprite = $Sprite2D

@export var flipH = false
@export var flipV = false

var parentIsSwitch = false
var showMushroom = true

func _ready():
	sprite.flip_h = flipH
	sprite.flip_v = flipV
	
	parentIsSwitch = _checkParentSwitch()

func _process(delta):
	if parentIsSwitch: showMushroom = get_parent().used
	
	$CollisionShape2D.disabled = !showMushroom
	$Area2D.monitoring = showMushroom
	
	if showMushroom: sprite.modulate.a = 1
	else: sprite.modulate.a = 0.25

func _on_area_2d_body_entered(body):
	if body is Player:
		var direction = "right"
		if sprite.flip_h: direction = "left"
		body.mushroomJump(direction)

func _checkParentSwitch():
	var parent = get_parent()
	
	if parent is Switch: return true
	else: return false


