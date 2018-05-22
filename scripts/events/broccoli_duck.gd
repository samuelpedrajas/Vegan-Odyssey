extends Node2D


var priority = 5
var closeable = false

var step = 0

var ad_to_show = null


func start():
	$timer.set_wait_time(game.cfg.DUCK_TIME)
	$timer.start()


func stop():
	queue_free()


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		if ad_to_show == null:
			# set how much broccoli this girl will offer
			ad_to_show = admob.get_rewarded_ad_info()
		game.popup_layer.open("rewarded_video_confirmation", self)
		hide()


func _on_timer_timeout():
	game.event_layer.stop("broccoli_duck")
