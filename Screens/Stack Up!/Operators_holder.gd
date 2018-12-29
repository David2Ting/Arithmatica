extends "res://Screens/Operators_holder.gd" #Stack Up!

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var operator_index = 0
var operator_area_size = 380
var operator_chances = {'+':5,'-':4,'*':2,'/':2}
var starter_operators = ['+','+','+','-','-','*','/']
func _ready():

	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func start():
	randomize()
	operators = []
	for child in get_children():
		if child.is_in_group('operators'):
			operators.append(child)
			child.value = generate_operator()
func off_operator():
	if current_operator_id:
		operator_chances[current_operator_id.value]+=1
		operator_index = operators.find(current_operator_id)
		operators.remove(operator_index)
		current_operator_id.animation.play('Pop')
		current_operator_id = null
		main.current_operator = null

func generate_operator():
	var sum = 0
	for operator in operator_chances:
		if operator_chances[operator] > 0:
			sum += operator_chances[operator]
	var rand = randi()%sum
	var value
	var requirement = 0
	for operator in operator_chances:
		if operator_chances[operator] > 0:
			requirement+= operator_chances[operator]
			if rand < requirement:
				value = operator
				break
	operator_chances[value]-=1
	return value

func add_operator():
	var operator_instance = operator.instance()
	operator_instance.set_scale(Vector2(0.9,0.9))
	add_child(operator_instance)
	operators.append(operator_instance)
	operator_instance.set_position(Vector2(operator_area_size*3.5,0))
	operator_instance.pressed(false)
	operator_instance.value = generate_operator()
	for i in range(operator_index,operators.size()):
		operators[i].left(operator_area_size)

	