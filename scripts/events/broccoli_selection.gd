extends Node2D


var priority = 1
var closeable = true


onready var animation = $"animation"

var board_original_layer = 2
var popup_original_layer = 4


func start():
	# disable input so the user cannot move tokens
	$"/root".set_disable_input(true)

	# hide the girl
	if game.event_layer.current_events.has("broccoli_girl"):
		var event = game.event_layer.current_events["broccoli_girl"]
		event.broccoli_selection = true

	# put board above
	board_original_layer = game.board_layer.get_layer()
	var n = game.event_layer.get_layer()
	game.board_layer.set_layer(n + 1)
	game.popup_layer.set_layer(n + 2)

	animation.play("open")
	yield(animation, "animation_finished")

	# wait until all tokens are stopped
	for t in game.board_layer.matrix.values():
		if not t.is_stopped():
			yield(t, "movement_finished")
		if t.animation.is_playing():
			yield(t.animation, "animation_finished")

	# set selectable state for all tokens
	for token in game.board_layer.matrix.values():
		token.set_selectable_state()

	$"/root".set_disable_input(false)


func stop():
	$"/root".set_disable_input(true)
	# stand up the girl
	if game.event_layer.current_events.has("broccoli_girl"):
		var event = game.event_layer.current_events["broccoli_girl"]
		event.broccoli_selection = false

	animation.play_backwards("open")
	yield(animation, "animation_finished")
	game.board_layer.set_layer(board_original_layer)
	game.popup_layer.set_layer(popup_original_layer)

	# unset selectable state for all tokens
	for token in game.board_layer.matrix.values():
		token.unset_selectable_state()
	$"/root".set_disable_input(false)
	queue_free()


func _on_clickable_area_gui_input(event):
	if event.is_action_pressed("click"):
		game.event_layer.stop("broccoli")
