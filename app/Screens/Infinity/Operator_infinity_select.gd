extends "res://Parts/Operator.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var pos = Vector2() setget change_pos
var drop_amount = 0
onready var holder = get_parent()
func _ready():
	pass

func _on_Operator_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('left_click') and active:
		main.pressed = true
		holder.pressed = true
		holder.add(self)
		pressed(true)
	pass # replace with function body

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Pop':
		get_parent().finish_pop()

func pop():
	animation.play('Pop')
	yield(animation,'animation_finished')
	queue_free()

func drop():
	var current_position = get_position()
	if drop_amount > 0:
		tween.interpolate_property(self,'position',current_position,current_position+Vector2(0,holder.size_area*drop_amount),0.25,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
		tween.start()
		drop_amount = 0
	if pos.y>3:
		in_zone(true)

func _on_Operator_mouse_entered():
	if active:
		holder.add(self)
	pass # replace with function body

func in_zone(boo):
	if boo:
		set('modulate','ffffff')
		active = true
	else:
		set('modulate','9cb0b0b0')
		active = false

func change_pos(new_pos):
	pos = new_pos
	if new_pos.y<4:
		in_zone(false)
	else:
		in_zone(true)

func pressed(boo):
	if active:
		if boo:
			pressed = true
			sprite.set_texture(pressed_operator)
			symbol.set_position(Vector2(0,21))
			sprite.set('self_modulate','008dff')
		else:
			pressed = false
			if int(value)>0:
				sprite.set('self_modulate',colours['1'])
			else:
				sprite.set('self_modulate',colours[value])
			sprite.set_texture(small_operator)
			symbol.set_position(Vector2(0,0))