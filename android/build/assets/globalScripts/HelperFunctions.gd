extends Node

func is_parent_switch(parent):	
	if parent is Switch || parent is treeStomp: return true
	else: return false

func time_convert(time_in_sec, convertion = "hour"):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60)/60
	
	#returns a string with the format "HH:MM:SS"
	if convertion == "hour": return "%02d:%02d:%02d" % [hours, minutes, seconds]
	elif convertion == "minutes": return "%02d:%02d" % [minutes, seconds]

func get_random_point_in_polygon(areaPolygons):
	var areaTriangulate = Geometry2D.triangulate_polygon(areaPolygons)
	var triangleAreas :Array = []
	var sumArea = 0
	
	var i : int
	while i < len(areaTriangulate):
		var point1 = areaPolygons[areaTriangulate[i]]
		var point2 = areaPolygons[areaTriangulate[i+1]]
		var point3 = areaPolygons[areaTriangulate[i+2]]
		var area = get_triangle_area(point1, point2, point3)
		
		triangleAreas.append(area)
		sumArea += area
		
		i = i + 3
	
	var randomTriangleNumber = get_random_triangle(triangleAreas, sumArea)
	var trianglePolygons = areaTriangulate.slice(randomTriangleNumber * 3,randomTriangleNumber * 3+3)
	var trianglePoints = [
		areaPolygons[trianglePolygons[0]],
		areaPolygons[trianglePolygons[1]],
		areaPolygons[trianglePolygons[2]],
		]
	var randomPoint = get_random_point_in_triangle(trianglePoints[0], trianglePoints[1], trianglePoints[2])
	
	return randomPoint

func get_triangle_area(p1, p2, p3):
	return abs((p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + 
	  p3.x * (p1.y - p2.y)) / 2.0);

func get_random_triangle(areaList, sumArea):
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(0, sumArea)
	
	for i in len(areaList):
		if randomNumber - areaList[i] < 0: return i
		else: randomNumber -= areaList[i]

func get_random_point_in_triangle(p1, p2, p3):
	var rng = RandomNumberGenerator.new()
	var r1 = rng.randf_range(0, 1)
	var r2 = rng.randf_range(0, 1)
	
	var x = (1 - sqrt(r1)) * p1.x + (sqrt(r1) * (1 - r2)) * p2.x + (sqrt(r1) * r2) * p3.x
	var y = (1 - sqrt(r1)) * p1.y + (sqrt(r1) * (1 - r2)) * p2.y + (sqrt(r1) * r2) * p3.y
	
	return Vector2(x,y)

func get_area_from_polygon(areaPolygons):
	areaPolygons.append(areaPolygons[0])
	
	var sum1 = 0
	for i in len(areaPolygons):
		if i+1 >= len(areaPolygons): break
		sum1 += areaPolygons[i].x * areaPolygons[i+1].y
	
	var sum2 = 0
	for i in len(areaPolygons):
		if i+1 >= len(areaPolygons): break
		sum2 += areaPolygons[i].y * areaPolygons[i+1].x

	return (sum1 - sum2) / 2
