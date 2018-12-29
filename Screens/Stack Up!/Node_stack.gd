extends "res://Parts/Node.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var original_value = null
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

func pop():
	level.number_counts[str(original_value)] -= 1
	if level.number_counts[str(original_value)]<4:
		level.black_list_numbers_counts.remove(level.black_list_numbers_counts.find(original_value))
	.pop()

func rise(node_size):
	if is_moving:
		yield(drop_tween,'tween_completed')
	var current_position = get_position()
	drop_tween.interpolate_property(self,'position',current_position,current_position-Vector2(0,node_size),0.25,drop_tween.TRANS_LINEAR,drop_tween.EASE_IN_OUT)
	drop_tween.start()

func drop():
	level.is_falling = true
	.drop()