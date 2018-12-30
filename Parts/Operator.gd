extends Area2D

onready var globals = get_node('/root/globals')
onready var sprite = get_node('Image_holder/Sprite')
onready var symbol = get_node('Image_holder/Symbol')
onready var colours = globals.colours
onready var container = get_parent()
onready var main = get_node('../../../../../../')
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
	if int(new_value)>0:
		sprite.set('self_modulate','e500ff')
		symbol.set_texture(load("res://Images/blank.png"))
		var type = str(new_value)[0]
		var sub_type = 2
		if str(new_value).length()>1:
			sub_type = str(new_value)[1]
		if type == '1':
			label.set_text(specials['1']+str(sub_type))
		elif type == '2':
			label.set_text(specials['2'])
		elif type == '3':
			label.set_text(specials['3'][int(sub_type)-1])
		elif type == '4':
			label.set_text(specials['4']+str(int(sub_type)+1))
		elif type == '5':
			var num = ''
			for i in range(2,str(new_value).length()):
				num = num + str(new_value)[i]
			label.set_text(sub_type+num)
		on(true)
		return
	else:
		label.set_text(' ')
	sprite.set('self_modulate',colours[value])
	if value != '0':
		symbol.set_texture(load(operator_images[value]))
		on(true)
	else:
		symbol.set_texture(load("res://Images/blank.png"))
	show()




func pop():
	container.add_operator()
	queue_free()

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
	