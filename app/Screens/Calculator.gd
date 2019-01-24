extends Label

onready var timer = get_node('Timer')
var value = 0 setget change_value

func change_value(new_value):
	if str(value) != str(new_value):
		value = new_value
		hide()
		timer.start()
		if str(new_value).length() > 8:
			set_text('overflow')
		else:
			set_text(str(new_value))
		yield(timer,'timeout')
		show()