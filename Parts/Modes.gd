extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar""res://Images/Top bar/Modes/Infinity.png"
onready var label = get_node('Label')
onready var animation = get_node('AnimationPlayer')
onready var hub = get_node('../../../../../../')
onready var modes = get_node('../')
export var size = 1
export var current_mode = false
var images = {'Levels':"res://Images/Top bar/Modes/Levels.png",'Stacks':"res://Images/Top bar/Modes/StackUp.png",'Infinity':"res://Images/Top bar/Modes/Infinity.png"}
var pressed_images = {'Levels':"res://Images/Top bar/Modes/Levels_pressed.png",'Stacks':"res://Images/Top bar/Modes/StackUp_pressed.png",'Infinity':"res://Images/Top bar/Modes/Infinity_pressed.png"}
var colours = {'Levels':'7577c5','Stacks':'77c777','Infinity':'bb64c3'}
export var value = 'Levels' setget change_value
var mode_change_sound = preload("res://Sounds/Effects/new_mode.wav")
func _ready():
	pass


func change_value(new_value):
	value = new_value

	var colour = colours[new_value]
	if current_mode:
		get_node('Sprite').set('modulate',colour)

	if label:
		label.set_text(new_value)
		label.set('custom_colors/font_color',colours[value])
		if new_value == 'Infinity':
			label.set('rect_scale',Vector2(0.85,0.85))
		else:
			label.set('rect_scale',Vector2(1,1))
	show()
func appear():
	show()
	animation.play('Appear')

func disappear():
	animation.play('Disappear')
	yield(animation,'animation_finished')
	hide()

func _on_Levels_pressed():
	if value == hub.mode:
		var tween = get_node('Tween')
		tween.interpolate_property(get_node('Sprite'),'rotation_degrees',0,-90,0.15,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
		tween.start()
		hub.toggle_menu(true)
	else:
		modes.get_children()[0].value = value
		hub.toggle_menu(false)
		hub.change_mode(value)
		hub.audio_player.stream = mode_change_sound
		hub.audio_player.play()
	pass # replace with function body

func rotate_back():
	var tween = get_node('Tween')
	tween.interpolate_property(get_node('Sprite'),'rotation_degrees',-90,0,0.15,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()
	
func _on_Levels_button_up():
	set('modulate','ffffff')
	pass # replace with function body


func _on_Levels_button_down():
	set('modulate','8cffffff')
	pass # replace with function body
