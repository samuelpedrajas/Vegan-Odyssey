extends Node2D


var priority = 5
var back_button = false

var step = 0

var ad_to_show = null

var unclicked = true


func start():
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
		unclicked = false
		game.duck_counter = 0
		if ad_to_show == null:
			# set how much broccoli this girl will offer
			ad_to_show = admob.get_rewarded_ad_info()
		game.popup_layer.open("rewarded_video_confirmation", self)

func _on_animation_animation_finished(anim_name):
	if unclicked:
		game.duck_counter += 1
	game.event_layer.stop("broccoli_duck")
