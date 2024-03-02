extends Area2D
class_name EnterLevelTile

@export var levelDetails : Control
@export var levelFullDone = false
@export var withLevelDoneIcon = true


func _ready():
	if !withLevelDoneIcon: levelFullDone = false
	if levelFullDone: $Sprite2D.visible = true

func set_level_full_done():
	levelFullDone = true
	$Sprite2D.visible = true

func _on_body_entered(body):
	if body is PlayerOverworld && levelDetails:
		levelDetails.visible = true


func _on_body_exited(body):
	if body is PlayerOverworld && levelDetails:
		levelDetails.visible = false
