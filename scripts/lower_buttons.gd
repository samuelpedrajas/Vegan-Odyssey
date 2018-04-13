extends Container


### ON PRESSED ACTIONS ###

func _on_menu_pressed():
	g.game.sounds.play_audio("click")
	g.open_popup("settings_menu")


func _on_reset_pressed():
	g.game.sounds.play_audio("click")
	g.open_popup("reset_confirmation")


func _on_excuses_pressed():
	g.game.sounds.play_audio("click")
	g.open_popup("book")


func _on_broccoli_pressed():
	g.game.sounds.play_audio("click")
	g.start_event("broccoli")


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

