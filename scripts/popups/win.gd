extends "popup.gd"


var back_button = false
var keep_input_disabled = true
var keep_previous = false
var show_blur = false

var share = null


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func open():
	game.popup_layer.open("debate_screen", -1)
	var popup = game.popup_layer.popup_stack.back()
	popup.connect("conversation_finished", self, "win")


func win():
	game.debate_layer.init(cfg.GOAL)
	back_button = true
	$window.show()
	$clickable_space.show()
	game.event_layer.start("win")
	$"window/content/duck/broccoli_duck/anim".play("duck")


func close():
	close_anim = "close_win"
	.close()


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_share_pressed():
	game.sounds.play_audio("click")

	if share != null:
		share.shareText(
			game.lang.TITLE,
			game.lang.SUBJECT,
			game.lang.MSG
		)
