extends Node2D


onready var label = get_node('Label')
onready var reward_logo = get_node('Reward')
var set_distance = null
var upgrade_position = Vector2()
var value = 5 setget change_value
var reward = null setget change_reward
var reward_images = {'row':"res://Images/Stackup/Row.png",'box':"res://Images/Stackup/Box.png",'screen':"res://Images/Stackup/Screen.png",'heart':"res://Images/Stackup/Heart.png"}
func _ready():

	pass

func appear(distance):
	set_distance = distance
	set_scale(Vector2(0.6,0.6))
	set('modulate','9affffff')
	var tween = get_node('Tween')
	var current_position = get_position()
	upgrade_position = current_position+Vector2(-distance,0)*2
	tween.interpolate_property(self,'position',current_position,current_position+Vector2(-distance,0),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()
	

func change_value(new_value):
	value = new_value
	label.set_text(str(new_value))

func upgrade(distance):
	set('modulate','ffffff')
	var tween = get_node('Tween')
	var current_position = get_position()
	tween.interpolate_property(self,'scale',Vector2(0.6,0.6),Vector2(1,1),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',current_position,upgrade_position,0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()

func disappear(side=true):
	var tween = get_node('Tween')
	var current_position = get_position()
	tween.interpolate_property(self,'scale',get_scale(),Vector2(0.6,0.6),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',get('modulate'),Color(1,1,1,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',current_position,current_position+Vector2(set_distance,0),1.5,tween.TRANS_QUAD,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	queue_free()
	
func death():
	set('modulate','9affffff')
	var tween = get_node('Tween')
	var current_position = get_position()
	var death_position = current_position + Vector2(-set_distance,0)
	tween.interpolate_property(self,'scale',Vector2(1,1),Vector2(0.6,0.6),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.interpolate_property(self,'position',current_position,death_position,0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	queue_free()

func change_reward(new_reward):
	pass
	reward_logo.set_texture(load(reward_images[new_reward]))

