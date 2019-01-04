extends Node

var x_size = 540
var y_size = 960

var colours = {'+':'f16067','-':'aad66c','*':'fbd650','/':'4aa0b5','0':'c2c2c2','1':'da44eb'}  #e500ff
var actual_level_size = Vector2()
var tips = {'1':[['Your goal the game is to make this number','goal'],['To do so you combine these numbers','node_holder'],['By selecting an operator','operator_holder'],['Then selecting the numbers to operate','node_holder']],
'40':[['Purple operators are special operators','1'],['Instead of combining numbers, they apply to all selected numbers','1'],['For example this operator would square each number you selected','1']],
'stack_up_starter':[['Welcome to stack up, an infinite gamemode','default'],['Each time you use an operator, a row is added','default'],['Clear rows by making one of the two goals','goal'],['You can also see future goals to plan for them','goal'],['Whenever the board fills up you lose a life','life_counter'],['Complete as many goals as you can before you lose all your lives','default'],['Click the help icon for a complete explanation of the rules','hints']],
}

#var dir = directory.new()
var user_dir = 'user://User_info.json'

var levels
var user_data

var default_user = {"level":1,"stack_up_score":0,"infinity_operators":[["-","-","+"],["*","/","/"],["*","+","-"],["/","-","+"],["/","*","/"],["-","-","+"],["+","+","-"]],"infinity_score":0,"100_methods":[]}

func load_data():
	var load_file = File.new()
	if load_file.open(user_dir, File.READ) == 0:
		user_data = parse_json(load_file.get_as_text())
		load_file.close()
		if user_data['level'] == 100:
			user_data['level'] = 1
	else:
		load_file.open(user_dir, File.WRITE)
		user_data = default_user
		load_file.store_line(to_json(user_data))
		

func save_data():
	var save_file = File.new()
	save_file.open(user_dir, File.WRITE)
	save_file.store_line(to_json(user_data))
	save_file.close()
func _ready():
	pass

