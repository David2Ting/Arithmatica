extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar""res://Images/Top bar/Modes/Infinity.png"
onready var label = get_node('Label')
onready var animation = get_node('AnimationPlayer')
onready var main = get_node('../../../')
export var size = 1
export var current_mode = false
var images = {'Levels':"res://Images/Top bar/Modes/Levels.png",'Stacks':"res://Images/Top bar/Modes/StackUp.png",'Infinity':"res://Images/Top bar/Modes/Infinity.png"}
var pressed_images = {'Levels':"res://Images/Top bar/Modes/Levels_pressed.png",'Stacks':"res://Images/Top bar/Modes/StackUp_pressed.png",'Infinity':"res://Images/Top bar/Modes/Infinity_pressed.png"}
var colours = {'Levels':'7577c5','Stacks':'77c777','Infinity':'bb64c3'}
export var value = 'Levels' setget change_value

func _ready():
	label.set_text(value)
	label.set('custom_colors/font_color',colours[value])
	if !current_mode:
		get_node('Label').set('rect_scale',Vector2(size,size))
#	else:
#		get_node('Sprite').set('modulate',colour)
	print(value)
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_value(new_value):
	value = new_value
	var colour = colours[new_value]
	if current_mode:
		get_node('Sprite').set('modulate',colour)

#	set_normal_texture(load(images[new_value]))
#	set_pressed_texture(load(pressed_images[new_value]))
	if label:
		label.set_text(new_value)

func appear():
	show()
	animation.play('Appear')

func disappear():
	animation.play('Disappear')
	yield(animation,'animation_finished')
	hide()

func _on_Levels_pressed():
	if value == main.mode:
		main.toggle_menu(true)
		get_node('sprite').set_rotation_degrees(-90)
	else:
		main.get_parent().change_mode(value)
	pass # replace with function body
