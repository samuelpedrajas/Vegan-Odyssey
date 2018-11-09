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

	if game.lang.language == "es":
		$"window/lang/flags/es/tick".show()
	else:
		$"window/lang/flags/en/tick".show()

	open_anim = "open_settings"
	.open()


func _on_switch_sound_toggled(b):
	game.settings.sound_on = not b
	game.sounds.play_audio("click")


func _on_switch_music_toggled(b):
	game.settings.music_on = not b
	game.sounds.play_audio("click")


func _on_reset_progress_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.open("reset_progress_confirmation")


func _on_en_pressed():
	es_tick.hide()
	en_tick.show()
	if game.lang.language != "en":
		$loading_language.set_loading("en")


func _on_es_pressed():
	en_tick.hide()
	es_tick.show()
	if game.lang.language != "es":
		$loading_language.set_loading("es")


func rescale(s):
	var s2 = Vector2(s, s)
	$window.set_scale(s2)
	$go_back.set_scale(s2)
	$go_back.set_right_pos()
	$loading_language/text.set_scale(s2)


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_records_pressed():
	if cfg.DEV_MODE:
		game.event_layer.start("broccoli_duck")
	game.sounds.play_audio("click")
	game.popup_layer.open("records")


func purchase_reorder():
	$"window/manage_ads".hide()

	var records = $"window/records"
	records.set_position(
		records.get_position() + Vector2(0, 60)
	)

	var reset_progress = $"window/reset_progress"
	reset_progress.set_position(
		reset_progress.get_position() - Vector2(0, 60)
	)


func _ready():
	if game.purchased:
		purchase_reorder()
	else:
		iap_helper.connect("purchase_success", self, "purchase_reorder")
		iap_helper.connect("restore_purchases_success", self, "purchase_reorder")

