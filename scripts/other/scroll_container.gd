extends ScrollContainer


onready var ExcuseEntry = preload("res://scenes/other/itemlist_entry.tscn")

signal meme_clicked
signal refutation_clicked


func _ready():
	# add excuse entries
	var v_box = $"vbox_container"
	for i in range(1, game.lang.EXCUSES.size() + 1):
		var excuse_entry = v_box.get_node(str(i))
		if i > game.highest_max:
			excuse_entry.set_lock()
		elif i == game.current_max:
			excuse_entry.set_actual()

	# add vertical scroll bar
	var v_scroll = VScrollBar.new()
	v_scroll.modulate.a = 0  # weird pixels in lower-left corner otherwise
	v_box.add_child(v_scroll)


var tap_start_position
var tap_end_position
var token_clicked = null

func _gui_input(event):
	if event.is_action_pressed("click"):
		if tap_end_position != null:
			tap_end_position = null
		tap_start_position = event.position
	elif event.is_action_released("click"):
		if tap_start_position != null:
			tap_end_position = event.position


func can_click():
	var got_the_info = tap_start_position != null and tap_end_position != null
	if not got_the_info:
		return false

	var input_vector = tap_end_position - tap_start_position
	if input_vector.length() > cfg.SCROLL_THRESHOLD:
		return false

	return true
