extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')
onready var editor = get_node('/root/World')
onready var line_edit = get_node('LineEdit')
var value = 1 setget change_value
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_LineEdit_text_changed(new_text):
	label.set_text(new_text)
	pass # replace with function body

func change_value(new_value):
	print('test')
	value = int(new_value)
	label.set_text(str(new_value))

func editor_select(boo):
	if boo:
		set('self_modulate','0796ff')
	else:
		set('self_modulate','ffffff')
		line_edit.menu_option(3)
		change_value(value)

func _on_LineEdit_text_entered(new_text):
	print(new_text)
#	editor.currently_editing = null
	line_edit.menu_option(3)
	editor.level_number = int(new_text)
	pass # replace with function body


func _on_LineEdit_gui_input(ev):
	if ev.is_action_pressed('left_click'):
		return
		editor.currently_editing = self
		
	pass # replace with function body
