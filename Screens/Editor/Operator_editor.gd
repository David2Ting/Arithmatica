extends "res://Parts/Operator.gd"
onready var line_edit = get_node('LineEdit')
onready var editor = get_node('/root/Hub/Main')
onready var editor_level = get_parent()
var operator_types = ['+','-','*','/']
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func editor_select(boo):
	return
	if boo:
		sprite.set('self_modulate','0796ff')
	else:
		sprite.set('self_modulate','ffffff')
		line_edit.menu_option(3)
		
func _on_LineEdit_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		editor.currently_editing = self
	pass # replace with function body

func test(boo):
	if boo:
		line_edit.hide()
	else:
		line_edit.show()

func _on_LineEdit_text_entered(new_text):
	line_edit.menu_option(3)
	if operator_types.find(new_text)>=0 or int(new_text)>0:
		change_value(new_text)
	else:
		change_value('0')
#	editor.currently_editing = null
	pass # replace with function body

