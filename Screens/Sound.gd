extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var hub = get_node('/root/Hub')
onready var globals = get_node('/root/globals')
var value = 0 setget change_value
var textures = ["res://Images/Top bar/Sound/Music.png","res://Images/Top bar/Sound/Sound.png","res://Images/Top bar/Sound/Mute.png"]
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_value(new_value):
	if new_value>2:
		new_value = 0
	value = new_value
	var texture = load(textures[new_value])
	set_normal_texture(texture)
	globals.user_data['audio'] = new_value
	print(new_value)
	globals.save_data()
	if new_value == 1:
		hub.music_player.set_volume_db(-100)
		hub.music_player_2.set_volume_db(-100)
		hub.audio_player.set_volume_db(0)
		hub.audio_player_2.set_volume_db(0)
	elif new_value == 2:
		hub.music_player.set_volume_db(-100)
		hub.music_player_2.set_volume_db(-100)
		hub.audio_player.set_volume_db(-100)
		hub.audio_player_2.set_volume_db(-100)
	else:
		hub.music_player.set_volume_db(0)
		hub.music_player_2.set_volume_db(0)
		hub.audio_player.set_volume_db(0)
		hub.audio_player_2.set_volume_db(0)
	pass # replace with function body

func _on_Sound_pressed():
	change_value(value+1)


func _on_Sound_button_down():
	set('self_modulate','45ffffff')
	pass # replace with function body


func _on_Sound_button_up():
	set('self_modulate','ffffff')
	pass # replace with function body
