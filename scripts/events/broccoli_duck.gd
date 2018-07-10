extends Node2D


var priority = 4
var back_button = false

var step = 0

var ad_to_show = null

var unclicked = true

var grayed_out = false


func set_gray():
	if not grayed_out:
		grayed_out = true
		set_modulate(Color(0.4, 0.4, 0.4, 1))


func unset_gray():
	if grayed_out:
		grayed_out = false
		set_modulate(Color(1, 1, 1, 1))


func start():
	if game.event_layer.current_events.has("broccoli"):
		set_gray()
	if game.duck_counter >= 2:
		$"broccoli_duck/stuff/wing".show()
		$"broccoli_duck/stuff/stick".show()
	else:
		$"broccoli_duck/stuff/wing".hide()
		$"broccoli_duck/stuff/stick".hide()
	$animation.play("flying")


func stop():
	queue_free()


func quack():
	game.sounds.play_audio("quack")


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		# can't click if removing tokens
		if not grayed_out:
			unclicked = false
			game.duck_counter = 0
			if ad_to_show == null:
				# set how much broccoli this girl will offer
				ad_to_show = admob.get_rewarded_ad_info()
			game.popup_layer.open("rewarded_video_confirmation", self)
		else:
			game.event_layer.stop("broccoli")

func _on_animation_animation_finished(anim_name):
	if unclicked:
		game.duck_counter += 1
	game.event_layer.stop("broccoli_duck")
