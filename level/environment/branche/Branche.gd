extends StaticBody2D

@export var flipH = false

var parentIsSwitch = false
var showBranche = true


func _ready():
	$Sprite2D.flip_h = flipH
	parentIsSwitch = _checkParentSwitch()

func _process(delta):
	if parentIsSwitch: showBranche = get_parent().used
	
	if showBranche:
		$Sprite2D.visible = true
		$CollisionShape2D.disabled = false
	else:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
func _checkParentSwitch():
	var parent = get_parent()
	
	if parent is Switch: return true
	else: return false
