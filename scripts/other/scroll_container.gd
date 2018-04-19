extends ScrollContainer


onready var ExcuseEntry = preload("res://scenes/other/itemlist_entry.tscn")
var tap_start_position
var tap_actual_position
var clicked_excuse = null


func _ready():
	# add excuse entries
	var v_box = $"vbox_container"
	for i in range(1, cfg.EXCUSES.size() + 1):
		var excuse = cfg.EXCUSES[i - 1]
		var excuse_entry = ExcuseEntry.instance()
		excuse_entry.setup(i, excuse["text"])
		v_box.add_child(excuse_entry)
		if i > game.highest_max:
			excuse_entry.set_lock()
		elif i == game.current_max:
			excuse_entry.set_actual()

	# add vertical scroll bar
	var v_scroll = VScrollBar.new()
	v_scroll.modulate.a = 0  # weird pixels in lower-left corner otherwise
	v_box.add_child(v_scroll)


func _gui_input(event):
	tap_actual_position = event.position
	if event.is_action_pressed("click"):
		# if clicked, save the position
		tap_start_position = event.position
	elif event.is_action_released("click") and _can_click():
		tap_start_position = null
		if clicked_excuse == null:
			clicked_excuse = null
			return
		game.sounds.play_audio("click")
		var excuse_popup = game.popup_layer.open("excuse_drawing", clicked_excuse)
		clicked_excuse = null


func _can_click():
	var got_the_info = tap_start_position != null and tap_actual_position != null
	if not got_the_info:
		return false

	var input_vector = tap_actual_position - tap_start_position
	if input_vector.length() > cfg.SCROLL_THRESHOLD:
		return false

	return true

