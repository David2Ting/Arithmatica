extends "res://Screens/World.gd" #Stack up!

#onready var goal_container = get_node('GoalContainer')


var current_goal = [null,null]
var next_goal = [null,null]
var current_goal_position = [null,null]
var next_goal_position = [null,null]
var goal_position_distance = 100
var streak = 0
var total_points = 0
var current_health = 4 
var max_health = 4
var mode = 'Stacks'
var difficulty_progress = 1
var progress
var high_score

var level_1 = [1,2,3,4,5,6,7,8,9,10,12]
var level_2 = [1,2,3,4,5,6,7,8,9,10,11,12,14,16,18,20,24]
var level_3 = [-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,24,25,27,28,30,32]
var level_4 = [-10,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32]
var level_5 = [-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,42,45,49,50]
var level_6 = [-20,-16,-15,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,42,45,49,50,64,75,80,100]
var levels = [level_1,level_2,level_3,level_4,level_5,level_6]
var difficulty_goals
#onready var current_health_label = get_node('Header/Health/Current')
var drop_timer
func start():
	.start()
	drop_timer = get_node('DropTimer')
	current_level.start()
	setup_dimensions()
	load_progress()
#	operators_holder.start()
	hub.high_score.value = high_score
	goals = preload("res://Screens/Stack Up!/Goals.tscn")
	add_goal(0,true)
#	add_goal(0,true)  #Left
	add_goal(1,true)
	yield(next_goal_position[0].get_node('Tween'),'tween_completed')
		
	add_goal(0,true)   #Right
	add_goal(1,true)   #Right
	
	current_level.add_row()

	if high_score == 0:
		hub.start_tip('stack_up_starter')
	level_select.value = 0
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
	if event.is_action_pressed('right_click'):
		current_level.add_row()

func load_progress():
	high_score = globals.user_data['stack_up_score']

func operate_chain():
	if int(current_operator) > 0:
		operate_specials()
	else:
		var last_node = select_chain[0]
		last_node = select_chain[-1]
		last_node.value = sum
		var index = current_goal.find(last_node.value)
		if index > -1:
			var dropping = current_level.check_above_entire(select_chain)
			current_level.pop_nodes(select_chain,false)
			last_node.pressed(false)
			if last_node.drop_amount > 0:
				yield(current_level,'tween_completed')
			success(last_node,index,dropping)
			last_node.select(false)
			operators_holder.off_operator()
			select_chain = []
		else:
			var test_chain = [] + select_chain
			test_chain.pop_back()
			var dropping = current_level.check_above(test_chain)
			current_level.pop_nodes(select_chain,false)
			audio_player.stream = pop_sound
			audio_player.play()
			calculator.value = 0
#			drop_timer.start()
			last_node.select(false)
			operators_holder.off_operator()
			select_chain.pop_back()
			if dropping:
				yield(current_level,'tween_completed')
			elif current_level.popping_nodes:
				print('popping')
				yield(current_level,'pop_finish')
			current_level.transition_timer.start()
			yield(current_level.transition_timer,'timeout')
			select_chain = []
			current_level.add_row()
			streak = 0


func success(last_node,index,dropping):
	last_node.animation.play('Success')
	calculator.value = 'WIN'
	audio_player.stream = success_sound
	audio_player.play()
#	drop_timer.start()
	if dropping:
		yield(current_level,'tween_completed')
#	else:
	current_level.transition_timer.start()
	yield(current_level.transition_timer,'timeout')
#		yield(last_node,'success_finish')
	current_level.reward('row',last_node,index)


func add_goal(side,first=false):
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
	print('before_random')
	goal_instance.value = random_goal()
	print('after')
	if next_goal_position[index]:
		current_goal[index] = next_goal[index]
		current_goal_position[index] = next_goal_position[index]
		next_goal_position[index].upgrade(distance)
	next_goal[index] = goal_instance.value
	next_goal_position[index] = goal_instance
	var second_goal = false
	if current_level.node_positions.size()>1:
		for i in range(-1,-min(6,node_positions.size()),-1):
			for x in range(5):
				if current_level.node_positions[i][x]:
					if current_level.node_positions[i][x].value == current_goal[index] and !second_goal:
						var dropping = current_level.check_above([current_level.node_positions[i][x]])
						if dropping:
							yield(current_level,'tween_completed')
						success(current_level.node_positions[i][x],index,dropping)
						second_goal = true
						break
	difficulty_progress += 0.1
	if !second_goal and !first:
		current_level.transition_timer.start()
		yield(current_level.transition_timer,'timeout')
		current_level.add_row()

func random_goal():
	var current_difficulty = int(difficulty_progress) 
	current_difficulty = clamp(current_difficulty,1,levels.size())
	var black_list_nodes = []
	var potential_goals = []
	for i in range(current_difficulty):
		potential_goals+=levels[i]

	if current_level.node_positions.size()>0:
		for i in range(-1,-min(6,node_positions.size()),-1):
			for x in range(5):
				if current_level.node_positions[i][x]:
					black_list_nodes.append(current_level.node_positions[i][x].value)
	var black_list_numbers = current_goal+next_goal+black_list_nodes

	var all_goals = current_goal+next_goal
	var has_negative = false
	for i in range(all_goals.size()):
		if all_goals[i] and all_goals[i]<0:
			has_negative = true
	var row = []
	var rand = null
	var safety = 0
	while (!rand or black_list_numbers.find(rand)>-1 or (rand<0 and has_negative)) and safety<20:
		var rand_index = randi()%potential_goals.size()
		rand = potential_goals[rand_index]
		safety+=1
	print(next_goal)
	if safety == 20:
		while !rand or black_list_numbers.find(rand)>-1 or (rand<0 and has_negative):
			rand = randi()%30
	return rand

func random_reward(goal):
	var difficulty = find_difficulty(goal)
	difficulty = round(rand_range(max(0,difficulty-5),difficulty+5))
	if difficulty > 30:
		return 'screen'
	elif difficulty > 20:
		return 'heart'
	elif difficulty > 15:
		return 'box'
	else:
		return 'row'
func find_difficulty(goal):
	var difficulty
	difficulty = abs(goal)
	
	var factors = 0
	if abs(goal) !=1 and abs(goal)!=0:
		for i in range(1,abs(goal/2)+1):
			if goal%i == 0:
				factors+=1
		difficulty = difficulty/2 + difficulty/(2*factors)
	
	if goal < 0:
		difficulty = (difficulty+3)*2
	return difficulty

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
	if total_points > high_score:
		high_score = total_points
		hub.high_score.value = total_points
		globals.user_data['stack_up_score'] = total_points
		globals.save_data()
func change_health(amount):
	return

func game_over():
	print('game')
	hub.tips_screen.get_node('AnimationPlayer').play('Tips')
	hub.miscellaneous.change_final_score(total_points)
	hub.miscellaneous.stack_up_appear()
func reset():
	hub.miscellaneous.stack_up_disappear()
	hub.change_mode('Stacks')
#	if current_health + amount > max_health:
#		current_health = max_health
#	else:
#		current_health+=amount
#	current_health_label.set_text(str(current_health))
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
