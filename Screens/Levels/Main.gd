extends 'res://Screens/World.gd'

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var hint_timer = get_node('HintTimer')
onready var tween = get_node('Tween')
func _ready():
	setup_dimensions()
	load_database()

	var next_level
	if database.has(str(1)):
		next_level = database[str(1)]
	else:
		next_level = neutral_level
	setup_level(next_level,true)
	hint_timer.start()
	pass

func next_level():
	change_level_number(level_number+1)
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func change_level_number(new_level_number):
	hint_timer.start()
	.change_level_number(new_level_number)

func _on_Editor_pressed():
	get_tree().change_scene("res://Screens/Editor/Editor.tscn")
	pass # replace with function body

func change_current_operator(new_operator):
	.change_current_operator(new_operator)
	current_level.change_operator(new_operator)

func move(type):
	var x_size = globals.x_size*1.5
	if type == 'out':
		tween.interpolate_property(self,'position',Vector2(0,0),Vector2(-x_size,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()
	if type == 'in':
		tween.interpolate_property(self,'position',Vector2(-x_size,0),Vector2(0,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
		tween.start()



func _on_Infinity_pressed():
	get_node('../').to_infinity()
	pass # replace with function body


func _on_Tween_tween_completed(object, key):
	if !active:
		queue_free()
		print('free')
	pass # replace with function body
