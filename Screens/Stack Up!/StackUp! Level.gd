extends "res://Screens/Level.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var first_row = ['1','2','3','4','5']
var first_fall_completed = false
var timer
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func start():
	node = preload("res://Screens/Stack Up!/Node_stack.tscn")
	timer = get_node('Timer')
	add_row()
		
func tween_completed():  #when falling has ended
	pop_buffer = false
	if first_fall_completed:
		first_fall_completed = false


func gravity():
	.gravity()

func reward(type,node,index):
	main.streak+=1
	if 'row':
		var pos = node.pos
		var pos_x = pos.x
		for i in range(main.streak):
			var empty_row = true
			for x in range(max(node_positions[0].size()-1-pos_x,pos_x)):
				var check_pos = pos_x+x+1
				if check_pos < node_positions[0].size() and node_positions[pos.y][check_pos]:
					node_positions[pos.y][check_pos].destroy_prepare()
				check_pos = pos_x-x-1
				if check_pos > -1 and node_positions[pos.y][check_pos]:
					node_positions[pos.y][check_pos].destroy_prepare()
				timer.set_wait_time(0.25)
				timer.start()
				yield(timer,'timeout')
			var chain = []
			for x in range(node_positions[0].size()):
				if node_positions[pos.y][x]:
					empty_row = false
					chain.append(node_positions[pos.y][x])
			chain.append(1)
			main.add_points((chain.size()-1)*2)
	#			if node_positions[pos.y][x]:
	#				node_positions[pos.y][x].destroy()
	#			if pos.y!=0:
	#				for y in range(0,pos.y):
	#					var check_node = node_positions[y][x]
	#					if check_node != null:
	#						check_node.drop_amount+=1
	#			node_positions[pos.y][x] = null
			pop_nodes(chain,false)
			timer.set_wait_time(0.5)
			timer.start()
			yield(timer,'timeout')
			var empty = gravity()
			if empty_row:
				break
			timer.start()
			yield(timer,'timeout')
		add_row()
		main.current_goal_position[index].queue_free()
		main.add_goal(index)

func add_row():
	print(node_positions.size())
	timer.set_wait_time(0.5)
	timer.start()
	yield(timer,'timeout')
	var row = random_row()
	node_size_area = Vector2(328,328)
	node_scale = Vector2(0.8,0.8)
	node_positions.append([])
	for i in range(row.size()):
		var value = row[i]
		var node_instance = node.instance()
		var pos = Vector2(((5-1)*-0.5+i),0.5)*node_size_area
		node_holder.add_child(node_instance)
		node_instance.set_position(pos)
		node_instance.value = value
		node_instance.scale = node_scale
		node_positions[node_positions.size()-1].append(node_instance)
		node_instance.pos = Vector2(i,node_positions.size()-1)
	elevate()
	if node_positions.size()>=6:
		overflow()
func elevate():
	for y in range(node_positions.size()):
		for x in range(node_positions[0].size()):
			if node_positions[y][x]:
				var node = node_positions[y][x]
				node.rise(node_size_area)
				

func random_row():
	var black_list_numbers = main.current_goal+main.next_goal
	var row = []
	for i in range(5):
		var rand = null
		while !rand or black_list_numbers.find(rand)>-1:
			var sum = 0
			for i in range(5):
				sum += randi()%20-5
			rand = sum / 5
		row.append(rand)
	return row

func overflow():
	var damaged = false
	for i in range(node_positions[0].size()):
		if node_positions[0][i]:
			node_positions[0][i].pop()
			damaged = true
	node_positions.pop_front()
	for y in range(node_positions.size()):
		for x in range(node_positions[0].size()):
			if node_positions[y][x]:
				node_positions[y][x].pos = node_positions[y][x].pos - Vector2(0,1)
	return
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
