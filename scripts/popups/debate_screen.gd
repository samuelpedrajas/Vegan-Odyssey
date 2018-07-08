extends "popup.gd"


var back_button = true
var keep_previous = true
var token_index


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
	.open("open_debate")


func close():
	.close("close_debate")


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_animation_animation_finished(anim_name):
	if anim_name != "open_debate":
		return
