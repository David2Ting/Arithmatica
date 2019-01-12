extends Node

var x_size = 540
var y_size = 960

var colours = {'+':'f16067','-':'aad66c','*':'fbd650','/':'4aa0b5','0':'c2c2c2','1':'da44eb'}  #e500ff
var actual_level_size = Vector2()
var tips = {'1':[['Your goal the game is to make this number','goal'],['To do so you combine these numbers','node_holder'],['By selecting an operator','operator_holder'],['Then selecting the numbers to operate','node_holder']],
'40':[['Purple operators are special operators','1'],['Instead of combining numbers, they apply to all selected numbers','1'],['For example this operator would square each number you selected','1']],
'stack_up_starter':[['Welcome to stack up, an infinite gamemode','default'],['The goal of this gamemode is to score as many points as possible','goal'],['Each time you use an operator, a row is added','default'],['Clear rows by making one of the two goals','goal'],['If the board fills up, its game over','default'],['Click the help icon for a complete explanation of the rules','hints']],
'stack_up_full':[['Stack up is a game is about thinking ahead to the next goal','default'],['Each move you make will add another row until you get to the top','default'],['As you progress the difficulty the goals will become harder','current_goal'],
['Scoring multiple goals in a row will add to a streak','current_goal'],['The larger the streak, the more rows are destroyed from achieving the goal','default'],['If you prepare the next goal, once you score the current goal the next goal will score immediately','next_goal'],
['Points are scored based on how many nodes are destroyed from scoring goals','score']],

'infinity_starter':[['Welcome to infinity mode, an infinite gamemode','default'],['In this gamemode you select up to 4 operators','default'],['And a random level using them will be generated','default'],
['However in this mode you need to use all the numbers on the map to make the goal','default'],['The harder and the more operators you use, the more points you will score on level completion','score']]

}

#var dir = directory.new()
var user_dir = 'user://User_info.json'

var levels
var user_data

var default_user = {"level":1,"stack_up_score":0,"infinity_operators":[["-","-","+"],["*","/","/"],["*","+","-"],["/","-","+"],["/","*","/"],["-","-","+"],["+","+","-"]],"infinity_score":0,"100_methods":[],"mode":"Levels","audio":1}

func load_data():
	var load_file = File.new()
	if load_file.open(user_dir, File.READ) == 0:
		user_data = parse_json(load_file.get_as_text())
		load_file.close()
		for key in default_user:
			if !user_data.has(key):
				user_data[key]=default_user[key]
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

