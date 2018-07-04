extends "popup.gd"


var back_button = true


var share = null


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func open(list_entry):
	set_position(game.cfg.EXCUSE_WINDOW_POS)
	$"window/h_list".setup(list_entry)
	.open("open_subpopup")


func close():
	.close()


func _on_exit_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()
