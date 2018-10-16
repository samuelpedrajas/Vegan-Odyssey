extends "popup.gd"


var back_button = false
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	open_anim = "open_window"
	.open()


func close():
	.close()


func _on_ok_pressed():
	if not game.board_layer.check_moves_available():
		game.hud_layer.glow_broccoli()

	game.secretly_set_broccolis(game.broccolis + 1)
	game.save_game()

	if game.popup_layer.popup_exists("game_over"):
		game.revived = true
	else:
		game.event_layer.stop("broccoli_duck")
	game.effects_layer.play_rewarded_effect(1)

	game.sounds.play_audio("click")
	game.popup_layer.close_all()


func rescale(s):
	$window.set_scale(Vector2(s, s))
