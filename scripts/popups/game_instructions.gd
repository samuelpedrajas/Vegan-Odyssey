extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true

var current = 0
var total = 3
var coming_from_start = false

onready var tween = $window/tween
onready var items = $window/items


func _ready():
	total = items.get_child_count()


func setup(coming_from_start):
	self.coming_from_start = coming_from_start
	$go_back.set_custom_text(game.lang.GAME_OVER_PLAY_ROULETTE)
	$clickable_space.hide()

func open():
	open_anim = "open_instructions"
	.open()


func close():
	close_anim = "close_window"
	.close()


func rescale(s):
	for c in $window/items.get_children():
		var res = get_viewport().get_visible_rect().size
		var new_size = Vector2(1038.0 / 2.0 + res.x / 2.0, c.get_size().y)
		c.set_custom_minimum_size(new_size)
		c.set_size(new_size)
		c.set_scale(Vector2(s, s))
	$go_back.set_scale(Vector2(s, s))


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func do_move():
	$"/root".set_disable_input(true)
	var res = get_viewport().get_visible_rect().size
	var new_pos = Vector2(-(1038.0 / 2.0 + res.x / 2.0) * current, items.get_position().y)
	tween.interpolate_method(
		items, "set_position", items.get_position(), new_pos, 0.5, Tween.TRANS_CUBIC,Tween.EASE_OUT
	)
	tween.start()


func _on_prev_pressed():
	if current - 1 < 0:
		return
	current -= 1
	do_move()


func _on_next_pressed():
	if current + 1 > total:
		return
	current += 1
	do_move()


func _on_tween_tween_completed(object, key):
	$"/root".set_disable_input(false)


func _on_game_instructions_tree_exiting():
	if coming_from_start:
		game.event_layer.get_or_start("tutorial").post("1")
