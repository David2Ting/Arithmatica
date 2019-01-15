extends Node2D


onready var label = get_node('Label')
onready var tween = get_node('Tween')
onready var globals = get_node('/root/globals')
onready var timer = get_node('Timer')
var value = 0 setget change_value
func _ready():

	pass



func change_value(new_value):
	print(new_value)
	value = new_value
	label.set_text(str(new_value))

func disappear():
	var x_size = globals.x_size
	tween.interpolate_property(self,'scale',Vector2(1,1),Vector2(0.6,0.6),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',Vector2(),Vector2(-x_size,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	queue_free()

func enter(side=true):
	var distance
	if side:
		distance = globals.actual_level_size.x*0.5
	else:
		distance = -globals.actual_level_size.x*0.5
	tween.interpolate_property(self,'scale',Vector2(0.6,0.6),Vector2(1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',Vector2(distance,0),Vector2(),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
func leave(side=true):
	var distance
	if side:
		distance = globals.actual_level_size.x*0.5
	else:
		distance = -globals.actual_level_size.x*0.5
	tween.interpolate_property(self,'scale',Vector2(1,1),Vector2(0.6,0.6),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',Vector2(),Vector2(-distance,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	queue_free()