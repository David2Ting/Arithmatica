extends Node2D

onready var globals = get_node('/root/globals')
onready var main = get_node('../../../../../')

var operator = preload('res://Parts/Operator.tscn')
var operators = []
var current_operator = '+' setget change_current_operator
var current_operator_id = null

func _ready():
	for operator in get_children():
		if operator.is_in_group('operators'):
			operators.append(operator)
	pass


func add_operator(type='+'):
	var operator_instance = operator.instance()
	operator_instance.set('scale',Vector2(main.operator_size,main.operator_size))
	add_child(operator_instance)
	operator_instance.value = type
	operators.append(operator_instance)
	operator_instance.show()
	position_operators()

func position_operators():
	var size = operators.size()-1
	for i in range(operators.size()):
		var pos = size*-main.operator_size_area/2+i*main.operator_size_area
		operators[i].set_position(Vector2(pos,0))
	
func pop_operator(operator):
	var index = operators.find(operator)
	if index >= 0:
		operators.remove(index)
	operator.pop()


func off_operator():
	if current_operator_id:
		current_operator_id.on(false)
		current_operator_id = null
		main.current_operator = null

func change_current_operator(new_current_operator):
	current_operator = new_current_operator

func pressed(obj):
	for operator in operators:
		if operator==obj:
			main.current_operator=operator.value
			current_operator_id = operator
			operator.pressed(true)
		else:
			if operator:
				operator.pressed(false)

	
