extends "res://Screens/Level.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var transition_timer = get_node('TransitionTimer')
var first_row = ['1','2','3','4','5']
var first_fall_completed = false
var number_counts = {}
var black_list_numbers_counts = []
var black_list_numbers = []
var timer
signal drop_completed
signal tween_completed
signal pop_finish
var is_falling = false


func _ready():
	pass

func start():
	.start()
	node = preload("res://Screens/Stack Up!/Node_stack.tscn")
	timer = get_node('Timer')

		
func tween_completed():  #when falling has ended
	pop_buffer = false
	if falling_nodes:
		if first_fall_completed:
			first_fall_completed = false
		is_falling = false
	falling_nodes = false
	emit_signal('tween_completed')



func disappear():
#	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	var level_size_x = globals.x_size
	var current_position = node_holder.get_position()
	tween.interpolate_property(node_holder,'position',current_position,current_position+Vector2(level_size_x,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	hub.emit_signal('queue_free')

func reward(type,node,index):
	main.streak+=1
	if type == 'row':
		var pos = node.pos
		var pos_x = pos.x
		for i in range(main.streak):
			var empty_row = false
			var chain = []
			var check_pos_right = pos_x
			var check_pos_left = pos_x
			for x in range(max(node_positions[0].size()-1-pos_x,pos_x)):
				check_pos_right+=1
				var all_prepared = true
				while check_pos_right<node_positions[0].size() and !node_positions[pos.y][check_pos_right]:
					check_pos_right+=1
				if check_pos_right<node_positions[0].size():
#				if check_pos < node_positions[0].size() and node_positions[pos.y][check_pos]:
					node_positions[pos.y][check_pos_right].destroy_prepare()
					chain.append(node_positions[pos.y][check_pos_right])
					all_prepared = false
				check_pos_left -= 1
				while check_pos_left >= 0 and !node_positions[pos.y][check_pos_left]:
					check_pos_left-=1
				if check_pos_left>=0:
#				if check_pos > -1 and node_positions[pos.y][check_pos]:
					node_positions[pos.y][check_pos_left].destroy_prepare()
					chain.append(node_positions[pos.y][check_pos_left])
					all_prepared = false

				timer.set_wait_time(0.18)
				timer.start()
				yield(timer,'timeout')
				if all_prepared:
					break
#			timer.set_wait_time(0.2)
#			timer.start()
#			yield(timer,'timeout')

			if chain.size()==0 or !check_above(chain):
				chain.append(node_positions[pos.y][pos.x])
				empty_row = true
			elif i == main.streak-1:
				chain.append(node_positions[pos.y][pos.x])
				empty_row = true
			if chain.size()>0:
				hub.audio_player.stream = main.pop_sound
				hub.audio_player.play()
			
			chain.append(1)
			main.add_points((chain.size()-1)*5)
	#			if node_positions[pos.y][x]:
	#				node_positions[pos.y][x].destroy()
	#			if pos.y!=0:
	#				for y in range(0,pos.y):
	#					var check_node = node_positions[y][x]
	#					if check_node != null:
	#						check_node.drop_amount+=1
	#			node_positions[pos.y][x] = null
			pop_nodes(chain,false)
#			var empty = gravity()
#			if empty:
#				print('break')
#				break
#			yield(self,'drop_completed')
			var completely_empty = true
#
#			if i == main.streak-1:
#				if !pop_nodes([node_positions[pos.y][pos.x],1],false):
#					if !empty:
#						empty = 0
#					else:
#						empty = 1
#				else:
#					empty = 1


#						if node_positions[y][x].drop_amount>0:
#							empty = false
#			if !not_empty:
##				if node_positions[pos.y][pos.x]:
##					pop_nodes([node_positions[pos.y][pos.x],1],false)
##					empty_row = true
##				else:
#					break
#			if empty:
#				print('empty')
#				pop_nodes([node_positions[pos.y][pos.x],1],false)
#				break
#			if is_falling:
#			if falling_nodes:
#				yield(self,'tween_completed')

#			if empty_row:
#				break
			var falling = false
			for y in range(node_positions.size()):
				for x in range(node_positions[0].size()):
					if node_positions[y][x]:
						if node_positions[y][x].is_moving or node_positions[y][x].drop_amount>0:
							falling = true
						completely_empty = false
			if falling:
				yield(self,'tween_completed')
			if completely_empty:
				break
			if empty_row:
				break

		if popping_nodes:
			yield(self,'pop_finish')
		main.current_goal_position[index].death()
		print('add')
		main.add_goal(index)

func pop_nodes(select_chain,is_success):
	var node
	var empty = true
	for i in range(0,select_chain.size()-1):
		node = select_chain[i]
		var pos = node.pos
		node_positions[pos.y][pos.x] = null
		if pos.y!=0 and !is_success:
			for y in range(0,pos.y):
				var check_node = node_positions[y][pos.x]
				if check_node != null:
					empty = false
					check_node.drop_amount+=1
					falling_nodes = true
		node.pop()
	gravity()
	if empty:
		emit_signal('pop_finish')
		return false
	popping_nodes = true
	yield(node,'pop_finish')
	emit_signal('pop_finish')
	popping_nodes = false
	for node in node_holder.get_children():
		if node.is_in_group('nodes'):
			node.drop()
	return falling_nodes

func check_above(chain):
	for node in chain:
		var pos = node.pos
		if pos.y-1>=0 and node_positions[pos.y-1][pos.x] and chain.find(node_positions[pos.y-1][pos.x])==-1:
			return true
	return false

func finish_pop():
	pass

func add_row():
#	timer.set_wait_time(0.25)
#	timer.start()
#	yield(timer,'timeout')
	var row = random_row()
	node_size_area = 328
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
	black_list_numbers = main.current_goal+main.next_goal+black_list_numbers_counts
	var row = []
	for i in range(5):
		var rand = null
		while !rand or black_list_numbers.find(rand)>-1:
			var sum = 0
			for i in range(5):
				sum += randi()%20-5
			rand = sum / 5
		row.append(rand)
		if number_counts.has(str(rand)):
			number_counts[str(rand)]+=1
			if number_counts[str(rand)] > 3:
				black_list_numbers_counts.append(rand)
				black_list_numbers.append(rand)
		else:
			number_counts[str(rand)]=1
	return row

func overflow():
	var damaged = false
	for i in range(node_positions[0].size()):
		if node_positions[0][i]:
#			node_positions[0][i].pop()
			damaged = true
	node_positions.pop_front()
	if damaged:
		main.game_over()
	else:
		for y in range(node_positions.size()):
			for x in range(node_positions[0].size()):
				if node_positions[y][x]:
					node_positions[y][x].pos = node_positions[y][x].pos - Vector2(0,1)
	
	return

func reset():
	main.reset()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
