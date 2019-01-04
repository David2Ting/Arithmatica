extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var hint_box = false
func _ready():
	var array1 = [[1,2,3],[1,2,3]]
	var array2 = [[1,2,3],[1,2,3]]
	print('gday'+str(array1==array2))

	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func on_block(boo):
	pass