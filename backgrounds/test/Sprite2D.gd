@tool 
extends Sprite2D

func _process(delta):
	get_material().set_shader_parameter("zoom", get_viewport_transform().y.y)

#Connect the item_rect_changed() signal to this function
func _on_Waterfall_item_rect_changed():
	get_material().set_shader_parameter("scale", scale)
