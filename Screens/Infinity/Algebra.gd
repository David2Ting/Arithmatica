extends Node2D
var goal = null
var freeze_count = 0
func _ready():
	randomize()
	var string = '12345'
	pass


	
func calculate(operator_groups,sum):
	freeze_count = 0
	print(operator_groups)
	var random_order = random(operator_groups)
	var running_sum = sum
	var chain_group = []
	goal = sum
	var last_chain = []
	for i in range(random_order.size()):
		var operator = random_order[i]

		var chain = [false]
		
		if int(operator[0]) > 0:
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
				print('freeze')
				return 'freeze'
		print(operator[0])
		var non_zero_indexes = []
		for i in range(chain.size()):
			if chain[i] != 1 and chain[i] != 0:
				non_zero_indexes.append(i)
		var rand
		if non_zero_indexes.size()>0:
			rand = randi()%non_zero_indexes.size()
			rand = non_zero_indexes[rand]
		else:
			rand = randi()%chain.size()
		if i+1<random_order.size() and str(random_order[i+1][0]) == '*':
			rand = factor_strat(chain)
		running_sum = chain[rand]
		last_chain = [chain,rand,i]
		var new_chain = [chain,rand]
		chain_group.append(new_chain)
	chain_group.invert()
	print(chain_group)
	return chain_group

func specials(operator,last_chain):
	var type = str(operator)[0]
	var chain = last_chain[0]
	var sub_type = 2
	
	var rand_starting = randi()%(chain.size()-1)
	var rand_amount = randi()%(chain.size()-rand_starting-1)
	print(chain)
	print(rand_starting)
	print(rand_amount)
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
			print('testing'+str(num))
			if sub_type == '+':
				chain[i] = chain[i] - int(num)
	
	print(chain)
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
		print(random_order)
			
	return random_order

func distribute(aimed_num,normality,limit):
	var result = goal
	while (result == goal):
		var distribute_sum = 0
		var maximum = min(aimed_num*2,limit)
		for i in range(normality):
			distribute_sum+=round(rand_range(0,maximum))
		result = int(round(distribute_sum/normality))
	
	return result

func addition(sub_sum,times):
	var running_sum = sub_sum
	var chain = []
	for i in range(times-1):
		var aimed_num = running_sum/times
		var result = distribute(aimed_num,5,sub_sum)
		running_sum -= result
		chain.append(result)
	if running_sum == goal:
		return [false]
	chain.append(running_sum)
#	chain = random(chain)
	chain.invert()
	return chain

func subtraction(sub_sum,times):
	var running_sum = sub_sum
	var chain = []
	for i in range(times-1):
		var aimed_num = sub_sum
		var result = distribute(aimed_num,5,sub_sum*1.5)
		running_sum += result
		chain.append(result)
	if running_sum == goal:
		return [false]
	chain.append(running_sum)
	chain.invert()
	return chain

func multiplication(sub_sum,times):
	var running_sum = int(sub_sum)
	var chain = []
	for i in range(times-1):
		var factors = []
		for j in range(2,sub_sum/2+1):
			if running_sum%j == 0:
				factors.append(j)
		if factors.size()<1:
			chain.append(1)
		else:
			var rand = randi()%factors.size()
			chain.append(int(factors[rand]))
			running_sum = int(running_sum/factors[rand])
	if running_sum == goal:
		return [false]
	chain.append(running_sum)
	chain.invert()
	return chain

func division(sub_sum,times):
	var distribute = 5
	var chain = []
	var running_sum = sub_sum
	for i in range(times-1):
		var summation = goal
		while summation == goal:
			summation = 0
			for j in range(distribute):
				var rand = round(rand_range(-3,10))
				summation += rand
			summation = int(summation / distribute)
			if summation < 1:
				summation = 1
		running_sum*=summation
		chain.append(summation)
	if running_sum == goal:
		return [false]
	chain.append(running_sum)
	chain.invert()
	return chain

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
	print(possible_numbers)
	var rand = randi()%full_factor_count
	full_factor_count = 0
	for num in possible_numbers:
		if num[1]+full_factor_count > rand:
			return num[0]
		else:
			full_factor_count += num[1]
		
		
	
		