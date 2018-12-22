extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var operators_table = [['/','/','/'],['*','5+2','2'],['-','42','-',],['+','+','+'],['+','2','+'],['-','/','-'],['5+2','*','*']]
var operator_positions = []
var packed_operator = preload("res://Screens/Infinity/Operator_infinity_select.tscn")
var pressed = false
onready var  operators_holder = get_node('../Operators_holder')
onready var main = get_node('../../')
onready var selected_operators = main.selected_operators
onready var level = get_parent()
onready var size_area = 170
var finish_buffer = false
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func load_operators():
	operator_positions = []
	for child in get_children():
		child.queue_free()
	for y in range(0,operators_table.size()):
		operator_positions.append([])
		for x in range(0,operators_table[0].size()):
			var operator_instance = packed_operator.instance()
			print(operator_instance)
			add_child(operator_instance)
			operator_positions[y].append(operator_instance)
			var pos = Vector2(((3-1)*-0.5+x),((11-1)*-0.5+y))*size_area
			operator_instance.value = operators_table[y][x]
			operator_instance.set_position(pos)
			operator_instance.pos = Vector2(x,y)
func pop(operators):
	for operator in selected_operators:
		operator_positions[operator.pos.y][operator.pos.x] = null
		operator.pop()
	print(operator_positions)

func gravity():
	for y in range(0,operator_positions.size()):
		for x in range(0,operator_positions[0].size()):
			var y_val = operator_positions.size()-y-1
			if operator_positions[y_val][x]!=null:
				while(y_val!=operator_positions.size()-1) and operator_positions[y_val+1][x]==null:
					operator_positions[y_val][x].drop_amount+=1
					operator_positions[y_val+1][x]=operator_positions[y_val][x]
					operator_positions[y_val][x]=null
					y_val+=1
				operator_positions[y_val][x].pos=Vector2(x,y_val)
	for y in range(operator_positions.size()):
		for x in range(operator_positions[0].size()):
			var check = operator_positions[y][x]
			if check:
				operator_positions[y][x].drop()
			else:
				var operator_instance = packed_operator.instance()
				add_child(operator_instance)
				operator_positions[y][x] = operator_instance
				var pos = Vector2(((3-1)*-0.5+x),((11-1)*-0.5+y))*size_area
				operator_instance.set_position(pos)
				operator_instance.value = get_random()
				operator_instance.pos = Vector2(x,y)

func finish_pop():
	if !finish_buffer:
		finish_buffer = true
		gravity()
		print('finish')
		yield(get_tree().create_timer(.4), "timeout")
		finish_buffer = false

func get_random():
	var rand = randi()%100+1
	if rand < 35:
		return '+'
	elif rand < 70:
		return '-'
	elif rand < 85:
		return '*'
	else:
		return '/'
	

func add(obj):
	if pressed:
		if selected_operators.size()>0:
			if selected_operators.size()>1 and obj == selected_operators[-2]:
				selected_operators[-1].pressed(false)
				selected_operators.pop_back()
			if check_adjacency(selected_operators[-1].pos,obj.pos) and selected_operators.size()<4:
				obj.pressed(true)
				selected_operators.append(obj)
		else:
			obj.pressed(true)
			selected_operators.append(obj)
	calculate()
func calculate():
	for i in range(selected_operators.size()):
		var operator = operators_holder.operators[i]
		operator.value = selected_operators[i].value
		operator.pressed(false)
		operator.on(true)
	for i in range(selected_operators.size(),4):
		var operator = operators_holder.operators[i]
		operator.value = '0'
		operator.pressed(true)
		operator.on(false)
	
func check_adjacency(original_pos, new_pos):
	if abs(original_pos.y-new_pos.y) + abs(original_pos.x-new_pos.x) == 1:
		return true
	else:
		return false


