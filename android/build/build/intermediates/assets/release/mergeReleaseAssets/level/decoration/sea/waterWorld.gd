extends NavigationRegion2D

var fishRessource = preload("res://level/decoration/sea/Fishs.tscn")

func _ready():
	var areaPolygons = navigation_polygon.get_outline(0)
	var areaTriangulate = Geometry2D.triangulate_polygon(areaPolygons)
	
	var numberFishs = HelperFunctions.get_area_from_polygon(areaPolygons.duplicate()) / 10000

	for i in numberFishs:
		var randomPoint = HelperFunctions.get_random_point_in_polygon(areaPolygons)
		
		_spawn_fish(randomPoint)
	
func _spawn_fish(point):
	var fishNode = fishRessource.instantiate()
	add_child(fishNode)
	fishNode.global_position = point
