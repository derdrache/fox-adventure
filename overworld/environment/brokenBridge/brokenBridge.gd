extends Area2D

@export var wayGroup : Node2D

var isComplete = false

func _ready():
	if wayGroup == null: return
	
	var children = wayGroup.get_children()
	
	for child in children:
		child.disable()
		
func _process(_delta):
	if isComplete: $bridgeBody.visible = true
		
func showPath():
	
	if wayGroup == null: return
	
	var children = wayGroup.get_children()
	
	for child in children:
		child.enable()



func _on_body_entered(body):
	if body is Duck:
		await get_tree().create_timer(1).timeout
		$bridgeBody.visible = true
		showPath()
		

