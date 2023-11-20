extends Area2D

@export var wayGroup : Node2D


func _ready():
	if wayGroup == null: return
	
	var children = wayGroup.get_children()
	
	for child in children:
		child.disable()
		
func showPath():
	var visibleSpeed = 0.3
	
	if wayGroup == null: return
	
	var children = wayGroup.get_children()
	
	for child in children:
		child.enable()





func _on_body_entered(body):
	if body is Duck:
		await get_tree().create_timer(1).timeout
		visible = false
		showPath()
