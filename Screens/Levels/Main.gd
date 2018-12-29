extends 'res://Screens/World.gd'

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var hint_timer = get_node('HintTimer')
onready var tween = get_node('Tween')
var mode = 'Levels'
var progress_file = File.new()
var PROGRESS_PATH = "res://Screens/Progress.json"
var progress = []
var progress_level = 1

var dialogue = []
var dialogue_number = 0

func _ready():
	setup_dimensions()
	load_database()
	
	load_progress()
	var next_level
	if database.has(str(progress_level)):
		next_level = database[str(progress_level)]
	else:
		next_level = neutral_level
	level_select.value = progress_level
	level_number = progress_level

	setup_level(next_level,true)
	hint_timer.start()
	pass

func setup_level(next_level,boo):
	.setup_level(next_level,boo)
	if progress_level == 1:
		tips('starter')

func next_level():
	change_level_number(level_number+1)

func _input(event):
	if event.is_action_pressed('left_click'):
		if tips_mode:
			if dialogue_number+1 >=dialogue.size():
				tips_mode = false
				current_level.tip_box.hide()
				get_parent().shadow.hide()
			else:
				current_level.tip_box_label.set_text(dialogue[dialogue_number+1])
				dialogue_number+=1

	._input(event)
func change_level_number(new_level_number):
	hint_timer.start()
	if new_level_number > progress_level:
		update_progress(new_level_number)
	.change_level_number(new_level_number)

func _on_Editor_pressed():
	get_tree().change_scene("res://Screens/Editor/Editor.tscn")
	pass # replace with function body

func change_current_operator(new_operator):
	.change_current_operator(new_operator)
	current_level.change_operator(new_operator)

func load_progress():
	progress_file.open(PROGRESS_PATH,File.READ)
	progress = parse_json(progress_file.get_as_text())
	progress_file.close()
	progress_level = progress['level']


func update_progress(new_level):
	progress_level = new_level
	progress_file.open(PROGRESS_PATH, File.WRITE)
	progress['level']=new_level
	progress_file.store_line(to_json(progress))
	progress_file.close()

func _on_Infinity_pressed():
	get_node('../').to_infinity()
	pass # replace with function body

func _on_Tween_tween_completed(object, key):
	if !active:
		queue_free()
	pass # replace with function body

func tips(type):
	if get_parent().shadow:
		get_parent().shadow.show()
	tips_mode = true
	dialogue = globals.tips[type]
	dialogue_number = 0
	current_level.tip_box.show()
	current_level.tip_box_label.set_text(dialogue[0])
	print(dialogue)
	pass
	


