extends "res://Screens/Level.gd"
var minX = 4
var maxX = 0
var minY = 5
var maxY = 0
var level_save = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func start():
	.start()
	level_size = screen_size/1.2
	node = preload("res://Screens/Editor/Node_editor.tscn")
	operators_holder.operator = preload("res://Screens/Editor/Operator_editor.tscn")

func find_dimensions():
	minX = 4
	maxX = 0
	minY = 5
	maxY = 0
	for y in range(node_positions.size()):
		for x in range(node_positions[0].size()):
			if node_positions[y][x] and !node_positions[y][x].is_block:
				if y < minY:
					minY = y
				elif y > maxY:
					maxY = y
				if x < minX:
					minX = x
				elif x > maxX:
					maxX = x
	cull()

func cull():
	for y in range(node_positions.size()):
		for x in range(node_positions[0].size()):
			var out_of_range = y<minY or y>maxY or x<minX or x>maxX
			if out_of_range:
				node_positions[y][x].invis(true)
			else:
				node_positions[y][x].invis(false)
#		while node_positions[y][x].is_block and y<node_positions.size():
#			node_positions[y][x] = null
#			y+=1


func _on_GoalEdit_text_entered(new_text):
	main.currently_editing = null
	main.goal = int(new_text)
	pass # replace with function body


func _on_GoalEdit_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		main.currently_editing = self
	pass # replace with function body
	
func editor_select(boo):
	if boo:
		goal_label.get_parent().set('self_modulate','0796ff')
	else:
		goal_label.get_parent().set('self_modulate','ffffff')
		goal_label.get_node('../GoalEdit').menu_option(3)
