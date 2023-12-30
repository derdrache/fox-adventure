extends CharacterBody2D
class_name Duck

@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var parent = get_parent()

@export var flipH = false 
@export var doMove = false
@export var spriteVisible = true




signal interactionDone

var path : PathFollow2D
var moveSpeed = 100


func _ready():
	if parent is PathFollow2D: path = parent
	sprite.visible = spriteVisible
	sprite.flip_h = flipH

func _physics_process(delta):
	if path == null: return;
	
	if doMove: 
		animation.play("fly")
		path.progress += moveSpeed * delta
	else: animation.stop()

	if path.progress_ratio == 1: 
		doMove = false
		await _remove_obstacle_animation()
		emit_signal("interactionDone")	
		queue_free()

func move():
	doMove = true;
		

func _remove_obstacle_animation():
	await get_tree().create_timer(2).timeout
