extends Control

onready var globals = get_node('/root/globals')
onready var hub = get_node('../')
var audio_player
var operators_holder

var animation 
var level_select

var calculator
var goal_container
var modes 
var modes_timer 
var modes_screen
var goals = preload("res://Screens/Levels/Goals.tscn")
var pressed = false
var select_chain = []
var node_positions = []
var operator = '+'
var sum = 0
var goal_label = null #moving label

var level_size= Vector2()
var operator_size_area = 0
var operator_size = 0.3
var packed_level = preload("res://Screens/Level.tscn")

var pop_sound = preload("res://Sounds/Effects/Pop 1.0.wav")
var success_sound = preload("res://Sounds/Effects/Success_icing.wav")
var reset_sound = preload("res://Sounds/Effects/Blop-Mark_DiAngelo-79054334.wav")

var current_operator = null setget change_current_operator
var level_number = 1 setget change_level_number

var save_file = File.new()
var DATABASE_PATH = "res://Screens/Levels/Levels.json"
var database = {}
var neutral_level = [0,['+','+'],[['/','/','/','/'],['/','/','/','/'],['/','/','/','/'],['/','/','/','/'],['/','/','/','/']]]
var goal = 0 setget change_goal
var current_level
var settled = true
var running_sum = 0
var hint = [null,null]
var active = true
var screen
var mode_menu = false
var tips_mode = false

var progress_file = File.new()
var PROGRESS_PATH = "res://Screens/Progress.json"

func start():
	current_level = get_node('BaseContainer/VerticalContainer/Mid/Container/Level')
	audio_player = get_node('../Audio_Player')
	operators_holder = get_node('../BaseContainer/VerticalContainer/Bottom/Container/Operators_holder')

	animation = get_node('../AnimationPlayer')
	level_select = get_node('../BaseContainer/VerticalContainer/Upper/Top/Level_select')

	calculator = get_node('../BaseContainer/VerticalContainer/Upper/High/CalculatorContainer/Calculator/Label')
	goal_container = get_node('../BaseContainer/VerticalContainer/Upper/GoalContainer/Container/GoalContainer')
	modes = get_node('../BaseContainer/VerticalContainer/Upper/Top/Modes')
	modes_timer = modes.get_node('../ModesTimer')
	modes_screen = get_node('../BaseContainer/ModesScreen')
	current_level = get_node('../BaseContainer/VerticalContainer/Mid/Container/Level')
	screen = get_node('../BaseContainer/VerticalContainer/Mid/Container/Screen')
func _ready():
	randomize()
#	setup_dimensions()
#	setup_level(neutral_level)


func setup_dimensions():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	globals.x_size = window_size.x
	globals.y_size = window_size.y
#	OS.set_window_position(screen_size*0.5 - window_size*0.5)

	operator_size_area = window_size.x/4
	operator_size = (operator_size_area/400)/1.1
	level_size = Vector2(window_size.x/1.2,window_size.y/1.8)
	
#	header.start()

#	current_level.set_position(Vector2(globals.x_size/2,globals.y_size/1.8))
	var level_texture_size = screen.get_texture().get_size()
	var level_scale = min(level_size.x/level_texture_size.x,level_size.y/level_texture_size.y)
#	current_level.set_scale(Vector2(level_scale,level_scale))
	node_positions = current_level.node_positions
	globals.actual_level_size = level_texture_size*level_scale

	

func setup_level(new_level,forwards):
	var map = new_level[2]
	var level_operators = new_level[1]
	var prev_level
	if new_level.size()>3 and new_level[3]!=[null,null] and new_level[3]!=null:
		hint = [Vector2(new_level[3][0][0],new_level[3][0][1]),new_level[3][1]]
	else:
		hint = [null,null]
	print(hint)
#	change_goal(new_level[0])

	node_positions = current_level.node_positions
	current_level.show()
	current_level.load_level(map,level_operators,new_level[0],forwards,hint)

func add_node(obj):
	if pressed and select_chain.size()>0 and (check_adjacency(select_chain[-1],obj)) and current_operator and !obj.is_block:
		if select_chain.size()>1 and select_chain[-2]==obj:
			select_chain[-1].select(false)
			select_chain.pop_back()
			calculate_sum()
		elif select_chain.find(obj)>=0:
			return
		elif current_operator=='/' and (obj.value == 0 or int(running_sum)%int(obj.value) != 0):
			return
		elif str(current_operator)[0] == '2' and (obj.value < 0 or float(sqrt(obj.value))!=int(sqrt(obj.value))):
			return
	
		else:
			print(current_operator)
			select_chain.append(obj)
			obj.select(true)
			calculate_sum()

func _input(INPUT):
#	if INPUT.is_action_pressed('left_click'):
#		if mode_menu:
#			toggle_menu(false)
	if INPUT.is_action_released('left_click'):
		if pressed and current_operator:
			current_level.pop_buffer = false
			pressed = false
			if select_chain.size()>1:
				operate_chain()
			else:
				select_chain[0].select(false)
				calculator.value = 0

func operate_chain():
	if int(current_operator) > 0:
		operate_specials()
	else:
		var last_node = select_chain[0]
		last_node = select_chain[-1]
		last_node.value = sum
		if last_node.value == goal:
			success(last_node)
		else:
			current_level.pop_nodes(select_chain,false)
			audio_player.stream = pop_sound
			audio_player.play()
			calculator.value = 0
		last_node.select(false)
		operators_holder.off_operator()
		select_chain = []

func operate_specials():
	var special = str(current_operator)[0]
	var sub_type = 2
	if str(current_operator).length()>1:
		sub_type = int(current_operator[1])
	for node in select_chain:
		if special == '1':
			node.value = pow(node.value,sub_type)
			node.select(false)
		elif special == '2':
			node.value = sqrt(node.value)
			node.select(false)
		elif special == '3':
			if int(sub_type)<3:
				node.value = int(node.value/pow(10,sub_type))
			else:
				node.value = int(node.value*pow(10,sub_type-2))
			node.select(false)
		elif special == '4':
			node.value = node.value%(int(sub_type)+1)
			node.select(false)
		elif special == '5':
			var num = ''
			var operator = str(current_operator)[1]
			for i in range(2,str(current_operator).length()):
				num = num + str(current_operator)[i]
			
			if operator == '+':
				node.value = node.value+int(num)
			elif operator == '-':
				node.value = node.value-int(num)
			elif operator == '*':
				node.value = node.value*int(num)
			elif operator == '/':
				node.value = node.value/int(num)
			node.select(false)
		if node.value == goal:
			special_success(node)
	operators_holder.off_operator()
	select_chain = []
	calculator.value = 0
	
func special_success(node):
	node.animation.play('Success')
	calculator.value = 'WIN'
	hub.audio_player_2.stream = success_sound
	hub.audio_player_2.play()

func success(last_node):
	last_node.animation.play('Success')
	calculator.value = 'WIN'
	current_level.pop_nodes(select_chain,true)
	hub.audio_player_2.stream = success_sound
	hub.audio_player_2.play()
#	hub.audio_player.stream = pop_sound
#	hub.audio_player.play()


func check_adjacency(first,second):
	var original_pos = first.pos
	var new_pos = second.pos
	if abs(original_pos.y-new_pos.y) + abs(original_pos.x-new_pos.x) == 1:
		return true
	else:
		return false

func calculate_sum():
	if select_chain.size()>0:
		sum = select_chain[0].value
		if int(current_operator)>0:
			var special = str(current_operator)[0]
			var sub_type = 2
			if str(current_operator).length()>1:
				sub_type = int(str(current_operator)[1])
			if special == '1':
				sum = pow(select_chain[-1].value,sub_type)
			elif special == '2':
				sum = sqrt(select_chain[-1].value)
			elif special == '3':
				if int(sub_type)<3:
					sum = int(select_chain[-1].value/pow(10,sub_type))
				else:
					sum = int(select_chain[-1].value*pow(10,sub_type-2))
			elif special == '4':
				sum = select_chain[-1].value%(int(sub_type)+1)
			elif special == '5':
				var num = ''
				var operator = str(current_operator)[1]
				for i in range(2,str(current_operator).length()):
					num = num + str(current_operator)[i]
				
				if operator == '+':
					sum = select_chain[-1].value+int(num)
				elif operator == '-':
					sum = select_chain[-1].value-int(num)
				elif operator == '*':
					sum = select_chain[-1].value*int(num)
				elif operator == '/':
					sum = select_chain[-1].value/int(num)
		else:
			for i in range(1,select_chain.size()):
				var node = select_chain[i]
				if current_operator == '+':
					sum+=node.value
				elif current_operator == '-':
					sum-=node.value
				elif current_operator == '*':
					sum*=node.value
				elif current_operator == '/':
					sum/=node.value
					
		calculator.value = sum
		running_sum = sum
		return sum
	else:
		calculator.value = 0
		running_sum = 0

func disappear():
	pass

func load_database():
	save_file.open(DATABASE_PATH, File.READ)
	database = parse_json(save_file.get_as_text())
	save_file.close()



func change_current_operator(new_operator):
	current_operator = new_operator


func change_level_number(new_level_number):
	level_select.value = new_level_number
	var forwards
	if new_level_number>=level_number:
		forwards = true
	else:
		forwards = false
	level_number = new_level_number
	var new_level
	if database.has(str(new_level_number)):
		new_level = database[str(new_level_number)]
	else:
		new_level = neutral_level
	setup_level(new_level,forwards)

func change_goal(new_goal,forwards = true):
	goal = new_goal
	goals = load("res://Screens/Levels/Goals.tscn")
	var goal_instance = goals.instance()
	if goal_label:
		goal_label.leave(forwards)
	goal_container.add_child(goal_instance)
	goal_instance.value = new_goal
	goal_instance.set_position(Vector2(globals.actual_level_size.x,0))
#	goal_label.set_text(str(new_goal))
	goal_instance.enter(forwards)
	goal_label = goal_instance

func _on_Left_pressed():
	if settled:
		change_level_number(level_number-1)
	pass # replace with function body

func _on_Right_pressed():
	if settled:
		change_level_number(level_number+1)
	pass # replace with function body

func toggle_menu(boo):
	if boo:
		if !mode_menu:
			mode_menu = true
			for i in range(1,3):
				modes.get_children()[i].appear()
				modes_timer.start()
				yield(modes_timer,'timeout')
			modes_screen.show()
		else:
			toggle_menu(false)
		
	else:
		for i in range(2,0,-1):
			modes.get_children()[i].disappear()
			modes_timer.start()
			yield(modes_timer,'timeout')
		mode_menu = false
		modes_screen.hide()
		modes.get_children()[0].get_node('Sprite').set_rotation(0)

func _on_ModesScreen_pressed():
	toggle_menu(false)
	pass # replace with function body

func move(type,forwards = true):
	var tween=get_node('../Tween')
	var x_size = globals.x_size*1.5
	if !forwards:
		x_size = -x_size
	if type == 'out':
		tween.interpolate_property(self,'position',Vector2(0,0),Vector2(-x_size,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
	if type == 'in':
		tween.interpolate_property(self,'position',Vector2(-x_size,0),Vector2(0,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
