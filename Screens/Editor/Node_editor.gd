extends "res://Parts/Node.gd"
onready var node = get_parent()
onready var line_edit = get_node('LineEdit')
onready var editor = get_node('/root/World/Main')
onready var editor_level = editor.current_level
func _ready():
	mode_check()
	pass

#func change_value(new_value):
#	if str(new_value) == null:
#		print('null')
#		set('modulate','74ffffff')
#	else:
#		set('modulate','ffffff')
#	if str(new_value) == ' ':
#		new_value = '/'
#	.change_value(new_value)

func _on_LineEdit_text_entered(new_text):
	print(new_text)
	change_value(new_text)
	line_edit.menu_option(3)
	if new_text == '/' or new_text == '.':
		level.map[pos.y][pos.x]=new_text
	else:
		level.map[pos.y][pos.x]=int(new_text)
	editor.currently_editing = null
	editor_select(false)
	editor_level.find_dimensions()
	pass # replace with function body

func test(boo):
	if boo:
		line_edit.hide()
	else:
		line_edit.show()

func mode_check():
	if editor.mode == 'edit':
		return
	elif editor.mode == 'test':
		line_edit.hide()

func _on_LineEdit_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		editor.currently_editing = self
	pass # replace with function body



func editor_select(boo):
	if boo:
		sprite.set('self_modulate','0796ff')
	else:
		sprite.set('self_modulate','ffffff')
		line_edit.menu_option(3)

func invis(boo):
	if boo:
		set('modulate','74ffffff')
	else:
		set('modulate','ffffff')