extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


var share = null


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("MobileTools"):
		share = Engine.get_singleton("MobileTools")


func setup(list_entry):
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


func rescale(s):
	$window.set_scale(Vector2(s, s))
	$exit.set_scale(Vector2(s, s))
