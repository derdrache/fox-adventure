extends StaticBody2D

@export var fullBridge = false

var parentIsSwitch = false

# Called when the node enters the scene tree for the first time.
func _ready():
	parentIsSwitch = _checkParentSwitch()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parentIsSwitch: fullBridge = get_parent().used
	_changeBridge()
	


func _checkParentSwitch():
	var parent = get_parent()
	
	if parent is Switch: return true
	else: return false


func _changeBridge():
	if fullBridge:
		$FullBridgeSprites.visible = true
		$BrokenBridgeSprites.visible = false
		$CollisionShapeFull.disabled = false
		$CollisionShapeBroken.disabled = true
	else:
		$FullBridgeSprites.visible = false
		$BrokenBridgeSprites.visible = true
		$CollisionShapeFull.disabled = true
		$CollisionShapeBroken.disabled = false			
