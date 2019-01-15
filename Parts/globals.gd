extends Node

var x_size = 540
var y_size = 960

var colours = {'+':'f16067','-':'aad66c','*':'fbd650','/':'4aa0b5','0':'c2c2c2','1':'da44eb'}  #e500ff
var actual_level_size = Vector2()
var tips = {'1':[['Welcome to Arithmatica!','default'],['This is your goal','goal'],['You make it by using these\nnumbers','node_holder'],['By selecting an operator','operator_holder'],['Then selecting the numbers\nto operate','node_holder']],
'10':[['If you ever get stuck\npress the hint button','hint'],['It will tell you the first\nnumber and operator to use','hint'],['Check out the other two\nmodes by pressing the button\nin the top left corner','modes']],
'40':[['Purple operators are\nspecial operators','1'],['Instead of combining\nnumbersthey apply to\nall selected numbers','1'],['This operator squares\neach number you\nselected','1']],
'stack_up_starter':[['Welcome to Stacks!','default'],['The goal of this\ngamemode is to\nscore as many\npoints as possible','default'],['Each time you use\nan operator\na row is added','default'],['Clear rows by\nmaking one of\nthe two goals','current_goal'],['When the board is \n full, its game over','default'],['Click the help icon\nfor a complete\nexplanation of\nthe rules','hints']],
'stack_up_full':[['In Stacks you\nchoose random operators\nto make the goal','current_goal'],['You can only operate\non up to 4 numbers','default'],['Each move you make\nwill add another row\nuntil it is full','default'],['As you progress\nthe difficulty of the\ngoals will become harder','current_goal'],
['Scoring multiple\ngoals in a row\nwill add to a streak','current_goal'],['A row will be\ndestroyed depending\non the size of\nthe streak','default'],['If you make one of\nthe next goals\nonce you get the current\n goal it will score\n immediately','next_goal'],
['Points are scored\nbased on how\nmany numbers are\ndestroyed from goals','score']],

'infinity_starter':[['Welcome to infinity!','default'],['In this gamemode you\nselect up to 4 operators','default'],['And a random level\nusing them will\nbe generated','default'],
['However in this\nmode you need to\nuse all the numbers\non the level\nto make the goal','default'],['The harder and the\nmore operators you use\nthe more points you\nwill score on level\ncompletion','score']]

}

#var dir = directory.new()
var user_dir = 'user://User_info.json'

var levels
var user_data

var default_user = {"level":1,"stack_up_score":0,"infinity_operators":[["-","-","+"],["*","/","/"],["*","+","-"],["/","-","+"],["/","*","/"],["-","-","+"],["+","+","-"]],"infinity_score":0,"100_methods":[],"mode":"Levels","audio":0}

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
		elif user_data['level'] > 100:
			user_data['level'] = 100

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

