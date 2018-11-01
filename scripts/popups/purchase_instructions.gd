extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	open_anim = "open_window"
	.open()


func _on_ok_pressed():
	game.sounds.play_audio("click")
	if game.popup_layer.popup_exists("game_over"):
		game.revived = false
		game.popup_layer.close_all()
		game.popup_layer.open("game_over")
	elif game.popup_layer.popup_exists("rewarded_video_confirmation"):
		game.popup_layer.close_all()
	else:
		game.popup_layer.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))
