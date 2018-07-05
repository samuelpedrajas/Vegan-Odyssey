extends "popup.gd"


var back_button = true
var token_index
var entry


func open(_entry):
	entry = _entry
	token_index = entry.token_index
	game.seen_excuses[token_index - 1].debate_seen = true
	entry.update_new_labels()
	game.save_game()

	print("EXCUSA: ", token_index)
	.open("open_debate")


func close():
	.close("close_debate")


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()
