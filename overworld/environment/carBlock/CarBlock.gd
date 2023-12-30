extends Area2D

@onready var parent = get_parent()

var doMove = false
var path : PathFollow2D
var moveSpeed = 50

func _ready():
	if parent is PathFollow2D: path = parent

func _physics_process(delta):
	if doMove: path.progress += moveSpeed * delta


func _on_area_2d_body_entered(body):
	if "Duck" in body.name:
		await get_tree().create_timer(2).timeout
		$SpriteDuck.flip_h = body.flipH
		$SpriteDuck.visible = true
		doMove = true	
