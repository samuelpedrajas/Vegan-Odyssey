extends Container


### ON PRESSED ACTIONS ###

func _on_menu_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("settings_menu")


func _on_reset_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("reset_confirmation")


func _on_excuses_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("book")


func _on_broccoli_pressed():
	game.sounds.play_audio("click")
	game.event_layer.start("broccoli")


### ON CHANGE ACTIONS

func _on_game_broccoli_number_changed(n):
	var label = $"broccoli/circle/n_broccolis"
	var broccoli_button = $'broccoli'

	label.set_text(str(n))
	$"broccoli/circle_animation".play("used")

	# set opacity
	if n == 0:
		broccoli_button.set_disabled(true)
		label.modulate.a = 0.5
	else:
		broccoli_button.set_disabled(false)
		label.modulate.a = 1.0

