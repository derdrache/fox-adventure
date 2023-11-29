extends CharacterBody2D
class_name Duck

@export var flipH = false
@onready var parent = get_parent()


signal interactionDone

var path : PathFollow2D
var doMove = false
var moveSpeed = 100


func _ready():
	if parent is PathFollow2D: path = parent
	$Sprite2D.flip_h = flipH

func _physics_process(delta):
	if path == null: return;
	
	if doMove:
		path.progress += moveSpeed * delta

	if path.progress_ratio == 1: 
		doMove = false
		await _remove_obstacle_animation()
		emit_signal("interactionDone")	
		queue_free()

func move():
	doMove = true;
		

func _remove_obstacle_animation():
	await get_tree().create_timer(2).timeout
