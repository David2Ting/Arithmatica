extends "res://Screens/World.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var tween
var hub 
var operator_select_holder 
var selected_operators = []
var mode = 'Infinity'
var values = {'+':2,'-':2,'*':3,'/':3,'1':2}
var summation_values = {'+':1,'-':-1,'*':3,'/':-1,'1':2}



var completed = false
var selecting_menu = true setget change_selecting_menu
func _ready():

	pass

func start():
	.start()
	randomize()
	tween = get_node('Tween')
	hub = get_node('../')
	operator_select_holder = current_level.get_node('Operator_select_holder')
	setup_dimensions()

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
		elif selecting_menu:
			current_level.operator_select_holder.pressed = false
			if selected_operators.size()>1:
				for operator in selected_operators:
					operator.pressed(false)
				setup_level(selected_operators)
			elif selected_operators.size()==1:
				selected_operators[0].pressed(false)
				selected_operators.clear()
				operator_select_holder.calculate()

func setup_level(operators):
	change_selecting_menu(false)
	current_level.move('forwards')

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

	#randomizing sum

	current_level.create_level(operator_group,sum)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func next_level():
	change_selecting_menu(true)
	current_level.move('to_select')
	completed = true
#	yield(current_level,'move_complete')

	
#func move(type):
#	var x_size = get_node('/root/globals').x_size*1.5
#	if type == 'out':
#		tween.interpolate_property(self,'position',Vector2(0,0),Vector2(x_size,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.start()
#	if type == 'in':
#		tween.interpolate_property(self,'position',Vector2(x_size,0),Vector2(0,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
#		tween.start()

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
		calculate_sum()
	completed = false
func _on_Tween_tween_completed(object, key):
	if !active:
		queue_free()
	pass # replace with function body

func change_selecting_menu(boo):
	current_operator = null
	selecting_menu = boo
#	if boo:
#		infinity_button_label.set_text('Levels')
#	else:
#		infinity_button_label.set_text('Back')