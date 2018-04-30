extends Node2D


var priority = 5
var step = 0


func start():
	play_animation("hidden", 4)


func stop():
	queue_free()


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		game.popup_layer.open("reset_board_confirmation")


func _on_timer_timeout():
	if step == 1:
		play_animation("hello", 4)
	elif step == 2:
		play_animation("angry", 4)
	elif step == 3:
		play_animation("hidden", 0.5)
	else:
		game.event_layer.stop("broccoli_girl")


func play_animation(anim, secs):
	step += 1
	$"broccoli_girl".play(anim)
	$timer.set_wait_time(secs)
	$timer.start()
