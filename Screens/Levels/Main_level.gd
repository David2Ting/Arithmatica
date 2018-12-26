extends 'res://Screens/Level.gd'


func _ready():
	pass

func reset_level(reset_group_nodes,reset_group_operators):
	.reset_level(reset_group_nodes,reset_group_operators)
	yield(self,"reset_finished")
	if main.hint_timer.time_left == 0:
		var hint = main.hint
		if hint!=[null,null]:
			node_positions[hint[0].y][hint[0].x].hint(hint[1])