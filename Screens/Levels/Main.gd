extends 'res://Screens/World.gd'

var hint_timer
var tween
var mode = 'Levels'
var solved_100
var progress = []
var progress_level = 1

var dialogue = []
var dialogue_number = 0

var method_100 = [[],[],[],[]]
var previous_methods_100 = []

var success_node 
func _ready():
	pass
func start():
	.start()

	hint_timer = get_node('../HintTimer')
	tween = get_node('../Tween')
	goals = preload("res://Screens/Levels/Goals.tscn")
	solved_100 = get_node('../BaseContainer/VerticalContainer/Upper/GoalContainer/Solved_100')
	setup_dimensions()
	load_database()
	
	load_progress()
	var next_level
	if database.has(str(progress_level)):
		next_level = database[str(progress_level)]
	else:
		next_level = neutral_level
	level_select.value = progress_level
	level_number = progress_level
	current_level.start()
	change_level_number(progress_level)

	
func setup_level(next_level,boo):
	.setup_level(next_level,boo)
	if level_number == progress_level and globals.tips.has(str(progress_level)):
		if progress_level == 100:
			if globals.user_data['100_methods'].size()<1:
				hub.start_tip(str(progress_level))
		else:
			hub.start_tip(str(progress_level))


func next_level():
	if level_number == 100:
		return
	else:
		change_level_number(level_number+1)


func change_level_number(new_level_number):
	var old_level_number = level_number
	hint_timer.start()
	if new_level_number > progress_level:
		update_progress(new_level_number)
	.change_level_number(new_level_number)

	if new_level_number == 100:
		previous_methods_100 = globals.user_data['100_methods']
		solved_100.set_text('Solved: '+str(previous_methods_100.size()))
		hub.hint_box.transparent(true)
#		hub.solved_100.appear()
	elif old_level_number == 100 and new_level_number != 100:
		hub.hint_box.transparent(false)
		hub.solved_100.disappear()
	else:
		hub.solved_100.disappear()

func _on_Editor_pressed():
	get_tree().change_scene("res://Screens/Editor/Editor.tscn")
	pass # replace with function body

func hint():
	if !current_level.resetting and hint!=[null,null]:
		var hint_pos = hint[0]
		var hint_type = hint[1]
		node_positions[hint_pos.y][hint_pos.x].hint(hint_type)
		for operator in operators_holder.operators:
			if operator.value == hint_type:
				operator.hint()
				break
func operate_chain():
	if level_number == 100:
		operate_chain_100()
		return
	else:
		.operate_chain()
func operate_chain_100():
	var numbers = []
	for i in range(select_chain.size()):
		numbers.append(select_chain[i].value)
	numbers.sort()
	var operators = ['+','-','*','/']
	var index = operators.find(current_operator)
	method_100[index] = numbers
	if int(current_operator) > 0:
		operate_specials()
	else:
		var last_node = select_chain[0]
		last_node = select_chain[-1]
		last_node.value = sum
		if last_node.value == goal:
			last_node.pressed(false)
			current_level.pop_nodes(select_chain,false)
			if last_node.drop_amount > 0:
				yield(last_node,'tween_finish')
			success_100(last_node)
		else:
			current_level.pop_nodes(select_chain,false)
			audio_player.stream = pop_sound
			audio_player.play()
			calculator.value = 0
		last_node.select(false)
		operators_holder.off_operator()
		select_chain = []

func success_100(last_node):
	success_node = last_node
	last_node.animation.play('Success')
	calculator.value = 'WIN'
	audio_player.stream = success_sound
	audio_player.play()
	var new = true
	for method in previous_methods_100:
		if method_100 == method:
			new = false
			break

	if new:
		previous_methods_100.append([]+method_100)
		solved_100.set_text('Solved: '+str(previous_methods_100.size()))
		globals.user_data['100_methods'] = previous_methods_100
		globals.save_data()

#func change_current_operator(new_operator):
#	.change_current_operator(new_operator)
#	current_level.change_operator(new_operator)

func load_progress():
	progress_level = globals.user_data['level']

func update_progress(new_level):
	progress_level = new_level
	globals.user_data['level']=new_level
	globals.save_data()


func _on_Infinity_pressed():
	get_node('../').to_infinity()
	pass # replace with function body

func _on_Tween_tween_completed(object, key):
	if !active:
		queue_free()
	pass # replace with function body

func tips(type):
	if get_parent().shadow:
		get_parent().shadow.show()
	tips_mode = true
	dialogue = globals.tips[type]
	dialogue_number = 0
	current_level.tip_box.show()
	current_level.tip_box_label.set_text(dialogue[0])
	pass
	


