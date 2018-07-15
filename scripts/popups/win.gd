extends "popup.gd"

var back_button = false
var keep_input_disabled = true
var keep_previous = false
var show_blur = false


func open():
	set_position(game.cfg.WIN_WINDOW_POS)
	game.popup_layer.open("debate_screen", 9)
	var popup = game.popup_layer.popup_stack.back()
	popup.connect("conversation_finished", self, "win")


func win():
	game.event_layer.start("win")
	print("here we are")


func close():
	.close("close_window")
