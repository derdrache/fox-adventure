extends Path2D

@onready var sprite = $PathFollow2D/DuckBody/Sprite2D
@onready var animation = $PathFollow2D/DuckBody/AnimationPlayer
@onready var animationsSprite = $PathFollow2D/DuckBody/AnimationsSprite
@onready var pathFollow = $PathFollow2D

@export var flipH = false 
@export var doMove = false
@export var spriteVisible = true


signal interactionDone


var moveSpeed = 100


func _ready():
	sprite.visible = spriteVisible
	sprite.flip_h = flipH

func _physics_process(delta):
	if doMove: 
		animation.play("fly")
		pathFollow.progress += moveSpeed * delta
	else: 
		if is_instance_valid(animation):
			animation.stop()

	if pathFollow.progress_ratio == 1 && doMove: 
		doMove = false
		await _remove_obstacle_animation()
		emit_signal("interactionDone")	
		queue_free()

func move():
	doMove = true;
		

func _remove_obstacle_animation():
	animationsSprite.visible = true
	animationsSprite.play("idea")
	await get_tree().create_timer(0.5).timeout
	animationsSprite.visible = false
	$PathFollow2D/DuckBody/effectAnimations.play("work")
	await get_tree().create_timer(1.8).timeout
	if is_instance_valid(animationsSprite):
		animationsSprite.visible = true
		animationsSprite.play("notes")
		await get_tree().create_timer(1).timeout
