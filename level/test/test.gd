extends CharacterBody2D

var direction = Vector2.ZERO

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var tilemap : TileMap = $"../TileMap"
	var serachPosition = position
	#serachPosition.x += 56
	#serachPosition.y += 40
	#print(serachPosition)
	var tileData : TileData = tilemap.get_cell_tile_data(0, tilemap.local_to_map(serachPosition))
	
	if tileData:
		print(serachPosition)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
