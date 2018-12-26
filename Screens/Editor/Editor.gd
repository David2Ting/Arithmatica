extends "res://Screens/World.gd"

var mode = 'edit'
var currently_editing = null setget change_currently_editing
onready var goal_sign = get_node("Header/Goal")
var progress_level = 100
#onready var level = get_node('Level')

func _ready():
	print(int(15/3))
	packed_level = preload("res://Screens/Editor/Level.tscn")
	setup_dimensions()
	load_database()
	var next_level
	if database.has(str(1)):
		next_level = database[str(1)]
	else:
		next_level = neutral_level
	setup_level(next_level,true)
	current_level.find_dimensions()
	pass

func setup_level(new_level,forward):
	change_currently_editing(null)
	var map = []
	var hint
	if new_level.size()>3:
		hint = new_level[3]
	for y in range(new_level[2].size()):
		map.append([])
		for x in range(new_level[2][y].size()):
			map[y].append(new_level[2][y][x])
#	map = map + new_level[2]
	var level_operators = []+new_level[1]
	change_goal(new_level[0])
	for y in range(map.size()):
		for x in range(map[y].size(),4):
			map[y].append('/')
	for y in range(map.size(),5):
		map.append([])
		for x in range(0,4):
			map[y].append('/')
	for y in range(map.size()):
		for x in range(map[y].size()):
			if str(map[y][x]) == '.':
				map[y][x] = '/'
	for o in range(level_operators.size(),4):
		level_operators.append('0')
	var appended_level = [new_level[0],level_operators,map,hint]
	.setup_level(appended_level,forward)
	current_level.find_dimensions()

func change_currently_editing(new_node):
	if currently_editing:
		currently_editing.editor_select(false)
	if new_node:
		new_node.editor_select(true)
	currently_editing = new_node

func save():
	setup_dimensions()
	var nodes_save = []
	var operators_save = []
	for y in range(current_level.minY,current_level.maxY+1):
		nodes_save.append([])
		for x in range(current_level.minX,current_level.maxX+1):
			if node_positions[y][x].is_block:
				var not_block = true
				for ny in range(0,y):
					if !node_positions[ny][x].is_block:
						not_block = false
						break
				if not_block:
					nodes_save[y-current_level.minY].append('.')
				else:
					nodes_save[y-current_level.minY].append('/')
			else:
				nodes_save[y-current_level.minY].append(node_positions[y][x].value)
	for operator in operators_holder.operators:
		if operator.value != '0':
			operators_save.append(operator.value)

	var level_save = [goal,operators_save,nodes_save,hint]
	print(level_save)
	database[str(level_number)] = level_save
	save_file.open(DATABASE_PATH, File.WRITE)
	save_file.store_line(to_json(database))
	save_file.close()

func change_level_number(new_level_number):
	.change_level_number(new_level_number)

func next_level():
	print('next_level')
func editor_select(boo):
	if boo:
		goal_sign.set('self_modulate','0796ff')
	else:
		goal_sign.set('self_modulate','ffffff')
		goal_sign.get_node('GoalEdit').menu_option(3)




func _on_GoalEdit_text_entered(new_text):
	change_goal(int(new_text))
	change_currently_editing(null)
	pass # replace with function body


func _on_GoalEdit_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		change_currently_editing(self)
	pass # replace with function body


func change_goal(new_goal):
	goal = new_goal
	goal_label.set_text(str(new_goal))
	goal_sign.get_node('LineEdit').menu_option(3)

func _on_Levels_pressed():
	get_tree().change_scene("res://Screens/Levels/Main.tscn")
	pass # replace with function body


func _on_Add_pressed():
	var check_level = level_number
	var stored_level = database[str(check_level)]
	var max_level = check_level
	while database.has(str(max_level)):
		max_level+=1
	for i in range(max_level-level_number):
		check_level = max_level-i
		database[str(check_level)] = database[str(check_level-1)]
	database[str(level_number)] = [0,[],[]]
	change_level_number(level_number)
	
	pass # replace with function body


func _on_Remove_pressed():
	var check_level = level_number
	while database.has(str(check_level+1)):
		database[str(check_level)] = database[str(check_level+1)]
		check_level+=1
	database.erase(str(check_level))
	change_level_number(level_number)
	pass # replace with function body
