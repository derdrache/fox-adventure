extends Path2D

@onready var sprite = $PathFollow2D/DuckBody/Sprite2D
@onready var animation = $PathFollow2D/DuckBody/AnimationPlayer
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
	else: animation.stop()

	if pathFollow.progress_ratio == 1: 
		doMove = false
		await _remove_obstacle_animation()
		emit_signal("interactionDone")	
		queue_free()

func move():
	doMove = true;
		

func _remove_obstacle_animation():
	await get_tree().create_timer(2).timeout
