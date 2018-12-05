extends "popup.gd"


var back_button = false
var keep_input_disabled = true
var keep_previous = false
var show_blur = false

var mobile_tools = null


func _ready():
	# initialize the mobile_tools singleton if it exists
	if Engine.has_singleton("MobileTools"):
		mobile_tools = Engine.get_singleton("MobileTools")

	if OS.get_name() != "Android":
		$window/content/box/rate_us.hide()

	if game.lang.language == "es":
		$window/content/title/title_es.show()
		$window/content/title/title_es/anim.play("glow")
	else:
		$window/content/title/title_en.show()
		$window/content/title/title_en/anim.play("glow")


func open():
	game.popup_layer.open("debate_screen", -1)
	var popup = game.popup_layer.popup_stack.back()
	popup.connect("conversation_finished", self, "win")


func win():
	game.debate_layer.init(cfg.GOAL)
	back_button = true
	$window.show()
	$go_back.appear_instantly()
	$clickable_space.show()
	game.event_layer.start("win")
	$"window/content/duck/broccoli_duck/anim2".play("duck")


func close():
	if OS.get_name() == "iOS" and Engine.has_singleton("MobileTools"):
		var mobile_tools = Engine.get_singleton("MobileTools")
		if mobile_tools.canShowRate():
			mobile_tools.rateApp()
	close_anim = "close_win"
	.close()


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_share_pressed():
	game.sounds.play_audio("click")

	if mobile_tools != null:
		mobile_tools.shareText(
			game.lang.TITLE,
			game.lang.SUBJECT,
			game.lang.MSG
		)


func _on_rate_us_pressed():
	OS.shell_open("https://play.google.com/store/apps/details?id=com.vegames.veganodyssey")


func rescale(s):
	$go_back.set_scale(Vector2(s, s))
	$go_back.set_right_pos()
	$window/content.set_scale(Vector2(s, s))
	$window/bg.set_scale(Vector2(s, s))
