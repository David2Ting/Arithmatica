extends Node

signal queue_free
signal finish_cull
signal mode_changed
var mains = {'Levels':"res://Screens/Levels/Main_isolated.tscn",'Stacks':"res://Screens/Stack Up!/Main_isolated.tscn",'Infinity':"res://Screens/Infinity/Main_isolated.tscn"}
var levels = {'Levels':"res://Screens/Level.tscn",'Stacks':"res://Screens/Stack Up!/StackUp! Level.tscn",'Infinity':"res://Screens/Infinity/Infinity.tscn"}
var operator_holders = {'Levels':"res://Parts/Operators_holder.tscn",'Stacks':"res://Screens/Stack Up!/Operators_holder.tscn",'Infinity':"res://Parts/Operators_holder.tscn"}
var labels = {'Levels':"res://Parts/Level_select.tscn",'Stacks':"res://Screens/Stack Up!/Level_select.tscn",'Infinity':"res://Screens/Stack Up!/Level_select.tscn"}
var mode_labels = {'Levels':['Stacks','Infinity'],'Stacks':['Levels','Infinity'],'Infinity':['Levels','Stacks']}

var mode_menu = false
var mode = 'Levels'
onready var modes = get_node('BaseContainer/VerticalContainer/Upper/Top/Modes')
onready var modes_timer = modes.get_node('ModesTimer')
onready var modes_screen = get_node('BaseContainer/ModesScreen')
onready var level_area = get_node('BaseContainer/VerticalContainer/Mid/Container')
onready var operator_holders_area = get_node('BaseContainer/VerticalContainer/Bottom/Container')
onready var operator_holder_sprite = operator_holders_area.get_node('Sprite')
onready var label_area = get_node('BaseContainer/VerticalContainer/Upper/Top')
onready var goal_container = get_node('BaseContainer/VerticalContainer/Upper/GoalContainer/Container/GoalContainer')
onready var block = get_node('Block')
onready var reset = get_node('BaseContainer/VerticalContainer/Upper/Top/ResetContainer/Reset/Label')
onready var reset_box = reset.get_parent()
onready var high_score = get_node('BaseContainer/VerticalContainer/Upper/Top/ResetContainer/HighScore')
onready var miscellaneous = get_node('Miscellaneous')
onready var tips_box = get_node('TipsContainer')
onready var tips_label = tips_box.get_node('Container/TipsNode/Tips')
onready var tips_screen = get_node('TipsScreen')

onready var audio_player = get_node('Audio_Player')
onready var audio_player_2 = get_node('Audio_Player_2')
onready var music_player = get_node('Music_Player')
onready var hint_box = get_node('BaseContainer/VerticalContainer/Upper/High/RightOption/Hint')
onready var hint_label = get_node('BaseContainer/VerticalContainer/Upper/High/RightOption/Label')

onready var song = preload("res://Sounds/Arithmatica icing.wav")
onready var song_start = preload("res://Sounds/Arithmatica icing start.wav")
var tips
var tip_count = 0
var tip_place
var tip_place_z

var new_main
var new_level
var new_operator_holder
var new_label
func _ready():
	change_mode('Stacks')
	globals.load_data()
	music_player.stream = song_start
	music_player.play()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func change_mode(new_mode):
	on_block(true)

	mode = new_mode
	
	if new_mode == 'Levels':
		reset_box.appear()
		reset_box.transparent(false)
	elif new_mode == 'Infinity':
		reset_box.appear()
		reset_box.transparent(true)
	else:
		reset_box.disappear()
	
	if new_mode == 'Stacks':
		high_score.appear()
		hint_box.type = '?'
		
	else:
		high_score.disappear()
		hint_box.type = 'Hint'
	if new_main:
		cull_previous()
		yield(self,'finish_cull')
	
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
	modes.get_children()[0].value = new_mode
	modes.get_children()[1].value = mode_labels[new_mode][0]
	modes.get_children()[2].value = mode_labels[new_mode][1]
	on_block(false)
	emit_signal('mode_changed')
func cull_previous():
	if new_main:
		new_main.disappear()
	if new_level:
		new_level.disappear()
	if new_operator_holder:
		new_operator_holder.disappear()
	if new_label:
		new_label.disappear()
	for child in goal_container.get_children():
		child.disappear()
	yield(self,'queue_free')
	new_main.queue_free()
	new_level.queue_free()
	new_operator_holder.queue_free()
	new_label.queue_free()
	emit_signal('finish_cull')
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
		modes.get_children()[0].rotate_back()
		for i in range(2,0,-1):
			modes.get_children()[i].disappear()
			modes_timer.start()
			yield(modes_timer,'timeout')
		mode_menu = false
		modes_screen.hide()


func start_tip(type):
	tips_screen.show()
	tips_screen.get_node('AnimationPlayer').play('Tips')
	tips_box.show()
	tips = globals.tips[type]
	tip_count = 0
	tips_next()

func tips_next():
	if tips and tip_count >= tips.size():
		if tip_place:
			tip_place.set('z_index',tip_place_z)
			operator_holder_sprite.set('z_index',-2)
		tips_screen.hide()
		tips_box.hide()
		tips = null
		tip_place = null
		tip_place_z = null
		tip_count = 0
	else:
		tips_label.text = tips[tip_count][0]
		var placing = tips[tip_count][1]
		if tip_place:
			tip_place.set('z_index',tip_place_z)
			operator_holder_sprite.set('z_index',-2)
		if placing == 'goal':
			tip_place = goal_container
		elif placing == 'node_holder':
			tip_place = new_level.node_holder
		elif placing == 'operator_holder':
			tip_place = new_operator_holder
			operator_holder_sprite.set('z_index',2)
		elif placing == 'reset_button':
			tip_place = reset
		elif int(placing) > 0:
			tip_place = new_operator_holder.operators[int(placing)]
		else:
			tip_count+=1
			return
		tip_place_z = tip_place.get('z_index')
		tip_place.set('z_index',2)
		tip_count+=1
	#	tips_box.set_global_position(tip_place.get_global_position())


func on_block(boo):
	if boo:
		block.show()
	else:
		block.hide()

func _on_ModesScreen_pressed():
	toggle_menu(false)
	pass # replace with function body


func _on_Reset_pressed():
	new_level.reset()
	pass # replace with function body


func _on_Reset_button_down():
	reset.set('modulate','8cffffff')
	pass # replace with function body


func _on_Reset_button_up():
	reset.set('modulate','ffffff')
	pass # replace with function body


func _on_TipsScreen_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		tips_next()
	pass # replace with function body





func _on_Hint_pressed():
	new_main.hint()
	pass # replace with function body




func _on_Music_Player_finished():
	music_player.stream = song
	music_player.play()
	pass # replace with function body
