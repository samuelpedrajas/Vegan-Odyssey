extends Node2D


onready var animation = $"animation"


func close():
	game.save_game()
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	var music_switch = $"window/music_control/switch"
	var sound_switch = $"window/sound_control/switch"
	music_switch.set_pressed(not game.settings.music_on)
	sound_switch.set_pressed(not game.settings.sound_on)
	set_position(cfg.SETTINGS_WINDOW_POS)
	animation.play("open")


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


func _on_clickable_space_pressed():
	game.popup_layer.close()


func _on_reset_progress_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("reset_progress_confirmation")
