extends 'res://Screens/Level.gd'


func _ready():
	pass
func start():
	.start()

func reset_level(reset_group_nodes,reset_group_operators):
	.reset_level(reset_group_nodes,reset_group_operators)
	yield(self,"reset_finished")
	if main.hint_timer.time_left == 0:
		var hint = main.hint
		if hint!=[null,null]:
			node_positions[hint[0].y][hint[0].x].hint(hint[1])
			
func disappear():
	tween.interpolate_property(node_holder,'position',node_area_position,node_area_position+Vector2(-level_size.x,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	yield(tween,'tween_completed')
	hub.emit_signal('queue_free')

func reset():
	.reset()
	if main.level_number == 100 and main.success_node:
		main.success_node.get_node('Image_holder/Sprite').set('modulate','ffffff')

	main.method_100 = [[],[],[],[]]