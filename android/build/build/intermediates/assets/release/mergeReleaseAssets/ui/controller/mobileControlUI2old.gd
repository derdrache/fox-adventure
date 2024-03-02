extends CanvasLayer


func _ready():
	if !DisplayServer.is_touchscreen_available():
		visible = false
