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
		var t1 = game.board_layer.spawn_token(null, 8, true)
		var t2 = game.board_layer.spawn_token(null, 8, true)
		for t in [t1, t2]:
			if t != null:
				t.animation.play("spawn")
		game.broccolis += 10
		game.event_layer.start("broccoli_duck")
	game.sounds.play_audio("click")
	game.popup_layer.close()
