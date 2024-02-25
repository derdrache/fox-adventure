extends Path2D

signal game_done

@onready var foundedCatsLabel = $MessageBox/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var messageBox = $MessageBox
@onready var doneMessageBox = $PathFollow2D/CatMomBody/HeartAnimation
@onready var animationSprite = $PathFollow2D/CatMomBody/AnimatedSprite2D
@onready var pathFollow = $PathFollow2D

@export var catsFounded = 0
@export var world = -1
@export var flipMessageBox = false

const maxCats = 18
const MOVESPEED = 1

var done = false
var direction = Vector2.ZERO

func _ready():
	add_to_group("catMoms")

func _process(_delta):
	_set_founded_cats_label()
	
func _physics_process(_delta):
	if done:
		var oldPosition = $PathFollow2D/CatMomBody.global_position
		pathFollow.progress += MOVESPEED
		var newPosition = $PathFollow2D/CatMomBody.global_position
		direction = oldPosition - newPosition
		_set_animation()

	if pathFollow.progress_ratio == 1: queue_free()

func _clear_away():
	messageBox.visible = false
	done = true
		
	
func _set_founded_cats_label():
	foundedCatsLabel.text = str(catsFounded) + " / " + str(maxCats)

func _set_animation():
	if direction.y > 0: animationSprite.play("run_up")
	elif direction.y < 0: animationSprite.play("run_down")
	elif direction.x < 0: animationSprite.play("run_right")
	elif direction.x > 0: animationSprite.play("run_left")

func _game_done():
	var allCatMoms = get_tree().get_nodes_in_group("catMoms")
	
	return len(allCatMoms) == 1 

func _on_area_2d_body_entered(body):
	if "Player" in body.name:
		messageBox.visible = true
		
		if catsFounded == 18:
			await get_tree().create_timer(0.5).timeout
			body.set_physics_process(false)
			messageBox.visible = false
			doneMessageBox.visible = true
			doneMessageBox.play("heart")
			
			if name == "LastCatMom":
				game_done.emit()
			else: 
				_clear_away()
				await get_tree().create_timer(0.5).timeout
				body.set_physics_process(true)
			


func _on_area_2d_body_exited(body):
	if "Player" in body.name:
		messageBox.visible = false
