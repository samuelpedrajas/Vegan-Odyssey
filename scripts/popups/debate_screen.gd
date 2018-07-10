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

	.open("open_debate")
	yield($animation, "animation_finished")
	current_bubble.play()


func close():
	.close("close_debate")


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func build_dialog():
	bubble_in_progress = true

	var line = dirty_texts[current_text]
	var bubble = bubble_scene.instance()
	bubbles.append(bubble)

	bubble.setup(self, current_bubble, line)

	$"window/msgs".add_child(bubble)

	current_text += 1

	return bubble

func bubble_finished():
	bubble_in_progress = false
	$"/root".set_disable_input(false)


func start_action(action):
	if action.begins_with("lucy"):
		$"window/container/girls/lucy".play(action)
	else:
		$"window/container/girls/laura".play(action)


func _on_next_pressed():
	if not bubble_in_progress and current_text < dirty_texts.size():
		current_bubble = build_dialog()
		current_bubble.play()
