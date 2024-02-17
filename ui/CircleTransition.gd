extends ColorRect




func transition(direction, duration):
	var circleTransitionShader: ShaderMaterial = get_material()
	var startValue
	var targetValue
	
	if direction == "in":
		startValue = 0.0
		targetValue = 1.0
	elif direction == "out": 
		startValue = 1.0
		targetValue = 0.0
	
	circleTransitionShader.set_shader_parameter("circle_size", startValue)
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(circleTransitionShader, "shader_parameter/circle_size", targetValue, duration)
