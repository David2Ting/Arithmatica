extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func transparent(boo):
	if boo:
		set('modulate','f7f7f7')
		set('mouse_filter',2)
	else:
		set('modulate','d9d9d9')
		set('mouse_filter',0)



#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Hint_button_down():
	set('modulate','e9e9e9')
	pass # replace with function body


func _on_Hint_button_up():
	set('modulate','d9d9d9')
	pass # replace with function body
