extends CharacterBody2D

@onready var animationSprite = $AnimatedSprite2D

const MOVE_SPEED = 60

var minY : float
var maxY : float
var otherSide = false

func _ready():
	_set_bird()
	
	


func _physics_process(_delta):
	if velocity == Vector2.ZERO: 
		velocity = Vector2(-MOVE_SPEED if !otherSide else MOVE_SPEED, MOVE_SPEED)

	if position.y > maxY && velocity.y > 0: 
		velocity.y = -MOVE_SPEED
	elif position.y < minY && velocity.y < 0: 
		velocity.y = MOVE_SPEED
	
	move_and_slide()

func set_spawn_position(playerPosition, viewPortSize):
	position.x = playerPosition.x + (viewPortSize.x / 3.5)
	position.y = playerPosition.y - (viewPortSize.y / 3.5 / 2)
	minY = position.y - 15
	maxY = position.y + 50
	
	if randi() % 2 == 0: 
		otherSide = true
		$AnimatedSprite2D.flip_h = true
		position.x *= -1
		
func _set_bird():
	var parentName = get_parent().name
	
	if "-6" in parentName: 
		animationSprite.scale = Vector2(0.5, 0.5)
		animationSprite.play("bat")
	elif "1-" in parentName: animationSprite.play("hummingbird")
	elif "2-" in parentName: animationSprite.play("crow")
	elif "3-" in parentName: animationSprite.play("cedar_waxwing")
	elif "4-" in parentName: 
		animationSprite.scale = Vector2(0.5, 0.5)
		animationSprite.play("bat")
	elif "5-" in parentName: animationSprite.play("blue_jay")
	elif "6-" in parentName: animationSprite.play("red_robin")
	elif "7-" in parentName: animationSprite.play("white_dove")
