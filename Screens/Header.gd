extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var globals = get_node('/root/globals')

onready var mode = get_node('Modes')
onready var reset = get_node('Reset')
onready var level_select = get_node('Level_select')

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func start():
	return
	var size = globals.y_size*120/900
	var area_scale = globals.y_size/900
	var margin = Vector2(10,10)*area_scale
#	infinity.set_scale(Vector2(0.2,0.2)*area_scale)
#	infinity.set_position(margin)
	reset.set_scale(Vector2(0.2,0.2)*area_scale)
	reset.set_position(Vector2(globals.x_size-reset.get('rect_size').x*reset.get_scale().x-margin.x,margin.y))
	level_select.set_scale(Vector2(0.2,0.2)*area_scale)
	level_select.set_position(Vector2(globals.x_size/2-0.2*level_select.get('rect_size').x*area_scale/2,margin.y))
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
