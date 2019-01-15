extends Sprite

onready var globals = get_node('/root/globals')
onready var sprite = get_node('Image_holder/Sprite')
onready var symbol = get_node('Image_holder/Symbol')
onready var colours = globals.colours
onready var container = get_parent()
onready var main = get_node('/root/Hub/Main')
onready var label = get_node('Image_holder/Symbol/Label')
onready var animation = get_node('AnimationPlayer')
onready var tween = get_node('Tween')
var operator_images = {'+':'res://Images/Arithmetic/+.png','-':"res://Images/Arithmetic/-.png",'*':"res://Images/Arithmetic/x.png",'/':"res://Images/Arithmetic/%.png"}
var specials = {'1':'^','2':'√','3':['<','<<','>','>>'],'4':'%'}   
var value = '+' setget change_value
var small_operator = preload("res://Images/Operator.png")
var big_operator = preload("res://Images/Operation_select.png")
var pressed_operator = preload("res://Images/Operator_pressed.png")
var pressed = false
var active = true
func _ready():
	change_value(value)
	pass

func _process(delta):

	pass

func change_value(new_value):
#	hide()
	value = new_value
	sprite.set('self_modulate',colours[value])
	if value != '0':
		symbol.set_texture(load(operator_images[value]))
		on(true)
	else:
		symbol.set_texture(load("res://Images/blank.png"))
	show()



func big(boo):
#	hide()
	if boo:
		sprite.set_texture(big_operator)
		sprite.set_position(Vector2(0,-100))
		symbol.set_position(Vector2(0,-100))
	else:
		sprite.set_texture(small_operator)
		sprite.set_position(Vector2(0,0))
		symbol.set_position(Vector2(0,0))
		pass
	show()

func pressed(boo):
	if active:
		if boo:
			pressed = true
			sprite.set_texture(pressed_operator)
			symbol.set_position(Vector2(0,21))
			set('modulate','ffffff')
		else:
			pressed = false
			set('modulate','adadad')
			sprite.set_texture(small_operator)
			symbol.set_position(Vector2(0,0))

func _on_Operator_input_event(viewport, event, shape_idx):
	if active:
		if event.is_action_pressed('left_click'):
			if pressed:
				main.current_operator=null
				container.current_operator_id = null
				pressed(false)
			else:
				container.pressed(self)
	pass # replace with function body

func on(boo):
	if boo:
		active = true
		if int(value)>0:
			sprite.set('self_modulate',colours['1'])
		else:
			sprite.set('self_modulate',colours[value])
	else:
		active = false
		sprite.set('self_modulate','5d5d5d') #b9c9c9c9

func left(amount):
	var current_position = get_position()
	tween.interpolate_property(self,'position',current_position,current_position-Vector2(amount,0),0.25,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()

func reset():
	if str(value) != '0':
		on(true)
		pressed(false)
	else:
		on(false)
		pressed(true)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	container.emit_signal('pop_finish')
	pass # replace with function body
