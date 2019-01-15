extends TextureButton


onready var label = get_node('../Label')
onready var tween = get_node('Tween')
var type setget change_type
func _ready():

	pass

func transparent(boo):
	if boo:
		set('modulate','f7f7f7')
		set('mouse_filter',2)
	else:
		set('modulate','d9d9d9')
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
			label.get('custom_fonts/font').set('size',60)
		else:
			label.get('custom_fonts/font').set('size',40)
	type = new_type



func _on_Hint_button_down():
	set('modulate','e9e9e9')
	pass # replace with function body


func _on_Hint_button_up():
	set('modulate','d9d9d9')
	pass # replace with function body
