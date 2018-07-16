extends "popup.gd"

var back_button = false
var keep_input_disabled = true
var keep_previous = false
var show_blur = false


func open():
	set_position(game.cfg.WIN_WINDOW_POS)
	game.popup_layer.open("debate_screen", -1)
	var popup = game.popup_layer.popup_stack.back()
	popup.connect("conversation_finished", self, "win")


func win():
	back_button = true
	$window.show()
	$clickable_space.show()
	game.event_layer.start("win")
	$"window/broccoli_duck/anim".play("duck")


func close():
	.close("close_win")


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func quack():
	game.sounds.play_audio("quack")
