extends CanvasLayer


func _ready():
	# wait until the tree is ready
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	if not game.board_layer.check_moves_available():
		glow_reset()
		if game.broccolis > 0:
			glow_broccoli()


func glow_reset():
	_play_glow(get_node("hud/lower_buttons/reset"))


func glow_broccoli():
	_play_glow(get_node("hud/lower_buttons/broccoli"))


func glow_excuses():
	_play_glow(get_node("hud/lower_buttons/excuses"))


func glow_stop():
	_stop_glow(get_node("hud/lower_buttons/reset"))
	_stop_glow(get_node("hud/lower_buttons/broccoli"))
	_stop_glow(get_node("hud/lower_buttons/excuses"))
	var anim = $"hud/lower_buttons/glow_animation"
	anim.stop()
	anim.seek(0, true)


func _play_glow(btn):
	btn.get_node("glow").show()
	var anim = $"hud/lower_buttons/glow_animation"
	if not anim.is_playing():
		anim.play("glow")


func _stop_glow(btn):
	var glow = btn.get_node("glow")
	if glow.is_visible():
		glow.hide()


### ON PRESSED ACTIONS ###

func _on_menu_pressed():
	if game.event_layer.current_events.has("tutorial"):
		game.event_layer.get_or_start("tutorial").unpost()
	game.sounds.play_audio("click")
	game.popup_layer.open("settings")


func _on_reset_pressed():
	if game.event_layer.current_events.has("tutorial"):
		game.event_layer.get_or_start("tutorial").unpost()
	game.sounds.play_audio("click")
	game.popup_layer.open("reset_board_confirmation")


func _on_excuses_pressed():
	if game.event_layer.current_events.has("tutorial"):
		game.event_layer.get_or_start("tutorial").unpost()
	game.sounds.play_audio("click")
	game.popup_layer.open("excuse_book")


func _on_broccoli_pressed():
	if game.event_layer.current_events.has("tutorial"):
		game.event_layer.get_or_start("tutorial").unpost()
	if not game.seen_tutorial["4"]:
		game.event_layer.get_or_start("tutorial").post("4")
	game.sounds.play_audio("click")
	game.event_layer.start("broccoli")


### ON CHANGE ACTIONS

func set_broccoli_amount(n):
	var broccoli_button = $"hud/lower_buttons/broccoli"
	var label = broccoli_button.get_node("circle/n_broccolis")
	var font = label.get("custom_fonts/font")
	var s = str(n)

	if n > 99:
		s = "99+"
		if font.get_size() > 30:
			font.set_size(30)
	elif font.get_size() < 45:
		font.set_size(45)


	label.set_text(s)
	broccoli_button.get_node("circle_animation").play("used")

	# set opacity
	if n == 0:
		broccoli_button.set_disabled(true)
		label.modulate.a = 0.5
	else:
		broccoli_button.set_disabled(false)
		label.modulate.a = 1.0

