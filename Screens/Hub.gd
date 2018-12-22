extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var current_world= get_node('World')
onready var globals = get_node('/root/globals')
onready var top_bar = get_node('TextureRect')
var prev_world = null
var packed_main = preload("res://Screens/Levels/Main.tscn")
var packed_infinity = preload("res://Screens/Infinity/Infinity_main.tscn")
func _ready():
	current_world.setup_dimensions()
	top_bar()
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func to_infinity():
	prev_world = current_world
	current_world = packed_infinity.instance()
	current_world.set_position(Vector2(globals.x_size,0))
	add_child(current_world)
	prev_world.active = false
	prev_world.move('out')
	current_world.move('in')

func to_main():
	prev_world = current_world
	current_world = packed_main.instance()
	add_child(current_world)
	prev_world.active = false
	prev_world.move('out')
	current_world.move('in')

func top_bar():
	var size = globals.y_size*120/900
	var area_scale = globals.y_size/900
	top_bar.set('rect_size',Vector2(globals.x_size*1.5,size))