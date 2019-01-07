extends "res://Screens/Level.gd"

onready var algebra = get_node('Algebra')
onready var builder = get_node('Builder')
var operator_select_holder
var operator_group = [['+',3],['-',2],['+',3]]
var sum = 10
signal move_complete

func start():
	.start()
	operator_select_holder = get_node('Operator_select_holder')
	level_size = screen_size/1.2
	operator_select_holder.hide()
	operator_select_holder.start()
	operator_select_holder.load_operators()
	operator_select_holder.calculate()
	tween = get_node('Tween')
	var y_size = globals.y_size
	operator_select_holder.set_position(Vector2(0,-y_size))
	tween.interpolate_property(operator_select_holder,'position',Vector2(0,-y_size),Vector2(0,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	operator_select_holder.show()
#	var operator_groups = algebra.calculate(operator_group,sum)
#	builder.gravity()
#	var map = builder.build(operator_groups)
#	load_level(map,['+','-'],sum,true)
	pass

func disappear():
	if main.selecting_menu:
		var y_size = globals.y_size
		tween.interpolate_property(operator_select_holder,'position',Vector2(0,0),Vector2(0,-y_size),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	else:
		var x_size = globals.x_size
		tween.interpolate_property(node_holder,'position',Vector2(0,0),Vector2(x_size,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	hub.emit_signal('queue_free')

func create_level(operator_group,sum):
	print(operator_group)
	var operators = []
	for operator in operator_group:
		operators.append(operator[0])
	var state = 'freeze'


	var maths_groups = algebra.calculate(operator_group,sum)
	var maths = maths_groups[0]
	var map = builder.build(maths)
	load_level(map,operators,maths_groups[1],true)
	prev_node_holder.queue_free()
	prev_node_holder = null
func move(type):
	main.settled = false
	var normal_select_pos = Vector2(0,operator_select_holder.get_position().y)
	var normal_pos = Vector2(0,-40)
	var x = Vector2(level_size.x,0)*1.5
	if type == 'forwards':
		tween.interpolate_property(node_holder,'position',normal_pos+x,normal_pos,1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.interpolate_property(operator_select_holder,'position',normal_select_pos,normal_select_pos-x,1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
		yield(get_tree().create_timer(.1), "timeout")
		node_holder.show()
	elif type == 'to_select':
		tween.interpolate_property(node_holder,'position',normal_pos,normal_pos+x,1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.interpolate_property(operator_select_holder,'position',normal_select_pos-x,normal_select_pos,1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()



func _on_Tween_tween_completed(object, key):
	main.finish_movement()
	pass # replace with function body
