extends TextureButton


onready var label = get_node('../Label')
onready var tween = get_node('Tween')
var type setget change_type
func _ready():

	pass

func transparent(boo):
	if boo:
		label.set('self_modulate','f6f6f6')
		set('mouse_filter',2)
	else:
		label.set('self_modulate','bdbdbd')
		set('mouse_filter',0)

func change_type(new_type):
	if type != new_type:
		tween.interpolate_property(label,'modulate',Color(1,1,1,1),Color(1,1,1,0),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		yield(tween,'tween_completed')
		label.set_text(new_type)
		tween.interpolate_property(label,'modulate',Color(1,1,1,0),Color(1,1,1,1),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		tween.start()
		if new_type == '?':
			label.get('custom_fonts/font').set('size',70)
		else:
			label.get('custom_fonts/font').set('size',50)
	type = new_type



func _on_Hint_button_down():
	label.set('self_modulate','f6f6f6')
	pass # replace with function body


func _on_Hint_button_up():
	label.set('self_modulate','bdbdbd')
	pass # replace with function body
