extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


var share = null


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func setup(list_entry):
	set_position(game.cfg.EXCUSE_WINDOW_POS)
	$"window/h_list".setup(list_entry)


func open():
	open_anim = "open_subpopup"
	.open()


func close():
	close_anim = "close_window"
	.close()


func _on_exit_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()
