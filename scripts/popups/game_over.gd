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

	if game.purchased and game.revived:
		game.event_layer.get_node("duck_ready").set_paused(true)
		update2adfree()
	elif game.purchased:
		game.board_layer.movements = max(0, game.board_layer.movements - 15)
		update2adfree()
	elif game.revived:
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
	game.hud_layer.glow_reset()
	game.save_game()


func _on_go_back_btn_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_video_btn_pressed():
	$"/root".set_disable_input(true)
	game.sounds.play_audio("click")
	hide()
	game.popup_layer.get_node("effects/blur").hide()

	game.event_layer.start("wait_for_rewarded_ad", add_to_show)


func rescale(s):
	$window.set_scale(Vector2(s, s))


func update2adfree():
	$window/play_minigame/go_back_btn.appear()
	$window/video_button.hide()
	if game.revived:
		$window/subsubtitle/used.show()
		$window/play_minigame.set_disabled(true)

	$window/play_minigame.show()
	$window/subsubtitle.set_text(game.lang.GAME_OVER_QUESTION_AD_FREE)


func _on_play_minigame_pressed():
	$"/root".set_disable_input(true)
	game.revived = true
	game.sounds.play_audio("click")
	game.popup_layer.close()
	game.event_layer.start("roulette")
