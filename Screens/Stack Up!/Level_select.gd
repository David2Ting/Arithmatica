extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')
var value = 0 setget change_value
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func change_value(new_value):
	value = new_value
	label.set_text(str(new_value))
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
