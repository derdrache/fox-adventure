extends Node

@onready var textBoxScene = preload("res://ui/dialog/dialogBox.tscn")

var dialogLines : Array[String] = []
var currentLineIndex = 0
var textBox
var textBoxPosition : Vector2
var isDialogActive = false
var canAdvanceLine = false


func start_dialog(position: Vector2, lines: Array[String]):
	if isDialogActive: return
	
	isDialogActive = true
	dialogLines = lines
	textBoxPosition = position
	
	_show_text_box()
	
	
func _show_text_box():
	textBox = textBoxScene.instantiate()
	textBox.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(textBox)
	textBox.global_position = textBoxPosition
	textBox.display_text(dialogLines[currentLineIndex])
	canAdvanceLine = false
	

func _on_text_box_finished_displaying():
	canAdvanceLine = true

func _unhandled_input(event):
	if (
		event.is_action_pressed("ui_accept") &&
		isDialogActive &&
		canAdvanceLine
	):
		textBox.queue_free()
		
		currentLineIndex += 1
		if currentLineIndex >= dialogLines.size():
			isDialogActive = false
			currentLineIndex = 0
			return
		
		_show_text_box()
