extends Node2D


onready var animation = $"animation"


func close():
	g.save_game()
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	var music_switch = $"window/music_control/switch"
	var sound_switch = $"window/sound_control/switch"
	music_switch.set_pressed(not settings.music_on)
	sound_switch.set_pressed(not settings.sound_on)
	set_position(cfg.SETTINGS_WINDOW_POS)
	animation.play("open")


func _on_switch_sound_toggled(b):
	settings.sound_on = not b
	g.game.sounds.play_audio("click")


func _on_switch_music_toggled(b):
	settings.music_on = not b
	g.game.sounds.play_audio("click")


func _on_exit_button_pressed():
	g.game.sounds.play_audio("click")
	g.open_popup("exit_confirmation")


func _on_close_button_pressed():
	g.game.sounds.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()


func _on_reset_progress_pressed():
	g.game.sounds.play_audio("click")
	g.open_popup("reset_progress_confirmation")
