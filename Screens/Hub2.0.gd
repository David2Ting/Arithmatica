extends Control


var mains = {'Levels':"res://Screens/Levels/Main_isolated.tscn",'Stacks':"res://Screens/Stack Up!/Main_isolated.tscn"}
var levels = {'Levels':"res://Screens/Level.tscn",'Stacks':"res://Screens/Stack Up!/StackUp! Level.tscn"}
var operator_holders = {'Levels':"res://Parts/Operators_holder.tscn",'Stacks':"res://Screens/Stack Up!/Operators_holder.tscn"}
var labels = {'Levels':"res://Parts/Level_select.tscn",'Stacks':"res://Screens/Stack Up!/Level_select.tscn"}
var mode_labels = {'Levels':['Stacks','Infinity'],'Stacks':['Levels','Infinity'],'Infinity':['Levels','Stacks']}

var mode_menu = false
var mode = 'Levels'
onready var modes = get_node('BaseContainer/VerticalContainer/Top/Modes')
onready var modes_timer = modes.get_node('ModesTimer')
onready var modes_screen = get_node('BaseContainer/ModesScreen')
onready var level_area = get_node('BaseContainer/VerticalContainer/Mid/Container')
onready var operator_holders_area = get_node('BaseContainer/VerticalContainer/Bottom/Container')
onready var label_area = get_node('BaseContainer/VerticalContainer/Top')
onready var goal_container = get_node('BaseContainer/VerticalContainer/GoalContainer/Container/GoalContainer')
var new_main
var new_level
var new_operator_holder
var new_label
func _ready():
	change_mode('Levels')
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func change_mode(new_mode):
	mode = new_mode
	cull_previous()
	yield(get_tree().create_timer(0.5),'timeout')
	new_main = load(mains[new_mode]).instance()
	new_level = load(levels[new_mode]).instance()
	new_operator_holder = load(operator_holders[new_mode]).instance()
	new_label = load(labels[new_mode]).instance()
	add_child(new_main)
	level_area.add_child(new_level)
	operator_holders_area.add_child(new_operator_holder)
	label_area.add_child(new_label)
	new_main.start()
	new_operator_holder.start()
	new_label.start()
	
	modes.get_children()[1].value = mode_labels[new_mode][0]
	modes.get_children()[2].value = mode_labels[new_mode][1]
	

func cull_previous():
	if new_main:
		new_main.queue_free()
	if new_level:
		new_level.queue_free()
	if new_operator_holder:
		new_operator_holder.queue_free()
	if new_label:
		print('die')
		new_label.queue_free()
	for child in goal_container.get_children():
		child.queue_free()
	pass

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
