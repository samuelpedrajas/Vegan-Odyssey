extends "popup.gd"


var share = null
var subpopup = preload("res://scenes/popups/excuse_subpopup.tscn")


func _ready():
	# initialize the share singleton if it exists
	if Engine.has_singleton("GodotShare"):
		share = Engine.get_singleton("GodotShare")


func setup(excuse_index):
	$"window/actual".setup(excuse_index, game.cfg.EXCUSE_WINDOW_POS)

	if excuse_index > 1:
		$"window/prev".setup(excuse_index - 1, game.cfg.EXCUSE_WINDOW_POS + Vector2(-1080, 0))
		$"window/next".show()
	else:
		$"window/prev".hide()

	if excuse_index < 9:
		$"window/next".setup(excuse_index + 1, game.cfg.EXCUSE_WINDOW_POS + Vector2(1080, 0))
		$"window/next".show()
	else:
		$"window/next".hide()


func open(excuse_index):
	setup(excuse_index)
	.open("open_subpopup")


func close():
	.close("close_subpopup")
