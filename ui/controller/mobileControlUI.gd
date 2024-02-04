extends CanvasLayer

var touchStartPosition = Vector2.ZERO
var swipePosition = Vector2.ZERO
var lastDirectionInput : String
var keyDict = {}



func _physics_process(delta):
	var screenSize = get_viewport().size
	var newDirectionInput : String
	
	if swipePosition == Vector2.ZERO || touchStartPosition == Vector2.ZERO || touchStartPosition.x > screenSize.x /2: 
		if lastDirectionInput != "": Input.action_release(lastDirectionInput)
		lastDirectionInput = ""
		return
	
	var moveLeft = touchStartPosition.x - swipePosition.x > 0
	var moveRight = touchStartPosition.x - swipePosition.x < 0
	var moveUp = touchStartPosition.y - swipePosition.y > 0
	var moveDown = touchStartPosition.y - swipePosition.y < 0
	
	var hDifference = abs(touchStartPosition.x - swipePosition.x)
	var vDifference = abs(touchStartPosition.y - swipePosition.y)
	
	var diagonalSenstivity = 22.5
	var angleOfInput = rad_to_deg(touchStartPosition.angle_to_point(swipePosition))

	if moveRight && hDifference > 10 && hDifference > vDifference: 
		if abs(angleOfInput) < 20: newDirectionInput = "move_right"
		elif moveUp: newDirectionInput = "touch_right_up" 
		elif moveDown: newDirectionInput = "touch_right_down" 
	elif moveLeft && hDifference > 10 &&  hDifference > vDifference: 
		if abs(angleOfInput) -180 < 20: newDirectionInput = "move_left"
		elif moveUp: newDirectionInput = "touch_left_up"
		elif moveDown: newDirectionInput = "touch_left_down"
	elif moveUp && vDifference > 10 &&  vDifference > hDifference: 
		if abs(angleOfInput) - 90 < 20: newDirectionInput = "move_up"
		elif moveLeft: newDirectionInput = "touch_left_up"
		elif moveRight: newDirectionInput = "touch_right_up" 
	elif moveDown && vDifference > 10 && vDifference > hDifference: 
		if abs(angleOfInput) - 90 < 20: newDirectionInput = "move_down"
		elif moveLeft: newDirectionInput = "touch_left_down"
		elif moveRight: newDirectionInput = "touch_right_down" 
			
	
	if newDirectionInput != lastDirectionInput:
		Input.action_release(lastDirectionInput)
		lastDirectionInput = newDirectionInput

	Input.action_press(newDirectionInput)
	

func _input(event):
	if event is InputEventScreenTouch:
		var screenSize = get_viewport().size
		var onRightSide = event.position.x > screenSize.x /2
		
		if !onRightSide:
			touchStartPosition = event.position
			if event.is_released(): touchStartPosition = Vector2.ZERO
	if event is InputEventScreenDrag:
		var screenSize = get_viewport().size
		var onRightSide = event.position.x > screenSize.x /2
		
		if !onRightSide: swipePosition = event.position
	
		
