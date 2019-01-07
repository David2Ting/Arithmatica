extends Node2D

var empty_nodes = [['/','/','/','/'],['/','/','/','/'],['/','/','/','/'],['/','/','/','/'],['/','/','/','/']]
var map = []
var locations = [[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0)],[Vector2(0,1),Vector2(1,1),Vector2(2,1),Vector2(3,1)],[Vector2(0,2),Vector2(1,2),Vector2(2,2),Vector2(3,2)],[Vector2(0,3),Vector2(1,3),null,null],[Vector2(0,4),Vector2(1,4),null,null]]
var starting_area = Vector2()
func _ready():
	map = []+empty_nodes
	pass

func build(chain_group):
	map = [['/','/','/','/'],['/','/','/','/'],['/','/','/','/'],['/','/','/','/'],['/','/','/','/']]
	locations = [[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0)],[Vector2(0,1),Vector2(1,1),Vector2(2,1),Vector2(3,1)],[Vector2(0,2),Vector2(1,2),Vector2(2,2),Vector2(3,2)],[Vector2(0,3),Vector2(1,3),Vector2(2,3),Vector2(3,3)],[Vector2(0,4),Vector2(1,4),Vector2(2,4),Vector2(3,4)]]
	starting_area = Vector2(1,1)
	var check_spot
	var first = true
	for group in chain_group:
		var starting_area_original = locations[starting_area.y][starting_area.x]
		if first:

			first = false
			group[1] = 0
			map[starting_area_original.y][starting_area_original.x] = group[0][group[1]]
		if group[1] == group[0].size()-1:
			locations[starting_area.y][starting_area.x] = '/'
		else:
			locations[starting_area.y][starting_area.x] = null
		check_spot = starting_area
#		print('forward')
		for i in range(group[1]-1,-1,-1):
			check_spot = place_locations(check_spot,group,i)
#			print(group[0][i])
		check_spot = starting_area
#		print('backward')
		for i in range(group[1]+1,group[0].size()):
			check_spot = place_locations(check_spot,group,i)
#			print(group[0][i])
		gravity()
	return create_map()

func place_locations(check_spot,group,i):
	var neighbors = find_adjacent(check_spot)
	var largest_neighbors = []
	var size = 0
	for neighbor in neighbors:
		if find_adjacent(neighbor).size() > size:
			largest_neighbors = [neighbor]
			size = find_adjacent(neighbor).size()
		elif find_adjacent(neighbor).size() == size:
			largest_neighbors.append(neighbor)
	var rand = randi()%largest_neighbors.size()
	check_spot = largest_neighbors[rand]
	var original_location = locations[check_spot.y][check_spot.x]
	map[original_location.y][original_location.x] = group[0][i]
	if i == group[0].size()-1:
		starting_area = check_spot
		locations[check_spot.y][check_spot.x] = '/'
		return
	else:
		locations[largest_neighbors[rand].y][largest_neighbors[rand].x] = null
		return check_spot

func find_adjacent(check_spot):
	var posx = check_spot.x
	var posy = check_spot.y
	var neighbors = []
	for x in range(posx-1,posx+2):
		if x<0 or x>=locations[0].size() or x == posx:
			continue
		elif locations[posy][x] and str(locations[posy][x])!='/':
			neighbors.append(Vector2(x,posy))
	for y in range(posy-1,posy+2):
		if y<0 or y>=map.size() or y == posy:
			continue
		elif locations[y][posx] and str(locations[y][posx])!='/':
			neighbors.append(Vector2(posx,y))
	return(neighbors)

func create_map():
	var new_map = []
	var minX = 4
	var maxX = 0
	var minY = 5
	var maxY = 0
	for y in range(map.size()):
		for x in range(map[0].size()):
			if str(map[y][x])!='/':
				if y < minY:
					minY = y
				elif y > maxY:
					maxY = y
				if x < minX:
					minX = x
				elif x > maxX:
					maxX = x
	for y in range(minY,maxY+1):
		new_map.append([])
		for x in range(minX,maxX+1):
			new_map[y-minY].append(map[y][x])
	return new_map

func gravity():
	for y in range(locations.size()-1,-1,-1):
		for x in range(locations[0].size()):
			if locations[y][x]:
				var check_y = y+1
				while check_y != locations.size() and !locations[check_y][x]:
					locations[check_y][x] = locations[check_y-1][x]
					if starting_area == Vector2(x,check_y-1):
						starting_area = starting_area + Vector2(0,1)
					locations[check_y-1][x] = null
					check_y+=1
				
