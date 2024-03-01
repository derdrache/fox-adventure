extends ParallaxBackground

@export var loop = false

func _process(delta):
	if loop:  scroll_offset.x -= 100*delta

