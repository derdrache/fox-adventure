extends CharacterBody2D

@onready var animatedSprite = $AnimatedSprite2D
@onready var navigator = $NavigationAgent2D

const SPEED = 30.0

var rng = RandomNumberGenerator.new()

func _ready():
	_set_random_sprite()
	
	navigator.target_position = _get_random_position()
	
	set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	set_physics_process(true)

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	direction = (navigator.get_next_path_position() - global_position).normalized()
	velocity = direction * SPEED
	
	_animation()
	
	move_and_slide()

func _animation():
	if velocity.x > 0: $AnimatedSprite2D.scale.x = 1
	else: $AnimatedSprite2D.scale.x = -1	

func _set_random_sprite():
	var my_random_number = rng.randi_range(0, 2)
	
	if my_random_number == 0: animatedSprite.play("jellyFish")
	elif my_random_number == 1: animatedSprite.play("orange_fish")
	elif my_random_number == 2: animatedSprite.play("purple_fish")	

func _get_random_position():
	var areaPolygons = get_parent().navigation_polygon.get_outline(0)
	return HelperFunctions.get_random_point_in_polygon(areaPolygons)


func _on_navigation_agent_2d_navigation_finished():
	navigator.target_position = _get_random_position()
