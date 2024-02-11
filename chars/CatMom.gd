extends Path2D

@onready var foundedCatsLabel = $MessageBox/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var messageBox = $MessageBox

@export var catsFounded = 0

const maxCats = 16
const MOVESPEED = 100

func _ready():
	add_to_group("catMoms")

func _process(delta):
	_set_founded_cats_label()
	
func _physics_process(delta):
	$PathFollow2D.progress += MOVESPEED * delta	

func _clear_away():
	if catsFounded == maxCats: 
		print(catsFounded)
		$PathFollow2D.progress += MOVESPEED
	
func _set_founded_cats_label():
	foundedCatsLabel.text = str(catsFounded) + " / " + str(maxCats)


func _on_area_2d_body_entered(body):
	if "Player" in body.name:
		messageBox.visible = true


func _on_area_2d_body_exited(body):
	if "Player" in body.name:
		messageBox.visible = false
