extends CanvasLayer

func _ready():
	set_current_score(game.current_score)
	set_highest_score(game.highest_score)


### SETTERS ###

func set_current_score(s):
	$"hud/header/current_score/container_sprite/current_score".set_text(str(s))


func set_highest_score(s):
	$"hud/header/max_score/container_sprite/max_score".set_text(str(s))


### ON PRESSED ACTIONS ###

func _on_menu_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("settings")


func _on_reset_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("reset_board_confirmation")


func _on_excuses_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("excuse_book")


func _on_broccoli_pressed():
	game.sounds.play_audio("click")
	game.event_layer.start("broccoli")


### ON CHANGE ACTIONS

func set_broccoli_amount(n):
	var broccoli_button = $"hud/lower_buttons/broccoli"
	var label = broccoli_button.get_node("circle/n_broccolis")


	label.set_text(str(n))
	broccoli_button.get_node("circle_animation").play("used")

	# set opacity
	if n == 0:
		broccoli_button.set_disabled(true)
		label.modulate.a = 0.5
	else:
		broccoli_button.set_disabled(false)
		label.modulate.a = 1.0

