extends "popup.gd"


var back_button = false
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	if not game.board_layer.check_moves_available():
		game.hud_layer.glow_broccoli()

	game.secretly_set_broccolis(game.broccolis + 1)
	game.save_game()

	if game.popup_layer.popup_exists("game_over"):
		game.revived = true

	game.effects_layer.play_rewarded_effect(1)

	open_anim = "open_no_more_ads"
	.open()


func close():
	close_anim = "close_no_more_ads"
	.close()


func _on_ok_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("purchase")


func rescale(s):
	$window.set_scale(Vector2(s, s))


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	if game.popup_layer.popup_exists("rewarded_video_confirmation"):
		game.event_layer.stop("broccoli_duck")
	game.popup_layer.close_all()
