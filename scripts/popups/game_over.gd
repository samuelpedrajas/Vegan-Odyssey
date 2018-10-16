extends "res://scripts/popups/popup.gd"


var back_button = false
var keep_input_disabled = false
var keep_previous = false
var show_blur = true
var add_to_show


func open():
	# determine add_to_show
	add_to_show = admob.adRewarded3
	$"window/video_button/n".set_text("+3")

	if game.revived:
		# avoid the duck to appear until restarted
		game.event_layer.get_node("duck_ready").set_paused(true)
		$"window/video_button/used".show()
		$"window/video_button/bg_disabled".show()
		$"window/video_button/bg".hide()
		$"window/video_button/video_btn".set_disabled(true)
		$"window/video_button/n".set_modulate(Color(0.7, 0.7, 0.7, 1))
	else:
		# duck will take longer
		game.board_layer.movements = max(0, game.board_layer.movements - 15)
		$"window/video_button/used".hide()
		$"window/video_button/bg_disabled".hide()
		$"window/video_button/bg".show()
		$"window/video_button/video_btn".set_disabled(false)
		$"window/video_button/n".set_modulate(Color(0, 0.66, 0, 1))

	open_anim = "game_over"
	.open()
	yield($animation, "animation_finished")
	game.error9_count_locked = false
	game.hud_layer.glow_reset()
	game.save_game()


func _on_go_back_btn_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_video_btn_pressed():
	$"/root".set_disable_input(true)
	game.event_layer.start("wait_for_rewarded_ad", add_to_show)
	game.sounds.play_audio("click")
	hide()
	game.popup_layer.get_node("effects/blur").hide()


func rescale(s):
	$window.set_scale(Vector2(s, s))
