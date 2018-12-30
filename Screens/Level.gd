extends Node2D

signal reset_finished


onready var main = get_node('../../../../../')
onready var operators_holder = get_node('../../../Bottom/Container/Operators_holder')
onready var node_positions = main.node_positions
onready var reset_timer = get_node('ResetTimer')
onready var goal_label = main.goal_label
onready var tween = get_node('Tween')

onready var node_holder = get_node('Node_holder')
onready var goal = get_node('Node_holder/Goal')
onready var screen = get_node('Screen')
onready var screen_size = screen.get_texture().get_size()

var tip_box
var tip_box_label
var behind_cell= preload("res://Screens/Behind_cell.tscn")

var prev_node_holder = null
var node = preload('res://Parts/Node.tscn')
var node_scale = 0
var pop_buffer = false
var falling_nodes = false
var calculator

var packed_node_holder = preload("res://Parts/Node_holder.tscn")
var packed_level = [[[1,2,3],[4,5,6],[7,8,9]],['+','+','-','-']]
var level_positions = []
var map = packed_level[0]
var level_operators = packed_level[1]
var node_size_area = 0
var node_size = 0
var node_starting_positions = []
var node_area_position = Vector2(0,-40)
var value = 1 setget change_value
var level_spot_size = Vector2()
var level_size = Vector2()



func start():
	calculator = main.calculator
	level_size = screen_size/1.2
	tip_box_label = get_node('TipBox/Label')
	tip_box = get_node('TipBox')
	pass

func change_value(new_value):
	value = new_value

func tween_completed():
	pop_buffer = false
	
func load_level(map_new,level_operators,goal_num,forwards,hint=[null,null]):
	map = map_new
	var node_centre = Vector2(0,220)
	var node_number_x = map_new[0].size()
	var node_number_y = map_new.size()
#	operators_holder.set_position(Vector2(0,globals.y_size/1.15-(globals.y_size/2)))
	var level_size = (screen_size - Vector2(0,480))/1.1
	node_size_area = min(level_size.x/node_number_x,level_size.y/node_number_y)
	var node_scale_area = node_size_area/400
	node_scale = node_scale_area/1.05
	node_positions = []
	level_positions = []
	
	if node_holder:
		prev_node_holder = node_holder
		node_holder = packed_node_holder.instance()
		node_holder.hide()
		add_child(node_holder)
		if forwards:
			move('forwards')
		else:
			move('backwards')
	else:
		node_holder = packed_node_holder.instance()
		add_child(node_holder)
	#Setting up Nodes
	for y in range(0,map.size()):
		node_positions.append([])
		level_positions.append([])
		for x in range(0,map[0].size()):
			if str(map[y][x]) == '.':
				level_positions[y].append(null)
				node_positions[y].append(null)
				var behind_instance = behind_cell.instance()
				var pos = Vector2(((node_number_x-1)*-0.5+x),((node_number_y-1)*-0.5+y))*node_size_area+node_centre
				behind_instance.set('scale',Vector2(node_scale,node_scale))
				behind_instance.set_position(pos)
				node_holder.add_child(behind_instance)

				continue
			var node_instance = node.instance()
			node_holder.add_child(node_instance)
			var behind_instance = behind_cell.instance()
			node_holder.add_child(behind_instance)
			node_positions[y].append(node_instance)
			node_instance.set('scale',Vector2(node_scale,node_scale))
			behind_instance.set('scale',Vector2(node_scale,node_scale))
			var pos = Vector2(((node_number_x-1)*-0.5+x),((node_number_y-1)*-0.5+y))*node_size_area+node_centre
			level_positions[y].append(pos)
			node_instance.value = map[y][x]
			node_instance.pos = Vector2(x,y)
			node_instance.set_position(pos)
			behind_instance.set_position(pos)
			node_instance.connect('add_node',get_parent(),'add_node')
	node_starting_positions = []+node_positions
	main.node_positions = node_positions
	#Setting up Operators
	for i in range(4):
		var operator = operators_holder.operators[i]

		if i < level_operators.size():
			operator.value = level_operators[i]
			operator.pressed(false)
			operator.on(true)
		else:
			operator.value = '0'
			operator.pressed(true)
			operator.on(false)
	
	#Setting up goal
	goal = node_holder.get_node('Goal')
	goal.value=int(goal_num)
#	goal.show()
	main.change_goal(goal_num,forwards)
	
	#Hints
func pop_nodes(select_chain,is_success):
	for i in range(0,select_chain.size()-1):
		var node = select_chain[i]
		var pos = node.pos
		node_positions[pos.y][pos.x] = null
		if pos.y!=0 and !is_success:
			for y in range(0,pos.y):
				var check_node = node_positions[y][pos.x]
				if check_node != null:
					check_node.drop_amount+=1
		node.pop()
	gravity()

func finish_pop():
	if !pop_buffer:
		pop_buffer = true
		for node in node_holder.get_children():
			if node.is_in_group('nodes'):
				node.drop()

func gravity():
	falling_nodes = false
	var empty = true
	for y in range(0,node_positions.size()):
		for x in range(0,node_positions[0].size()):
			var y_val = node_positions.size()-y-1
			if node_positions[y_val][x]!=null:
				empty = false
				while(y_val!=node_positions.size()-1) and node_positions[y_val+1][x]==null:
					node_positions[y_val+1][x]=node_positions[y_val][x]
					node_positions[y_val][x]=null
					y_val+=1
					falling_nodes = true
				node_positions[y_val][x].pos=Vector2(x,y_val)
	return empty

func reset():
	var reset_group_nodes = [[],[],[],[]]
	var reset_group_operators = [[],[],[],[]]
	var new_nodes = []
	for y in range(map.size()):
		for x in range(map[0].size()):
			var rand = randi()%4
			var given_vector = Vector2(x,y)
			var node_in_position = node_positions[y][x]
			if str(map[y][x]) !=  '.' and (!node_in_position or str(node_in_position.value)!=str(map[y][x])):
				reset_group_nodes[rand].append(given_vector)
	for i in range(4):
		var group = reset_group_nodes[i]
		if group.size()>0:
			new_nodes.append(group)
	reset_group_nodes = new_nodes
	for operator in operators_holder.operators:
		var rand
		if reset_group_nodes.size()<1:
			rand = 0
		else:
			rand = randi()%reset_group_nodes.size()
		reset_group_operators[rand].append(operator)
	reset_level(reset_group_nodes,reset_group_operators)
	main.current_operator = null

	
func reset_level(reset_group_nodes,reset_group_operators):
	for i in range(reset_group_nodes.size()):
		if reset_group_nodes[i].size()>0:
			main.audio_player.stream = main.reset_sound
			main.audio_player.play()

		for node_info in reset_group_nodes[i]:
			var node_in_position = node_positions[node_info.y][node_info.x]
			if !node_in_position:
				var node_instance = node.instance()
				node_instance.set('scale',Vector2(node_scale,node_scale))
				node_holder.add_child(node_instance)
				node_instance.pos = Vector2(node_info.x,node_info.y)
				node_instance.hide()
				node_instance.set_position(level_positions[node_info.y][node_info.x])
				node_instance.value = map[node_info.y][node_info.x]
				if str(map[node_info.y][node_info.x])!='.':
					node_instance.reset('complete')
				node_positions[node_info.y][node_info.x] = node_instance
			elif node_in_position:
				if str(map[node_info.y][node_info.x]) == '/':
					if node_in_position.is_block:
						continue
					else:
						node_in_position.reset('change')
						node_in_position.value = '/'
				elif str(map[node_info.y][node_info.x]) == '.':
					node_in_position.value = '.'
				elif str(node_in_position.value) == '.':
					node_in_position.reset('complete')
					node_in_position.value = map[node_info.y][node_info.x]
				elif str(node_in_position.value) != str(map[node_info.y][node_info.x]):
					node_in_position.reset('change')
					node_in_position.value = map[node_info.y][node_info.x]
				else:
					continue
		for operator_info in reset_group_operators[i]:
			operator_info.reset()
		reset_timer.set_wait_time(0.4-i*0.1)
		reset_timer.start()
		yield(reset_timer,"timeout")
		for node in reset_group_operators[0]:
			pass
	emit_signal("reset_finished")


func move(type):
	main.settled = false
	if type == 'forwards':
		tween.interpolate_property(node_holder,'position',node_area_position+Vector2(level_size.x,0),node_area_position,1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.interpolate_property(node_holder,'scale',Vector2(0.7,0.7),Vector2(1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.interpolate_property(node_holder,'modulate',Color(1,1,1,0.5),Color(1,1,1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.interpolate_property(prev_node_holder,'position',node_area_position,node_area_position+Vector2(-level_size.x,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.interpolate_property(prev_node_holder,'scale',Vector2(1,1),Vector2(0.7,0.7),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.interpolate_property(prev_node_holder,'modulate',Color(1,1,1,1),Color(1,1,1,0.5),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
		yield(get_tree().create_timer(.1), "timeout")
		node_holder.show()
	elif type == 'backwards':
		tween.interpolate_property(node_holder,'position',node_area_position+Vector2(-level_size.x,0),node_area_position,1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.interpolate_property(prev_node_holder,'position',node_area_position,node_area_position+Vector2(level_size.x,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
		yield(get_tree().create_timer(.1), "timeout")
		node_holder.show()
#	elif type == 'exit':
#		tween.interpolate_property(prev_node_holder,'position',Vector2(globals.x_size/2,globals.y_size/2),Vector2(-globals.x_size/2,globals.y_size/2),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.start()
#		yield(tween,'tween_completed')
#		queue_free()

func change_operator(new_operator):
	return
#	if new_operator:
#		level_label.set_text(str(new_operator))
#	else:
#		level_label.set_text(str(main.level_number))

func _on_Tween_tween_completed(object, key):
	if prev_node_holder:
		prev_node_holder.queue_free()
		prev_node_holder = null
	pop_buffer = false
	main.settled = true
	main.calculator.value = 0
	pass # replace with function body
