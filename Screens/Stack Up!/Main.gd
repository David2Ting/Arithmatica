extends "res://Screens/World.gd" #Stack up!

onready var goal_container = get_node('GoalContainer')

var goals = preload("res://Screens/Stack Up!/Goals.tscn")
var current_goal = [null,null]
var next_goal = [null,null]
var current_goal_position = [null,null]
var next_goal_position = [null,null]
var goal_position_distance = 100
var streak = 0
var total_points = 0

onready var drop_timer = get_node('DropTimer')
func _ready():
	setup_dimensions()
	operators_holder.start()
	add_goal(0)
	add_goal(0)  #Left
	add_goal(1)
	add_goal(1)   #Right
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass




func _input(event):
	if event.is_action_pressed('right_click'):
		current_level.add_row()

func operate_chain():
	if int(current_operator) > 0:
		operate_specials()
	else:
		var last_node = select_chain[0]
		last_node = select_chain[-1]
		last_node.value = sum
		var index = current_goal.find(last_node.value)
		if index > -1:
			success(last_node,index)
			last_node.select(false)
			operators_holder.off_operator()
			select_chain = []
		else:
			current_level.pop_nodes(select_chain,false)
			audio_player.stream = pop_sound
			audio_player.play()
			calculator.value = 0
			drop_timer.start()
			last_node.select(false)
			operators_holder.off_operator()
			select_chain = []
			yield(drop_timer,'timeout')
			current_level.add_row()
			streak = 0


func success(last_node,index):
	last_node.animation.play('Success')
	calculator.value = 'WIN'
	current_level.pop_nodes(select_chain,false)
	audio_player.stream = success_sound
	audio_player.play()
	drop_timer.start()
	yield(drop_timer,'timeout')
	current_level.reward('row',last_node,index)


func add_goal(side):
	var goal_instance = goals.instance()
	goal_container.add_child(goal_instance)
	var distance
	var index
	if side == 1:
		distance = goal_position_distance
		index = 1
	else:
		distance = -goal_position_distance
		index = 0
	goal_instance.set_position(Vector2(2.8*distance,0))
	goal_instance.appear(distance)
	goal_instance.value = random_goal()
	if next_goal_position[index]:
		current_goal[index] = next_goal[index]
		current_goal_position[index] = next_goal_position[index]
		next_goal_position[index].upgrade(distance)
	next_goal[index] = goal_instance.value
	next_goal_position[index] = goal_instance

func random_goal():
	var black_list_nodes = []
	if current_level.node_positions.size()>1:
		for i in range(-1,-min(6,node_positions.size()),-1):
			for x in range(5):
				if current_level.node_positions[i][x]:
					black_list_nodes.append(current_level.node_positions[i][x])
	var black_list_numbers = current_goal+next_goal+black_list_nodes
	var row = []
	var rand = null
	while !rand or black_list_numbers.find(rand)>-1:
		var sum = 0
		for i in range(5):
			sum += randi()%20-5
		rand = sum / 5
	return rand

func add_node(obj):
	if pressed and select_chain.size()>0 and (check_adjacency(select_chain[-1],obj)) and current_operator and !obj.is_block:
		if select_chain.size()>1 and select_chain[-2]==obj:
			select_chain[-1].select(false)
			select_chain.pop_back()
			calculate_sum()
		elif select_chain.find(obj)>=0:
			return
		elif select_chain.size()>=4:
			return
		elif current_operator=='/' and (obj.value == 0 or int(running_sum)%int(obj.value) != 0):
			return
		elif current_operator == '2' and (obj.value < 0 or float(sqrt(obj.value))!=int(sqrt(obj.value))):
			return
	
		else:
			select_chain.append(obj)
			obj.select(true)
			calculate_sum()

func add_points(amount):
	total_points += amount
	level_select.value = total_points
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
