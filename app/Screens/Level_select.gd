extends TextureButton

onready var label = get_node('Label')
var main
var value = 1 setget change_value
onready var line_edit = get_node('LineEdit')

onready var left = get_node('Left')
onready var right = get_node('Right')
onready var tween = get_node('Tween')
onready var left_sprite = left.get_node('Sprite')
onready var right_sprite = right.get_node('Sprite')
onready var timer = get_node('Timer')
var reset = false
var level_number
func start():
	main = get_node('../../../../../Main')
	tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()

func disappear():
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()

func change_value(new_value):
	var old_value = value
	set_value(new_value)
	if new_value == 1:
		left.hide()
	else:
		left.show()
	if new_value >=globals.user_data['level']:
		right.hide()
	else:
		right.show()

func set_value(new_value):
	var old_value = value
	value = new_value
	label.set_text(str(new_value))
	if new_value == 100:
		label.get('custom_fonts/font').set('size',45)
	elif new_value != 100 and old_value == 100:
		label.get('custom_fonts/font').set('size',55)

	if new_value == 1:
		left.set('modulate',Color(1,1,1,0))
	else:
		left.set('modulate',Color(1,1,1,1))
		left.show()
	if new_value >=globals.user_data['level']:
		right.set('modulate',Color(1,1,1,0))
	else:
		right.set('modulate',Color(1,1,1,1))
		right.show()

	
#	if new_value >= main.progress_level:
#		right.hide()
#	else:
#		right.show()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#
#func _on_LineEdit_text_entered(new_text):
#	main.level_number = int(new_text)
#	line_edit.menu_option(3)
#	pass # replace with function body
#
#
#func _on_Level_select_pressed():
#	print('test')
#	label.set_position(Vector2(0,0))
#	pass # replace with function body
#
##
#func _on_Level_select_button_up():
#	label.set_position(Vector2(0,0))
#	pass # replace with function body
#
#
#func _on_Level_select_button_down():
#	print('tests')
#	label.set_position(Vector2(0,26.51))
#	pass # replace with function body

#
#func _on_Level_select_gui_input(ev):
#	if ev.is_action_pressed('left_click'):
#		print('left')
#	pass # replace with function body


func _on_LineEdit_text_entered(new_text):
	main.level_number = int(new_text)
	line_edit.menu_option(3)
	pass # replace with function body


func _on_Left_pressed():
	return
#	main.level_number -= 1
	pass # replace with function body


func _on_Right_pressed():
#	main.level_number += 1
	pass # replace with function body


func _on_Left_button_down():
	left_sprite.set('self_modulate','8cffffff')
	reset = false
	level_number = main.level_number - 1
	set_value(level_number)
	timer.set_wait_time(1)
	timer.start()
	yield(timer,'timeout')
	timer.set_wait_time(0.3)
	while !reset and level_number > 1:
		level_number-=1
		set_value(level_number)
		timer.start()
		yield(timer,'timeout')
#	if level_number <=1:
#		main.level_number = 1
	pass # replace with function body


func _on_Left_button_up():
	left_sprite.set('self_modulate','ffffff')
	main.level_number = level_number
	reset = true
	pass # replace with function body


	

func _on_Right_button_down():
	right_sprite.set('self_modulate','8cffffff')
	reset = false
	level_number = main.level_number + 1
	set_value(level_number)
	timer.set_wait_time(1)
	timer.start()
	yield(timer,'timeout')
	timer.set_wait_time(0.3)
	while !reset and level_number < globals.user_data['level']:
		level_number+=1
		set_value(level_number)
		timer.start()
		yield(timer,'timeout')
#	if level_number >= globals.user_data['level']:
#		main.level_number = globals.user_data['level']
#	if level_number >= globals.user_data['level']:
#		right.hide()
	pass # replace with function body


func _on_Right_button_up():
	right_sprite.set('self_modulate','ffffff')
	main.level_number = level_number
	reset = true
	pass # replace with function body





 
