extends Node2D


var priority = 2
var closeable = true
var back_button = true

var pending_tokens = 0
var closing = false

onready var animation = $"animation"


func start():
	# disable input so the user cannot move tokens
	$"/root".set_disable_input(true)

	# hide the girl
	if game.event_layer.current_events.has("broccoli_girl"):
		var event = game.event_layer.current_events["broccoli_girl"]
		event.broccoli_selection = true

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
		token.connect("token_selected", self, "token_selected")

	$"/root".set_disable_input(false)


func stop():
	closing = true
	$"/root".set_disable_input(true)

	# stand up the girl
	if game.event_layer.current_events.has("broccoli_girl"):
		var event = game.event_layer.current_events["broccoli_girl"]
		event.broccoli_selection = false

	animation.play_backwards("open")
	yield(animation, "animation_finished")

	# unset selectable state for all tokens
	for token in game.board_layer.matrix.values():
		token.unset_selectable_state()
	$"/root".set_disable_input(false)
	queue_free()


func token_selected(token, direction):
	if closing:
		return

	pending_tokens += 1
	closeable = false
	var inst_id = str(token.get_instance_id())

	# use broccoli
	game.broccolis -= 1

	game.board_layer.matrix.erase(token.matrix_pos)
	var new_token = null
	if game.board_layer.matrix.empty():
		new_token = game.board_layer.spawn_token(null, 1, true)


	token.die(direction)
	yield(token, 'tree_exited')

	# if empty -> new token
	if new_token != null:
		new_token.animation.play("spawn")
		yield(new_token.animation, 'animation_finished')
		if game.broccolis > 0 and not closing:
			new_token.set_selectable_state()
			new_token.connect("token_selected", self, "token_selected")

	pending_tokens -= 1

	# no more broccoli -> exit
	if game.broccolis == 0 and pending_tokens == 0:
		closing = true
		print("no more broccolis")
		set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
		game.event_layer.stop("broccoli")
	elif pending_tokens == 0:
		closeable = true


func _on_clickable_area_gui_input(event):
	if event.is_action_pressed("click") and pending_tokens == 0 and not closing:
		closing = true
		set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
		game.event_layer.stop("broccoli")
