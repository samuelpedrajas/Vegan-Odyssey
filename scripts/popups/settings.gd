extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true

onready var en_tick = $"window/lang/flags/en/tick"
onready var es_tick = $"window/lang/flags/es/tick"


func close():
	game.save_game()

	close_anim = "close_settings"
	.close()


func open():
	var music_switch = $"window/audio/music_control/switch"
	var sound_switch = $"window/audio/sound_control/switch"
	music_switch.set_pressed(not game.settings.music_on)
	sound_switch.set_pressed(not game.settings.sound_on)

	open_anim = "open_settings"
	.open()


func _on_switch_sound_toggled(b):
	game.settings.sound_on = not b
	game.sounds.play_audio("click")


func _on_switch_music_toggled(b):
	game.settings.music_on = not b
	game.sounds.play_audio("click")


func _on_exit_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("exit_confirmation")


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_reset_progress_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("reset_progress_confirmation")


func _on_en_pressed():
	es_tick.hide()
	en_tick.show()
	game.change_language("en")


func _on_es_pressed():
	en_tick.hide()
	es_tick.show()
	game.change_language("es")
