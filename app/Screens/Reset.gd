extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var tween = get_node('Tween')
onready var label = get_node('Label')
func _ready():
	pass
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

func transparent(boo):
	if boo:
		label.set('self_modulate',Color(1,1,1,0.3))
		set('mouse_filter',2)
	else:
		label.set('self_modulate',Color(1,1,1,1))
		set('mouse_filter',0)

