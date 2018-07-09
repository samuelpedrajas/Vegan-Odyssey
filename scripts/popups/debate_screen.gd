extends "popup.gd"

var height = 1120
var center = {
	"B": 75,
	"A": 237
}

var stops_dicts = {
	".": 10,
	",": 5,
	":": 10,
	"?": 5,
	"!": 5
}

var back_button = true
var keep_previous = true
var token_index

var bubbles = []
var current_bubble

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

	var dirty_texts = game.conversations[token_index - 1]
	current_bubble = build_dialog(dirty_texts[0])

	.open("open_debate")
	yield($animation, "animation_finished")
	current_bubble.get_node("animation").play("open")



func close():
	.close("close_debate")


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func build_dialog(line):
	var bubble = bubble_scene.instance()
	bubble.setup(line)
	bubbles.append(bubble)
	$"window/msgs".add_child(bubble)
	return bubble


func _on_timer_timeout():
	pass # replace with function body
