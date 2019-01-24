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

signal waiting4removal


func _ready():
	wait_until_tree_exited = false
	total = items.get_child_count()

	# translate
	$window/items/item1/texture_rect/title.set_text(game.lang.GOAL)
	$window/items/item1/texture_rect/goal_description.set_text(game.lang.GOAL_DESCRIPTION)
	$window/items/item1/texture_rect/text_arrow_up.set_text(game.lang.EXCUSES_NAME)
	$window/items/item1/texture_rect/text_arrow_down.set_text(game.lang.EXCUSES_NUMBER)

	if game.lang.language == "es":
		$window/items/item1/texture_rect/excuse/excuse_en.hide()
		$window/items/item1/texture_rect/excuse/excuse_es.show()

	$window/items/item2/texture_rect2/vbox/tip1.set_text(game.lang.TIP1_1)
	$window/items/item2/texture_rect2/vbox/tip2.set_text(game.lang.TIP1_2)
	$window/items/item2/texture_rect2/vbox/tip3.set_text(game.lang.TIP1_3)
	$window/items/item2/texture_rect2/vbox/tip4.set_text(game.lang.TIP1_4)

	$window/items/item3/texture_rect3/vbox/tip1.set_text(game.lang.TIP2_1)
	$window/items/item3/texture_rect3/vbox/tip2.set_text(game.lang.TIP2_2)
	$window/items/item3/texture_rect3/vbox/tip3.set_text(game.lang.TIP2_3)


func setup(coming_from_start):
	self.coming_from_start = coming_from_start
	yield_animation = false
	$go_back.set_custom_text(game.lang.GAME_OVER_PLAY_ROULETTE)
	$clickable_space.hide()

func open():
	open_anim = "open_instructions"
	.open()


func close():
	close_anim = "close_game_instructions"
	animation.play(close_anim)
	yield(animation, "animation_finished")
	if coming_from_start:
		game.event_layer.get_or_start("tutorial").post("1")
	hide()
	emit_signal("waiting4removal")
	for hboard in get_tree().get_nodes_in_group("hboards"):
		hboard.externally_stopped = true
	for hboard in get_tree().get_nodes_in_group("hboards"):
		if not hboard.ready2delete:
			yield(hboard, "ready_to_delete")
	queue_free()


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
	game.sounds.play_audio("click")
	current -= 1
	if current == 1 and coming_from_start:
		$go_back.click_me_stop()
	do_move()


func _on_next_pressed():
	if current + 1 > total:
		return
	game.sounds.play_audio("click")
	current += 1
	if current == 2 and coming_from_start:
		$go_back.click_me()
	do_move()

func hide_goback():
	if coming_from_start:
		$go_back.disappear()


func _on_tween_tween_completed(object, key):
	$"/root".set_disable_input(false)
