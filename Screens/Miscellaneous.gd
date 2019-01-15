extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var final_score = get_node('FinalScore')
onready var tween = get_node('Tween')
onready var hub = get_node('../')
onready var animation = get_node('AnimationPlayer')
onready var screen = get_node('Sprite')
var final_score_value setget change_final_score
func _ready():
	pass

func stack_up_appear():
	show()
	tween.interpolate_property(screen,'self_modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.interpolate_property(final_score,'modulate',Color(1,1,1,0),Color(1,1,1,1),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()

func stack_up_disappear():
	tween.interpolate_property(screen,'self_modulate',Color(1,1,1,1),Color(1,1,1,0),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.interpolate_property(final_score,'modulate',Color(1,1,1,1),Color(1,1,1,0),0.5,tween.TRANS_LINEAR,tween.EASE_IN_OUT)
	tween.start()
	yield(tween,'tween_completed')
	hide()

func change_final_score(new_score):
	final_score.set_text('Final Score\n'+str(new_score))

func _on_StackUpReset_pressed():
	hub.new_main.reset()
	pass # replace with function body
