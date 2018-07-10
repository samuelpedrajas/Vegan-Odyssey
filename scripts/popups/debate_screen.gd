extends "popup.gd"


var back_button = true
var keep_input_disabled = true
var keep_previous = true
var token_index

var bubbles = []
var current_bubble
var current_text = 0
var dirty_texts

var bubble_in_progress

onready var bubble_scene = preload("res://scenes/popups/bubble.tscn")


func open(entry):
	if typeof(entry) == TYPE_OBJECT:
		token_index = entry.token_index
		game.seen_excuses[token_index - 1].debate_seen = true
		entry.update_new_labels()
	else:
		token_index = entry
		game.seen_excuses[token_index - 1].debate_seen = true

	game.save_game()

	$"window/container/n".set_text(str(token_index))

	dirty_texts = game.conversations[token_index - 1]
	current_bubble = build_dialog()
	for action in current_bubble.first_actions:
		start_action(action)

	.open("open_debate")
	yield($animation, "animation_finished")
	current_bubble.play()


func close():
	.close("close_debate")


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


func start_action(action):
	if action.begins_with("lucy"):
		$"window/container/girls/lucy".play(action)
	else:
		$"window/container/girls/laura".play(action)


func _next_bubble():
	$"window/container/animation".stop()
	$"window/container/next/circle".hide()

	game.sounds.play_audio("click")
	current_bubble = build_dialog()
	current_bubble.play()


func _finish_bubble():
	for action in current_bubble.last_actions:
		start_action(action)
	current_bubble.finish_it()


func _on_next_pressed():
	if bubble_in_progress:
		_finish_bubble()
	elif current_text < dirty_texts.size():
		_next_bubble()
	else:
		pass


func _on_clickable_bg_pressed():
	if bubble_in_progress:
		_finish_bubble()
	elif current_text < dirty_texts.size():
		_next_bubble()
	else:
		pass
