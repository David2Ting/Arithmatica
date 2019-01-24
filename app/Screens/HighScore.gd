extends Label


onready var tween = get_node('Tween')
var value setget change_value
func _ready():

	pass

func change_value(new_value):
	value = new_value
	set_text('HighScore \n' + str(new_value))

func disappear():
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.2,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	hide()

func appear():
	show()
	var tween = get_node('Tween')
	tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.2,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()