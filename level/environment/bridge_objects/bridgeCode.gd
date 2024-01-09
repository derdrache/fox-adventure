extends StaticBody2D

@export var switchReverseEffect = false

var showBridge = false

func _process(_delta):
	var parentIsSwitch = HelperFunctions.is_parent_switch(get_parent())
	
	if parentIsSwitch:
		if switchReverseEffect: showBridge = !get_parent().used
		else: showBridge = get_parent().used
	
	_changeBridge()


func _changeBridge():
	if showBridge:
		$TileMap.modulate.a = 1
		$CollisionShape2D.disabled = false
	else:
		$TileMap.modulate.a = 0.3
		$CollisionShape2D.disabled = true
