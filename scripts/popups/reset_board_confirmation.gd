extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	open_anim = "open_window"
	.open()


func _on_ok_button_pressed():
	game.sounds.play_audio("click")
	game.restart_game()


func _on_cancel_button_pressed():
	if cfg.DEV_MODE:
		var amount = 3
		game.secretly_set_broccolis(game.broccolis + amount)
		game.effects_layer.play_rewarded_effect(amount)
	game.sounds.play_audio("click")
	game.popup_layer.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))
