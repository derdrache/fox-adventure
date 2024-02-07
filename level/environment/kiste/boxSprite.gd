extends AnimatedSprite2D


func hitAnimation():
	var animationDuration = 0.3
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position - Vector2(0,5), animationDuration)
	tween.tween_property(self, "position", position + Vector2(0,0), animationDuration)
	await get_tree().create_timer(animationDuration).timeout
	return true
