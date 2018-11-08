extends Control


var priority = 6
var back_button = true

var pending_tokens = 0
var closing = false

var black_bg
var black_anim

onready var animation = $"animation"


func start():
	# disable input so the user cannot move tokens
	$"/root".set_disable_input(true)
	game.board_layer.get_node("board/input_handler").hide()

	# set duck gray
	if game.event_layer.current_events.has("broccoli_duck"):
		var duck = game.event_layer.current_events["broccoli_duck"]
		duck.set_gray()

	black_anim = $"black4broccoli/black_anim"
	black_bg = $black4broccoli
	remove_child(black_bg)
	$"/root/stage".add_child(black_bg)

	animation.play("open")
	black_anim.play("open")
	yield(black_anim, "animation_finished")

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
	game.board_layer.get_node("board/input_handler").show()

	# unset duck gray
	if game.event_layer.current_events.has("broccoli_duck"):
		var duck = game.event_layer.current_events["broccoli_duck"]
		duck.unset_gray()

	animation.play("close")
	black_anim.play_backwards("open")
	yield(black_anim, "animation_finished")
	$"/root/stage".remove_child(black_bg)

	# unset selectable state for all tokens
	for token in game.board_layer.matrix.values():
		token.unset_selectable_state()
	$"/root".set_disable_input(false)
	queue_free()


func token_selected(token, direction):
	if closing:
		return

	pending_tokens += 1
	back_button = false

	# use broccoli
	game.used_broccolis += 1
	if game.start_time == null:
		game.start_time = OS.get_unix_time()
	game.broccolis -= 1
	game.hud_layer.glow_stop()

	game.board_layer.matrix.erase(token.matrix_pos)
	var new_token = null
	if game.board_layer.matrix.empty():
		new_token = game.board_layer.spawn_token(null, 1, true)

	game.recalculate_max()

	if game.event_layer.current_events.has("tutorial"):
		game.event_layer.get_or_start("tutorial").unpost()

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
		back_button = true


func do_close():
	if game.event_layer.current_events.has("tutorial"):
		game.event_layer.get_or_start("tutorial").unpost()
	closing = true
	set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
	game.event_layer.stop("broccoli")


func _on_go_back_pressed():
	if pending_tokens == 0 and not closing:
		game.sounds.play_audio("click")
		do_close()


func _on_black_pressed():
	if pending_tokens == 0 and not closing:
		do_close()


func rescale(s):
	$go_back.set_scale(Vector2(s, s))
	$go_back.set_right_pos()
	$instructions.set_scale(Vector2(s, s))
	$instructions.set_right_pos()
