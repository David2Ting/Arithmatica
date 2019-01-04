extends 'res://Screens/World.gd'

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
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
#	setup_level(next_level,true)
#	hint_timer.start()
	
func setup_level(next_level,boo):
	.setup_level(next_level,boo)
	if level_number == progress_level and globals.tips.has(str(progress_level)):
		hub.start_tip(str(progress_level))
#	if level_number == progress_level:
#		level_select.right.hide()
#	else:
#		level_select.right.show()

func next_level():
	if level_number == 100:
		return
	else:
		change_level_number(level_number+1)

func _input(event):
	if event.is_action_pressed('left_click'):
		if tips_mode:
			if dialogue_number+1 >=dialogue.size():
				tips_mode = false
				current_level.tip_box.hide()
				get_parent().shadow.hide()
			else:
				current_level.tip_box_label.set_text(dialogue[dialogue_number+1])
				dialogue_number+=1

	._input(event)
func change_level_number(new_level_number):
	hint_timer.start()
	if new_level_number > progress_level:
		update_progress(new_level_number)
	.change_level_number(new_level_number)

	if new_level_number == 100:
		solved_100.show()
	else:
		solved_100.hide()

func _on_Editor_pressed():
	get_tree().change_scene("res://Screens/Editor/Editor.tscn")
	pass # replace with function body

func hint():
	if !current_level.resetting:
		var hint_pos = hint[0]
		var hint_type = hint[1]
		node_positions[hint_pos.y][hint_pos.x].hint(hint_type)

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
			success(last_node)
		else:
			current_level.pop_nodes(select_chain,false)
			audio_player.stream = pop_sound
			audio_player.play()
			calculator.value = 0
		last_node.select(false)
		operators_holder.off_operator()
		select_chain = []

func success(last_node):
	success_node = last_node
	last_node.animation.play('Success')
	calculator.value = 'WIN'
	current_level.pop_nodes(select_chain,false)
	audio_player.stream = success_sound
	audio_player.play()
	var new = true
	for method in previous_methods_100:
		print(method)
		if method_100 == method:
			new = false
			break

	print(method_100)
	if new:
		previous_methods_100.append([]+method_100)
		solved_100.set_text('Solved: '+str(previous_methods_100.size()))

func change_current_operator(new_operator):
	.change_current_operator(new_operator)
	current_level.change_operator(new_operator)

func load_progress():
#	progress_file.open(PROGRESS_PATH,File.READ)
#	progress = parse_json(progress_file.get_as_text())
#	progress_file.close()
#	progress_level = progress['level']
	progress_level = globals.user_data['level']

func update_progress(new_level):
	progress_level = new_level
#	progress_file.open(PROGRESS_PATH, File.WRITE)
	globals.user_data['level']=new_level
	globals.save_data()
#		progress_file.store_line(to_json(progress))
#		progress_file.close()

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
	print(dialogue)
	pass
	


