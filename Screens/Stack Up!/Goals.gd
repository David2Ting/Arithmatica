extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')

var upgrade_position = Vector2()
var value = 5 setget change_value
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func appear(distance):
	set_scale(Vector2(0.6,0.6))
	set('modulate','9affffff')
	var tween = get_node('Tween')
	var current_position = get_position()
	upgrade_position = current_position+Vector2(-distance,0)*2
	tween.interpolate_property(self,'position',current_position,current_position+Vector2(-distance,0),0.25,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()

func change_value(new_value):
	value = new_value
	label.set_text(str(new_value))

func upgrade(distance):
	set_scale(Vector2(1,1))
	set('modulate','ffffff')
	var tween = get_node('Tween')
	var current_position = get_position()
	tween.interpolate_property(self,'position',current_position,upgrade_position,0.25,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
