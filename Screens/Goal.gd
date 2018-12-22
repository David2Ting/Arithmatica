extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var value = 0 setget change_value
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_value(new_value):
	var digits = str(new_value).length()
	var size = 1
	if digits == 2:
		size = 1.2
	else:
		size = ((str(new_value).length()-1.0)/2.4+1)
	print(size)
	set('rect_scale',Vector2(1/size,1/size))
	var rect_size = 400*size
#	set('rect_size',Vector2(rect_size,rect_size))
#	set('rect_position',Vector2(-rect_size/2,-rect_size/2))
	set_text(str(new_value))