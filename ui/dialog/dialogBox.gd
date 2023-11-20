extends MarginContainer


@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer


const MAX_WIDTH = 256

var text : String
var letterIndex : int
var letterTime = 0.03
var spaceTime = 0.06
var punctuationTime = 0.2


signal finished_displaying()


func display_text(displayText):
	
	text = displayText
	label.text = displayText
	
	await resized
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x resize
		await resized # wait for y resize
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2 # center on x 
	global_position.y -= size.y + 12 # little obove the player
	
	label.text = ""
	
	_display_letter()
	
	
func _display_letter():
	label.text += text[letterIndex]
	
	letterIndex += 1

	if letterIndex >= text.length():
		finished_displaying.emit()
		return
	
	match text[letterIndex]:
		"!", ".", ",", "?": timer.start(punctuationTime)
		" ": timer.start(spaceTime)
		_: timer.start(letterTime)


func _on_letter_display_timer_timeout():
	_display_letter()
