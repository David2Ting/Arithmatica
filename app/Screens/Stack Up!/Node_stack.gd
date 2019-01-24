extends "res://Parts/Node.gd"

func _ready():
	pass

func _on_Node_input_event(viewport, event, shape_idx):
	._on_Node_input_event(viewport, event, shape_idx)
	if event.is_action_pressed('right_click'):
		level.reward('row',self,1)

func change_value(new_value):
	var level = get_node('../../')
	var old_value = value
	.change_value(new_value)
	if level and old_value:
		if level.number_counts.has(str(new_value)):
			level.number_counts[str(new_value)]+=1
			if level.number_counts[str(new_value)] > 3:
				level.black_list_numbers_counts.append(new_value)
				level.black_list_numbers.append(new_value)
		else:
			level.number_counts[str(new_value)] = 1

		if level.number_counts.has(str(old_value)):
			level.number_counts[str(old_value)]-=1
			if level.number_counts[str(old_value)] < 4 and level.black_list_numbers_counts.find(old_value) > -1:
				level.black_list_numbers_counts.remove(level.black_list_numbers_counts.find(old_value))
		
func destroy_prepare():
	animation.play('Destroy_prepare')
func success():
	pass #After success animation
func destroy():
	pop()

func pop():
	level.number_counts[str(value)] -= 1
	if level.number_counts[str(value)]<4:
		level.black_list_numbers_counts.remove(level.black_list_numbers_counts.find(value))
	.pop()

func rise(node_size):
	if is_moving:
		yield(drop_tween,'tween_completed')
	var current_position = get_position()
	drop_tween.interpolate_property(self,'position',current_position,current_position-Vector2(0,node_size),0.35,drop_tween.TRANS_LINEAR,drop_tween.EASE_IN_OUT)
	drop_tween.start()

func drop():
	level.falling_nodes = true
	.drop()