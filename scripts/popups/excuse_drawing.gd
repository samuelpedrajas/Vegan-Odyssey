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
	_list_entry = list_entry


func open():
	open_anim = "open_subpopup"
	.open()


func close():
	close_anim = "close_window"
	.close()


var _list_entry = null


func rescale(s):
	$window.set_scale(Vector2(s, s))
	$go_back.set_scale(Vector2(s, s))
	$go_back.set_right_pos()
	var h_list = $window/h_list
	if h_list.actual_excuse == null:
		h_list.setup(_list_entry)
	else:
		var current_entry = h_list.get_current_entry()
		game.popup_layer.close()
		game.popup_layer.open("excuse_drawing", current_entry)


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()
