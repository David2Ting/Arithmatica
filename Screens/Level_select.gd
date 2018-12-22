extends TextureButton

onready var label = get_node('Label')
onready var main = get_node('../../')
var value = 1 setget change_value
onready var line_edit = get_node('LineEdit')
func change_value(new_value):
	value = new_value
	label.set_text(str(value))

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


func _on_Level_select_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		print('left')
	pass # replace with function body


func _on_LineEdit_text_entered(new_text):
	main.level_number = int(new_text)
	line_edit.menu_option(3)
	pass # replace with function body
