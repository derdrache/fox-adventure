extends StaticBody2D

@export var flipH = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.flip_h = flipH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
