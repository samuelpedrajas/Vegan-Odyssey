extends CanvasLayer


# POPUP MANAGMENT
var popup_stack = []
onready var popup_scene_dict = {
	"settings": preload("res://scenes/popups/settings.tscn"),
	"exit_confirmation": preload("res://scenes/popups/exit_confirmation.tscn"),
	"reset_board_confirmation": preload("res://scenes/popups/reset_board_confirmation.tscn"),
	"reset_progress_confirmation": preload("res://scenes/popups/reset_progress_confirmation.tscn"),
	"excuse_book": preload("res://scenes/popups/excuse_book.tscn"),
	"excuse_drawing": preload("res://scenes/popups/excuse_drawing.tscn")
}


func open(name, params=null):
	# disallow input until the window is opened
	$"/root".set_disable_input(true)

	if not name in popup_stack:
		# pause everything
		if not popup_stack.empty():
			popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_STOP)
			popup_stack.back().hide()
		else:
			get_tree().set_pause(true)

		var popup = popup_scene_dict[name].instance()
		popup.set_z_index(popup_stack.size() * 2)  # trick to keep blur between

		# show blur
		$blur.set_z_index(popup.get_z_index() - 1)
		$blur.show()

		# add popup
		add_child(popup)
		popup_stack.append(popup)
		popup.set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
		if params:
			popup.open(params)
		else:
			popup.open()
		yield(popup.animation, "animation_finished")

	$"/root".set_disable_input(false)


func close():
	# disallow input until the window is closed
	$"/root".set_disable_input(true)

	# get popup to close at the end
	var popup_to_close = null
	if not popup_stack.empty():
		popup_to_close = popup_stack.back()
		popup_stack.pop_back()

	if popup_stack.empty():
		$blur.hide()
		get_tree().set_pause(false)
	else:
		var popup = popup_stack.back()
		$blur.set_z_index(popup.get_z_index() - 1)
		popup.set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
		popup.show()

	# this is done in the end for smoother animation
	if popup_to_close != null:
		popup_to_close.close()
		yield(popup_to_close, "tree_exited")

	$"/root".set_disable_input(false)


func close_all():
	$blur.hide()
	while !popup_stack.empty():
		var popup = popup_stack.pop_back()
		popup.queue_free()
	get_tree().set_pause(false)
