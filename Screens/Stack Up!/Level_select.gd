extends TextureButton  #Stackup

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')
var value setget change_value
onready var tween = get_node('Tween')
onready var animation = get_node('AnimationPlayer')
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func disappear():
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()

func start():
	tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	pass
func change_value(new_value):
	value = new_value
	label.set_text(str(new_value))
	label.set('modulate','5effffff')
	animation.play('AddPoints')
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
