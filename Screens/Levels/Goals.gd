extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var label = get_node('Label')
onready var tween = get_node('Tween')
onready var globals = get_node('/root/globals')
onready var timer = get_node('Timer')
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
	print(new_value)
	value = new_value
	label.set_text(str(new_value))


func enter(side=true):
#	timer.start()
#	yield(timer,'timeout')
	var distance
	if side:
		distance = globals.actual_level_size.x*0.5
	else:
		distance = -globals.actual_level_size.x*0.5
	tween.interpolate_property(self,'scale',Vector2(0.6,0.6),Vector2(1,1),1.3,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',Color(1,1,1,0),Color(1,1,1,1),1.3,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',Vector2(distance,0),Vector2(),1.3,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
func leave(side=true):
#	timer.start()
#	yield(timer,'timeout')
	var distance
	if side:
		distance = globals.actual_level_size.x*0.5
	else:
		distance = -globals.actual_level_size.x*0.5
	tween.interpolate_property(self,'scale',Vector2(1,1),Vector2(0.6,0.6),1.3,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),1.3,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',Vector2(),Vector2(-distance,0),1.3,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()