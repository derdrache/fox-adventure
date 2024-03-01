extends CharacterBody2D

@onready var birdSprite = $BirdSprite
@onready var batSprite = $BatSprite

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
	var rng = RandomNumberGenerator.new()
	var randomYPosition = rng.randi_range(0, 20.0)
	position.x = playerPosition.x + (viewPortSize.x / 3.5 / 2)
	position.y = playerPosition.y + randomYPosition - (viewPortSize.y / 3.5 / 2)
	
	
	minY = position.y - 15
	maxY = position.y + 50
	
	if randi() % 2 == 0: 
		otherSide = true
		birdSprite.flip_h = true
		birdSprite.rotation_degrees = 36.5
		batSprite.flip_h = true
		position.x *= -1
		
func _set_bird():
	var parentName = get_parent().name
	
	if "-6" in parentName || "4-" in parentName:
		batSprite.visible = true
		birdSprite.visible = false
		batSprite.scale = Vector2(0.5, 0.5)
		batSprite.play("bat")
	elif "1-" in parentName: 
		birdSprite.play("hummingbird")
	elif "2-" in parentName:
		birdSprite.play("crow")
	elif "3-" in parentName: 
		birdSprite.play("cedar_waxwing")
	elif "5-" in parentName: 
		birdSprite.play("blue_jay")
	elif "6-" in parentName: 
		birdSprite.play("red_robin")
	elif "7-" in parentName: 
		birdSprite.play("white_dove")
