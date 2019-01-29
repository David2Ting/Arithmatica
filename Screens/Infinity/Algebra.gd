extends Node2D
var goal = null
var freeze_count = 0
var running_sum = null
var black_list_goals = []
var is_last = false

func _ready():
	randomize()
	pass


	
func calculate(operator_groups,sum):
	black_list_goals = []
	goal = null
	freeze_count = 0
	var random_order = random(operator_groups)
	running_sum = null
	var chain_group = []
	goal = sum
	var last_chain = []
	is_last = false
	get_parent().hint[1] = random_order[0][0]
	for i in range(random_order.size()):
		if i == random_order.size()-1:
			is_last = true
		var operator = random_order[i]

		var chain = [false]
		
		if int(operator[0]) > 0:
			continue
			var new_chain = specials(operator[0],last_chain)
			running_sum = new_chain[0][last_chain[1]]
			chain_group[last_chain[2]]=new_chain
			continue
		while chain==[false]:
			if str(operator[0]) == '+':
				chain = addition(running_sum,operator[1])
			elif str(operator[0]) == '-':
				chain = subtraction(running_sum,operator[1])
			elif str(operator[0]) == '*':
				chain = multiplication(running_sum,operator[1])
			elif str(operator[0]) == '/':
				chain = division(running_sum,operator[1])
			freeze_count += 1
			if freeze_count > 50:
				return 'freeze'
		var non_zero_indexes = []
		for i in range(chain.size()):
			if chain[0][i] != 1 and chain[0][i] != 0:
				non_zero_indexes.append(i)
		var rand
		if non_zero_indexes.size()>0:
			rand = randi()%non_zero_indexes.size()
			rand = non_zero_indexes[rand]
		else:
			rand = randi()%chain.size()
		last_chain = [chain,rand,i]
		chain_group.append(chain)
#	print(chain_group)
	return [chain_group,running_sum]

func specials(operator,last_chain):
	var type = str(operator)[0]
	var chain = last_chain[0]
	var sub_type = 2
	
	var rand_starting = randi()%(chain.size()-1)
	var rand_amount = randi()%(chain.size()-rand_starting-1)
	for i in range(rand_starting,rand_starting+rand_amount+2):
		if str(operator).length()>1:
			sub_type = str(operator)[1]
		if type == '1':
			pass
		elif type == '2':
			chain[i] = pow(chain[i],2)
		elif type == '3':
			if int(sub_type)<3:
				chain[i] = chain[i] * pow(10,int(sub_type))
		elif type == '5':
			var num = ''
			for i in range(2,str(operator).length()):
				num += str(operator)[i]
			if sub_type == '+':
				chain[i] = chain[i] - int(num)
	
	return [chain,last_chain[1]]

func random(operator_groups):   #Randomize order of operators
	var random_order = []
#	for i in range(operator_groups.size()):
#		var first = 1
#		var rand
	var first = 1
	var rand
	while int(first)>0:
		rand = randi()%operator_groups.size()
		first = operator_groups[rand][0]
	random_order.append(operator_groups[rand])
	operator_groups.remove(rand)
	
	for i in range(operator_groups.size()):
		var r = randi()%operator_groups.size()
		random_order.append(operator_groups[r])
		operator_groups.remove(r)
	random_order.invert()
	return random_order

func distribute(aimed_num,normality,limit):
	var result = goal
	while (result == goal or result == 0):
		var distribute_sum = 0
		var maximum = min(aimed_num*2,limit)
		for i in range(normality):
			distribute_sum+=round(rand_range(0,maximum))
		result = int(round(distribute_sum/normality))
	return result

func addition(sub_sum,times):
	var chain
	if !sub_sum:
		var rand = randi()%10+1
		sub_sum = rand
		chain = [rand]
		running_sum = 0
	else:
		chain = [sub_sum]
	black_list_goals.append(sub_sum)
	for i in range(times-1):
		var aimed_num = 5
		var result = null
		result = distribute(aimed_num,5,sub_sum)
		sub_sum += result
		var order = randi()%2
		if order>0:
			chain.append(result)
		else:
			chain.push_front(result)
		black_list_goals.append(result)
	var index = chain.find(running_sum)
	if is_last:
		while black_list_goals.find(sub_sum)>-1:
			var rand = randi()%5+1
			sub_sum += rand
			chain.append(rand)
	running_sum = sub_sum

	return [chain,index]

func subtraction(sub_sum,times):
	var chain
	var is_front = false
	if !sub_sum:
		var rand = randi()%10+5
		sub_sum = rand
		chain = [rand]
#		running_sum = 0
	else:
		chain = [sub_sum]
	black_list_goals.append(sub_sum)
	if sub_sum>10:
		var front_chance = randi()%2
		if front_chance > 0:
			is_front = true
	var added_sum = sub_sum

	if is_front:
		for i in range(times-1):
			var aimed_num = sub_sum/times
			var result = null
	#		while !result or result == goal:
			result = distribute(aimed_num,5,sub_sum)
			sub_sum -= result
			chain.append(result)
			black_list_goals.append(result)
	else:
		for i in range(times-2):
			var aimed_num = 5
			var result = null
	#		while !result or result == goal:
			result = distribute(aimed_num,5,sub_sum)
			var order = randi()%2
			if order>0:
				chain.append(result)
			else:
				chain.push_front(result)
			black_list_goals.append(result)
			added_sum += result
		var result = randi()%10+5
		chain.push_front(added_sum+result)
		black_list_goals.append(added_sum+result)
		sub_sum = result
	
#	if running_sum == goal:
#		return [false]
	var index = chain.find(running_sum)
	
	if is_last:
		while black_list_goals.find(sub_sum)>-1:
			var rand = randi()%5+1
			sub_sum -= rand
			chain.append(rand)
	running_sum = sub_sum
#	chain = random(chain)
#	chain.invert()
	return [chain,index]

func multiplication(sub_sum,times):
	var chain
	if !sub_sum:
		var rand = randi()%10+1
		sub_sum = rand
		chain = [rand]
		running_sum = 0
	else:
		chain = [sub_sum]
	black_list_goals.append(sub_sum)
	for i in range(times-1):
		var aimed_num = 3
		var result = null
		result = distribute(aimed_num,5,10)
		sub_sum *= result
		var order = randi()%2
		if order>0:
			chain.append(result)
		else:
			chain.push_front(result)
		black_list_goals.append(result)
		if result > 100:
			break
	var index = chain.find(running_sum)

	if is_last:
		while black_list_goals.find(sub_sum)>-1:
			var rand = randi()%2+2
			sub_sum *= rand
			chain.append(rand)
	running_sum = sub_sum

	return [chain,index]

func division(sub_sum,times):
	times = 2
	var chain
	var is_front = false
	if !sub_sum:
		var rand = randi()%10+5
		sub_sum = rand
		chain = [rand]
		running_sum = 0
	else:
		chain = [sub_sum]
	black_list_goals.append(sub_sum)
	if sub_sum>50:
		var front_chance = randi()%2
		if front_chance > 0:
			is_front = true
	var added_sum = sub_sum

	if is_front:
		var factors = []
		for i in range(2,sub_sum/2+1):
			if sub_sum%i==0:
				factors.append(i)
		if factors.size()>0:
			var rand = randi()%factors.size()
			var result = factors[rand]
			sub_sum/=result
			chain.append(sub_sum)
		else:
			var rand = randi()%5
			sub_sum = rand
			chain.push_front(sub_sum*rand)
			black_list_goals.append(sub_sum*rand)
	else:
		for i in range(times-2):
			var aimed_num = 2
			var result = null
	#		while !result or result == goal:
			result = distribute(aimed_num,5,5)
			var order = randi()%2
			if order>0:
				chain.append(result)
			else:
				chain.push_front(result)
			black_list_goals.append(result)
			added_sum *= result
		var result = randi()%4+1
#		if chain.size() == 1:
#			result = randi()%5+1
		chain.push_front(added_sum*result)
		black_list_goals.append(added_sum*result)
		sub_sum = result
	
#	if running_sum == goal:
#		return [false]

	var index = chain.find(running_sum)
	if is_last:
		var final_sum = 1
		for i in range(chain.size()):
			final_sum*=chain[i]
		if black_list_goals.find(sub_sum)>-1:
			chain.push_front(final_sum)
			while black_list_goals.find(sub_sum)>-1:
				var rand = randi()%2+2
				chain[0] *=rand
				sub_sum = chain[0]/final_sum
	running_sum = sub_sum

#	chain = random(chain)
#	chain.invert()
	return [chain,index]

func factor_strat(chain):
	var possible_numbers = []
	var full_factor_count = 0
	for i in range(chain.size()):
		var factor_count = 1
		full_factor_count+=1
		var num = chain[i]
		for j in range(2,num/2+1):
			if num%j == 0:
				factor_count+=1
				full_factor_count+=1
		possible_numbers.append([i,factor_count])
	var rand = randi()%full_factor_count
	full_factor_count = 0
	for num in possible_numbers:
		if num[1]+full_factor_count > rand:
			return num[0]
		else:
			full_factor_count += num[1]
		
		
	
		