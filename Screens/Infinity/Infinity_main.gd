extends "res://Screens/World.gd"


var tween
var operator_select_holder 
var selected_operators = []
var mode = 'Infinity'
var values = {'+':2,'-':2,'*':3,'/':3,'1':2}
var summation_values = {'+':1,'-':-1,'*':3,'/':-1,'1':2}
var score = 0


var completed = false
var selecting_menu = true setget change_selecting_menu
func _ready():

	pass

func start():
	.start()
	randomize()
	score = globals.user_data['infinity_score']
	print('score:'+str(score))
	level_select.value = score
	tween = get_node('Tween')
	hub = get_node('../')
	operator_select_holder = current_level.get_node('Operator_select_holder')
	setup_dimensions()
	hub.hint_box.transparent(true)
	hub.reset_box.transparent(true)
	current_level.start()
func _input(INPUT):
	if INPUT.is_action_released('left_click'):
		if pressed and current_operator and !selecting_menu:
			current_level.pop_buffer = false
			pressed = false
			if select_chain.size()>1:
				operate_chain()
			else:
				select_chain[0].select(false)
				calculator.value = 0
		elif pressed and selecting_menu:
			current_level.operator_select_holder.pressed = false
			if selected_operators.size()>1:
				for operator in selected_operators:
					operator.pressed(false)
				setup_level(selected_operators)
			elif selected_operators.size()==1:
				selected_operators[0].pressed(false)
				selected_operators.clear()
				operator_select_holder.calculate()
			pressed = false

func setup_level(operators):
	change_selecting_menu(false)
	current_level.move('forwards')
	hub.reset_box.transparent(false)
	hub.hint_box.transparent(false)
	var operator_group = []
	
	var total_sum_value = 0
	
	for operator in operators:
		if int(operator.value)>0:
			total_sum_value += summation_values['1']
		else:
			total_sum_value += summation_values[operator.value]
			operator_group.append([str(operator.value),2])
	var non_special_size = operator_group.size()
	
	for operator in operators:
		if int(operator.value)>0:
			operator_group.append([str(operator.value),1])
	#randomizing amount on each operator
	var total_value = round(rand_range(0,1+operator_group.size()))
	while total_value > 0:
		var rand = randi()%non_special_size
		operator_group[rand][1] += 1
		total_value -= values[operator_group[rand][0]]
	if total_sum_value < 0:
		total_sum_value = 0
	total_sum_value *= 5
	var sum = 0
	for i in range(5):
		sum += round(rand_range(0,total_sum_value*2+10))
	sum = int(sum / 5)
	level_select.back_sign(true)
	current_level.create_level(operator_group,sum)

func next_level():
	print('next')
	change_selecting_menu(true)
	current_level.move('to_select')
	level_select.back_sign(false)
	completed = true

	if goal_label:
		goal_label.leave(false)
		goal_label = null

func hint():
	if !current_level.resetting:
		var hint_pos = hint[0]
		var hint_type = hint[1]
		node_positions[hint_pos.y][hint_pos.x].hint(hint_type)
	


func _on_Infinity_pressed():
	selected_operators.clear()
	if selecting_menu:
		hub.to_main()
		completed = true
	else:
		change_selecting_menu(true)
		current_level.move('to_select')
		completed = false
	pass # replace with function body

func finish_movement():
	if selecting_menu and completed:
		operator_select_holder.pop(selected_operators)
		selected_operators.clear()
		operator_select_holder.calculate()
		calculate_sum()
	completed = false
func _on_Tween_tween_completed(object, key):
	if !active:
		queue_free()
	pass # replace with function body

func change_selecting_menu(boo):
	current_operator = null
	selecting_menu = boo
	if boo:
		hub.hint_box.transparent(true)
		hub.reset_box.transparent(true)
func add_score(score):
	print(level_select.value)
	print(score)
	level_select.value+=score
	globals.user_data['infinity_score'] = level_select.value
	globals.save_data()
#	if boo:
#		infinity_button_label.set_text('Levels')
#	else:
#		infinity_button_label.set_text('Back')