extends Node2D

var subpopup = preload("res://scenes/popups/excuse_subpopup.tscn")
var vbox

var init_excuse
var actual_excuse
var popups = {}

var starting_position
var accumulated_time = 0.0
var anim_time = 0.2


var dest

var blocked = true
var rect_limit_y
var w_width


func setup(list_entry):
	rect_limit_y = get_viewport().get_visible_rect().size.y
	vbox = list_entry.get_parent()
	init_excuse = list_entry.token_index
	actual_excuse = list_entry.token_index
	dest = Vector2(540, position.y)
	starting_position = position
	w_width = get_viewport().get_visible_rect().size.x
	w_width += (1.0 - game.resizer.s) * w_width

	for i in range(-1, 2):
		var popup = subpopup.instance()
		var n = fposmod(actual_excuse + i - 1, 9) + 1

		popup.setup(n, (n - init_excuse) * Vector2(w_width, position.y), rect_limit_y)
		popups[n] = popup

		if n != actual_excuse:
			popup.hide()
		add_child(popup)

	update_entry(actual_excuse)


func update_entry(n):
	if not game.seen_excuses[n - 1].picture_seen:
		var entry = vbox.get_node(str(n))
		game.seen_excuses[n - 1].picture_seen = true
		entry.update_new_labels()
		game.save_game()


func get_current_entry():
	return vbox.get_node(str(actual_excuse))


func show_all():
	for popup in popups.values():
		popup.show()


func goto(n, sound=false):
	if not blocked or n > game.highest_max:
		return

	starting_position = position
	accumulated_time = 0.0
	blocked = false

	var direction = (n - actual_excuse)
	if actual_excuse + direction < 1 or actual_excuse + direction > 9:
		return

	if sound:
		game.sounds.play_audio("click")

	var from_idx = fposmod(actual_excuse - direction - 1, 9) + 1
	var to_idx = fposmod(n + direction - 1, 9) + 1

	dest = Vector2((fposmod(n - 1, 9) - init_excuse + 1)  * -w_width + 540, position.y)
	actual_excuse = fposmod(n - 1, 9) + 1
	update_entry(actual_excuse)

	var popup = popups[from_idx]
	popups.erase(from_idx)
	popups[to_idx] = popup
	popup.setup(to_idx, (to_idx - init_excuse) * Vector2(w_width, position.y), rect_limit_y)


func goto_next(sound=false):
	goto(actual_excuse + 1, sound)


func goto_prev(sound=false):
	goto(actual_excuse - 1, sound)


func swift(first, second):
	var d =  second - first
	position.x = (position.x + dest.x + d.x) / 2
	starting_position = position


func check_change():
	var distance = position.x - dest.x
	if distance > 60:
		goto_prev()
	elif distance < -60:
		goto_next()


func _process(delta):
	if blocked:
		return

	accumulated_time += delta
	if abs(position.x - dest.x) < 1:
		position = dest
		accumulated_time = 0.0
		blocked = true
	else:
		position = starting_position.linear_interpolate(dest, min(1.0, accumulated_time / anim_time))
