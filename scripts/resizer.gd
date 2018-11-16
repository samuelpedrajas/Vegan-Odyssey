extends Node


var _f = 1.00
var s
var mobile_tools

var btn
var upper_text
var board


func get_game_height():
	var btn_h = btn.get_size().y
	var board_h = s * (
		upper_text.get_size().y + board.get_size().y
	)
	var hud_h = (btn_h + cfg.LOW_BTN_MARGIN + cfg.HIGH_BTN_MARGIN) * s
	return board_h + hud_h


func get_game_width():
	return board.get_size().x * s


var device_diagonal = 2203
var dpi = 480

func rescale_all():
	var screen_size = get_viewport().get_visible_rect().size
	var screen_diagonal = sqrt(pow(screen_size.x, 2) + pow(screen_size.y, 2))

	s = (float(dpi) / 480.0) * (_f * screen_diagonal / device_diagonal)

	# fix s if needed
	var available_x = screen_size.x
	var game_width = get_game_width()

	var ad_h = admob.getHeight()
	var available_y = screen_size.y - ad_h
	var game_height = get_game_height()

	if available_y < game_height or available_x < game_width:
		var x_ratio = available_x / game_width
		var y_ratio = available_y / game_height
		s *= min(x_ratio, y_ratio)

	for node in get_tree().get_nodes_in_group("resizable"):
		node.rescale(s)


func _ready():
	btn = game.hud_layer.get_node("hud/lower_buttons/menu")
	upper_text = $"/root/stage/dialog_layer/text"
	board = game.board_layer.get_node("board")

	if Engine.has_singleton("MobileTools"):
		mobile_tools = Engine.get_singleton("MobileTools")
		if OS.get_name() == "iOS":
			var diagonal_inches = mobile_tools.getDiagonalInches()
			var rounded_inches = int(round(diagonal_inches))
			if rounded_inches >= 9:
				_f = 1.40
			elif rounded_inches >= 7:
				_f = 1.20
			else:
				_f = 1.00
			print("Diagonal (inches): ", diagonal_inches)

			# iphone x adjustment
			if mobile_tools.theresSafeArea():
				cfg.BOARD_POSITION = 0.51

		device_diagonal = mobile_tools.getDiagonal()
		dpi = mobile_tools.pixelsPerInch()

		rescale_all()
