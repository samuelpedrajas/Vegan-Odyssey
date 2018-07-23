extends "popup.gd"


var back_button = true
var keep_input_disabled = true
var keep_previous = true
var show_blur = true

var token_index
var v_box = null

var bubbles = []
var current_bubble
var current_text = 0
var dirty_texts

var bubble_in_progress

var current_entry = null

onready var bubble_scene = preload("res://scenes/popups/bubble.tscn")


signal conversation_finished


# token_index = -1 means it's the ending
# token_index = -2 means it's the opening


func open(entry):
	if typeof(entry) == TYPE_OBJECT:
		current_entry = entry
		v_box = current_entry.get_parent()
		token_index = current_entry.token_index
	else:
		token_index = entry
		if token_index == -2:
			back_button = false
	start_conversation()
	.open("open_debate")
	yield($animation, "animation_finished")
	$"/root/stage/popup_layer/black".hide()
	current_bubble.play()


func start_conversation():
	$"window/container/next".set_disabled(false)

	if token_index < 0:
		$"window/container/prev".hide()
		$"window/container/n".hide()
		if token_index == -1:
			dirty_texts = game.ending
		elif token_index == -2:
			$"window/container/go_back".hide()
			dirty_texts = game.opening
	else:
		if token_index == 1:
			$"window/container/prev".set_disabled(true)
		else:
			$"window/container/prev".set_disabled(false)
		$"window/container/n".set_text(str(token_index))
		dirty_texts = game.conversations[token_index - 1]
		game.seen_excuses[token_index - 1].debate_seen = true
		game.save_game()

		if current_entry != null:
			current_entry.update_new_labels()

	current_bubble = build_dialog()
	for action in current_bubble.first_actions:
		start_action(action)


func close():
	.close("close_debate")
	emit_signal("conversation_finished")


func _on_go_back_pressed():
	$"/root".set_disable_input(true)
	game.sounds.play_audio("click")
	game.popup_layer.close()


func build_dialog():
	$"/root".set_disable_input(true)
	bubble_in_progress = true

	var line = dirty_texts[current_text]
	var bubble = bubble_scene.instance()
	bubbles.append(bubble)
	$"window/msgs".add_child(bubble)

	bubble.setup(self, current_bubble, line)

	current_text += 1

	return bubble


func bubble_finished():
	bubble_in_progress = false
	if current_text < dirty_texts.size():
		$"window/container/animation".play("finished")
	elif token_index == -1:
		$"window/container/next".set_disabled(true)
		$"window/container/animation".play("go_back")
	elif token_index == -2:
		if not game.music.is_playing():
			game.music.update_settings()
		$"window/container/next".set_disabled(false)
		$"window/container/animation".play("finished")
	elif token_index == game.highest_max:
		$"window/container/next".set_disabled(true)
	else:
		$"window/container/next".set_disabled(false)


func start_action(action):
	if action.begins_with("lucy"):
		$"window/container/girls/lucy".play(action)
	elif action.begins_with("lau"):
		$"window/container/girls/laura".play(action)
	elif action == "music":
		game.music.update_settings()


func _next_bubble():
	$"window/container/animation".stop()
	$"window/container/next/circle".hide()

	current_bubble = build_dialog()
	current_bubble.play()


func _finish_bubble():
	var last_actions = [current_bubble.lau_last_action, current_bubble.lucy_last_action]
	for action in last_actions:
		if action != null:
			start_action(action)
	current_bubble.finish_it()


func _next_conversation():
	$"/root".set_disable_input(true)
	$"window/container/animation".play("close_container")
	yield($"window/container/animation", "animation_finished")
	for child in bubbles:
		child.remove_me()
	$"window/msgs".set_position(Vector2(0, 1146))
	bubbles = []
	current_bubble = null
	current_text = 0
	dirty_texts = null
	bubble_in_progress = false
	$"window/msgs".set_modulate(Color(1, 1, 1, 1))

	if v_box != null:
		current_entry = v_box.get_node(str(token_index))
	start_conversation()
	current_bubble.play()


func _on_next_pressed():
	if bubble_in_progress:
		_finish_bubble()
	elif current_text < dirty_texts.size():
		game.sounds.play_audio("click")
		_next_bubble()
	elif token_index == -2:
		$"/root".set_disable_input(true)
		if admob.is_banner_loaded:
			admob.showBanner()
		game.save_game()
		game.event_layer.get_or_start("tutorial").post("1")
		game.sounds.play_audio("click")
		game.popup_layer.close()
	elif token_index < game.highest_max and not token_index < 0:
		game.sounds.play_audio("click")
		token_index += 1
		_next_conversation()


func _on_clickable_bg_pressed():
	if bubble_in_progress:
		_finish_bubble()
	elif current_text < dirty_texts.size():
		game.sounds.play_audio("click")
		_next_bubble()


func _on_prev_pressed():
	if 1 < token_index:
		game.sounds.play_audio("click")
		token_index -= 1
		_next_conversation()
