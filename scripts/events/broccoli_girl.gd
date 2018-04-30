extends Node2D


var priority = 5


func start():
	$timer.set_wait_time(5)
	$timer.start()
	yield($timer, "timeout")
	game.event_layer.stop("broccoli_girl")


func stop():
	queue_free()


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		game.popup_layer.open("reset_board_confirmation")
