extends TextureButton  #Stackup

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')
var value setget change_value
onready var tween = get_node('Tween')
onready var animation = get_node('AnimationPlayer')
var back_sign = false
var main
var scales = [1,1,0.9,0.8,0.7,0.6]
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func disappear():
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()

func start():
	main = get_node('/root/Hub/Main')
	tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	pass
func change_value(new_value):
	value = new_value
	label.set_text(str(new_value))
	label.set('modulate','5effffff')
	animation.play('AddPoints')
	var digits = str(new_value).length()
	var size = scales[digits-1]
	if digits>2:
		label.set('scale',Vector2(1*size,1*size))

#		var rect_size = Vector2(204,88)*size
#		label.set('rect_size',rect_size)
#		label.set('rect_position',-rect_size/2)
func back_sign(boo):
	if boo:
		back_sign = true
		tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
		yield(tween,'tween_completed')
		label.set_text('Back')
		tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
	else:
		back_sign = false
		tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
		yield(tween,'tween_completed')
		label.set_text(str(value))
		tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Level_select_pressed():
	print('test')
	if back_sign:
		back_sign(false)
		main.change_selecting_menu(true)
		main.current_level.move('to_select')
		main.selected_operators.clear()
	pass # replace with function body


func _on_Level_select_button_down():
	if back_sign:
		set('modulate','50ffffff')
	pass # replace with function body


func _on_Level_select_button_up():
	set('modulate','ffffff')
	pass # replace with function body
