extends Camera2D

@export var tileMap: TileMap

@onready var levelTileMap = get_node("../../TileMap")

func _ready():
	var mapRect = levelTileMap.get_used_rect()
	var tileSize = levelTileMap.cell_quadrant_size
	var worldSizeInPixel = mapRect.size * tileSize
	#limit_left = 0
	#limit_top = 100
	#limit_right = worldSizeInPixel.x

