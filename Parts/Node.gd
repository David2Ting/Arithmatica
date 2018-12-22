extends Area2D

onready var main = get_node('../../../')
onready var level = main.current_level
onready var sprite = get_node('Image_holder/Sprite')
onready var label = get_node('Image_holder/Label_holder/Label')
onready var label_holder = get_node('Image_holder/Label_holder')
onready var animation = get_node('AnimationPlayer')
onready var drop_tween = get_node('DropTween')
onready var colours = globals.colours

var active = true
var pos = Vector2()
var drop_amount = 0
var is_block = false

var un_pressed = load("res://Images/Cell.png")
var pressed = load("res://Images/Operator_pressed.png")

export var value = 0 setget change_value
var selected = false
var hint_operator = '+'
signal add_node(obj)

func _ready():

	pass

func _on_Node_mouse_entered():
#	emit_signal('add_node',self)
	main.add_node(self)
	pass # replace with function body


func _on_Node_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('left_click') and !is_block and main.current_operator:
		if main.current_operator == '2' and (value < 0 or sqrt(value)*sqrt(value)!=value):
			return
		main.pressed = true
		main.select_chain = [self]
		main.calculate_sum()
		select(true)
	pass # replace with function body

func select(boo):
	if main.current_operator:
		if boo:
			if int(main.current_operator)>0:
				sprite.set('self_modulate',colours['1'])
			else:
				sprite.set('self_modulate',colours[main.current_operator])
			pressed(true)
		else:
			sprite.set('self_modulate','ffffff')
			pressed(false)
func change_value(new_value):
	if !new_value and new_value!=0:
		if label:
			label.set_text(' ')
			is_block = true
			sprite.set('self_modulate','8d8d8d')
		return
	if label:
		if str(new_value) == '/':
			label.set_text(' ')
			is_block = true
			set('modulate','ffffff')
			sprite.set('self_modulate','8d8d8d')
			value = '/'
			return
		elif str(new_value) == '.':
			label.set_text(' ')
			set('modulate','00ffffff')
			is_block = true
			value = '.'
			return
		else:
			sprite.set('self_modulate','ffffff')
			set('modulate','ffffff')
			value = int(new_value)
		label.set_text(str(new_value))
		var size
		var digits = str(new_value).length()
		if digits == 2:
			size = 1.2
		else:
			size = ((str(new_value).length()-1.0)/2.4+1)
		label_holder.set('scale',Vector2(1/size,1/size))
		var rect_size = 400*size
		label.set('rect_size',Vector2(rect_size,rect_size))
		label.set('rect_position',Vector2(-rect_size/2,-rect_size/2))
		is_block = false
func pop():
	animation.play('Pop')
	yield(animation,'animation_finished')
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Pop':
		main.current_level.finish_pop()

func drop():
	var current_position = get_position()
	if drop_amount > 0:
		drop_tween.interpolate_property(self,'position',current_position,current_position+Vector2(0,level.node_size_area*drop_amount),0.25,drop_tween.TRANS_LINEAR,drop_tween.EASE_IN_OUT)
		drop_tween.start()
		drop_amount = 0

func reset(type):
	if type == 'complete':
		animation.play('Reset')
		yield(get_tree().create_timer(.1), "timeout")
		show()
	elif type == 'change':
		animation.play('Change')
		yield(get_tree().create_timer(.1), "timeout")
		show()
func _on_DropTween_tween_completed(object, key):
	level.tween_completed()
	pass # replace with function body

func success():
	main.next_level()

func hint(operator):
	animation.play('Hint')
	hint_operator = operator


func hint_colour(boo):
	if boo:
		sprite.set('self_modulate',colours[hint_operator])
	else:
		if !selected:
			sprite.set('self_modulate','ffffff')

func pressed(boo):
	if boo:
		sprite.set_texture(pressed)
		label_holder.set_position(Vector2(0,26.51))
		selected = true
	else:
		sprite.set_texture(un_pressed)
		label_holder.set_position(Vector2(0,0))
		selected = false