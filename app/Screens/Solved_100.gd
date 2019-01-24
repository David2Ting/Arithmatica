extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var tween = get_node('Tween')
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func appear():
	tween.interpolate_property(self,'modulate',get('modulate'),Color(1,1,1,1),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
func disappear():
	tween.interpolate_property(self,'modulate',get('modulate'),Color(1,1,1,0),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()