extends Area2D

@export var worldTileSet = 0
@export var tilesWith = 4
@export var tilesHeight = 4

@onready var tileMap = $TileMap
@onready var collisionShape = $CollisionShape2D

const tileWorldConverter = {
	0: Vector2i(3,3),
	1: Vector2i(3,3),
	2: Vector2i(1,1),
	3: Vector2i(1,7),
	4: Vector2i(1,1),
	5: Vector2i(1,1),
	6: Vector2i(7,2),
	7: Vector2i(1,4),
}

func _ready():
	if tilesWith == 0 || tilesHeight == 0: return
	for iWidth in tilesWith:
		tileMap.set_cell(0, Vector2(iWidth,0), 0, tileWorldConverter[worldTileSet])
		for iHeight in tilesHeight:
			tileMap.set_cell(0, Vector2(iWidth,iHeight), 0, tileWorldConverter[worldTileSet])

	var width = tilesWith * 16
	var height = tilesHeight * 16
		
	var rect = RectangleShape2D.new()
	$CollisionShape2D.shape = rect	
	collisionShape.shape.size = Vector2(width, height)
	collisionShape.position = Vector2(width / 2.0, height / 2.0)


func _on_body_entered(body):
	if "Player" in body.name:
		$TileMap.visible = false
		set_collision_layer_value(1, false)
