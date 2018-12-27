extends "res://Parts/Node.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func destroy_prepare():
	animation.play('Destroy_prepare')
func success():
	pass #After success animation
func destroy():
	pop()

func rise(node_size):
	var current_position = get_position()
	drop_tween.interpolate_property(self,'position',current_position,current_position-Vector2(0,node_size.x),0.25,drop_tween.TRANS_LINEAR,drop_tween.EASE_IN_OUT)
	drop_tween.start()