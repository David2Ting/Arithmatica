extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')
onready var editor = get_node('/root/World')
export var value = 'test' setget change_value
func _ready():
	change_value(value)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func change_value(new_value):
	value = new_value
	if label:
		label.set_text(value)

func _on_Editor_button_pressed():
	if value == 'Test':
		test()
	elif value == 'Edit':
		edit()
	if value == 'Save':
		save()
	if value == 'Hint':
		hint()
	pass # replace with function body

func test():
	var level = editor.current_level
	editor.currently_editing = null
	change_value('Edit')
	editor.mode = 'test'
	for node in level.node_holder.get_children():
		if node.is_in_group('nodes'):
			node.test(true)
	for operator in level.get_node('Operators_holder').operators:
			operator.test(true)
func edit():
	var level = editor.current_level
	change_value('Test')
	editor.mode = 'edit'
	level.reset()
	for node in level.node_holder.get_children():
		if node.is_in_group('nodes'):
			node.test(false)
	for operator in level.get_node('Operators_holder').operators:
			operator.test(false)
		
func _on_Editor_button_button_up():
	label.set_position(Vector2(0,0))
	pass # replace with function body


func _on_Editor_button_button_down():
	label.set_position(Vector2(0,42.7))
	pass # replace with function body

func save():
	editor.save()

func hint():
	var operators_holder = get_node('/root/World/Level').operators_holder
	var check = editor.currently_editing
	if check:
		if check.is_in_group('nodes'):
			editor.hint[0]=[check.pos.x,check.pos.y]
		elif check.is_in_group('operators'):
#			editor.hint[1]=operators_holder.operators.find(check)
			editor.hint[1]=check.value
	print(editor.hint)