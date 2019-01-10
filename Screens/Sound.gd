extends TextureButton

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var hub = get_node('/root/Hub')
var value = 0
var textures = ["res://Images/Top bar/Sound/Music.png","res://Images/Top bar/Sound/Sound.png","res://Images/Top bar/Sound/Mute.png"]
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Sound_pressed():
	value+=1
	if value>2:
		value = 0
	var texture = load(textures[value])
	set_normal_texture(texture)
	
	if value == 1:
		hub.music_player.set_volume_db(-100)
		hub.audio_player.set_volume_db(0)
	elif value == 2:
		hub.music_player.set_volume_db(-100)
		hub.audio_player.set_volume_db(-100)
	else:
		hub.music_player.set_volume_db(0)
		hub.audio_player.set_volume_db(0)
	pass # replace with function body


func _on_Sound_button_down():
	set('self_modulate','45ffffff')
	pass # replace with function body


func _on_Sound_button_up():
	set('self_modulate','ffffff')
	pass # replace with function body
