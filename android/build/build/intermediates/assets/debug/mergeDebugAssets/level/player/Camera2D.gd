extends Camera2D

@export var tileMap: TileMap

@onready var levelTileMap : TileMap = get_node("../../TileMap")

func _ready():
	var mapRect = levelTileMap.get_used_rect()
	print(mapRect)
	var tileSize = levelTileMap.cell_quadrant_size
	print(tileSize)
	var worldSizeInPixel = mapRect.size * tileSize
	print(worldSizeInPixel)
	limit_left = 0 
	limit_right = worldSizeInPixel.x + 100

