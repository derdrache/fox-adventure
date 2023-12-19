extends StaticBody2D

@export var flipH = false
@export var flipV = false

var parentIsSwitch = false
var showMushroom = true

func _ready():
	if flipH: $Sprite2D.flip_h = true
	if flipV: $Sprite2D.flip_v = true
	
	parentIsSwitch = _checkParentSwitch()

func _process(delta):
	if parentIsSwitch: showMushroom = get_parent().used
	
	if showMushroom: _activateMushroom()
	else: _deactivateMushroom()

func _on_area_2d_body_entered(body):
	if body is Player:
		var direction = "right"
		if $Sprite2D.flip_h: direction = "left"
		body.mushroomJump(direction)

func _checkParentSwitch():
	var parent = get_parent()
	
	if parent is Switch: return true
	else: return false

func _deactivateMushroom():
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$Area2D.monitoring = false

func _activateMushroom():
	$Sprite2D.visible = true
	$CollisionShape2D.disabled = false
	$Area2D.monitoring = true
