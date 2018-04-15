extends CanvasLayer


# POPUP MANAGMENT
var popup_stack = []
onready var popup_scene_dict = {
	"settings_menu": preload("res://scenes/popups/settings_menu.tscn"),
	"exit_confirmation": preload("res://scenes/popups/exit_confirmation.tscn"),
	"reset_confirmation": preload("res://scenes/popups/reset_confirmation.tscn"),
	"reset_progress_confirmation": preload("res://scenes/popups/reset_progress_confirmation.tscn"),
	"book": preload("res://scenes/popups/book.tscn"),
	"excuse_explanation": preload("res://scenes/popups/excuse_explanation.tscn")
}


func open(name):
	# disallow input until the window is opened
	get_tree().get_root().set_disable_input(true)

	if not name in popup_stack:
		# pause everything
		if not popup_stack.empty():
			popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_STOP)
		else:
			get_tree().set_pause(true)

		var popup = popup_scene_dict[name].instance()
		popup.set_z_index(popup_stack.size())
		add_child(popup)
		popup.open()
		popup_stack.append(popup)
		yield(popup.animation, "animation_finished")
		get_tree().get_root().set_disable_input(false)
		# TODO:  fix this, used in scroll_container.gd
		return popup

	get_tree().get_root().set_disable_input(false)


func close():
	# disallow input until the window is closed
	get_tree().get_root().set_disable_input(true)

	if not popup_stack.empty():
		var popup = popup_stack.back()
		popup_stack.pop_back()
		popup.close()
		yield(popup, "tree_exited")

	if popup_stack.empty():
		get_tree().set_pause(false)
	else:
		popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
	get_tree().get_root().set_disable_input(false)


func close_all():
	while !popup_stack.empty():
		var popup = popup_stack.pop_back()
		popup.queue_free()
		yield(popup, 'tree_exited')
	get_tree().set_pause(false)
