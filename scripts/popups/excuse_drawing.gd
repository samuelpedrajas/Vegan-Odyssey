extends "popup.gd"


var back_button = true


var share = null


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func open(excuse_index):
	set_position(game.cfg.EXCUSE_WINDOW_POS)
	$"window/h_list".setup(excuse_index)
	.open("open_subpopup")


func close():
	.close()
