extends CanvasLayer


signal popup_closed


# POPUP MANAGMENT
var popup_stack = []
onready var popup_scene_dict = {
	"settings": preload("res://scenes/popups/settings.tscn"),
	"exit_confirmation": preload("res://scenes/popups/exit_confirmation.tscn"),
	"reset_board_confirmation": preload("res://scenes/popups/reset_board_confirmation.tscn"),
	"reset_progress_confirmation": preload("res://scenes/popups/reset_progress_confirmation.tscn"),
	"excuse_book": preload("res://scenes/popups/excuse_book.tscn"),
	"excuse_drawing": preload("res://scenes/popups/excuse_drawing.tscn"),
	"rewarded_video_confirmation": preload("res://scenes/popups/rewarded_video_confirmation.tscn"),
	"generic_popup": preload("res://scenes/popups/generic_popup.tscn"),
	"offline": preload("res://scenes/popups/offline.tscn"),
	"game_over": preload("res://scenes/popups/game_over.tscn"),
	"debate_screen": preload("res://scenes/popups/debate_screen.tscn"),
	"win": preload("res://scenes/popups/win.tscn"),
	"error9": preload("res://scenes/popups/error9.tscn"),
	"not_eea": preload("res://scenes/popups/not_eea.tscn"),
	"purchase": preload("res://scenes/popups/purchase.tscn"),
	"purchase_instructions": preload("res://scenes/popups/purchase_instructions.tscn"),
	"no_more_ads": preload("res://scenes/popups/no_more_ads.tscn"),
	"duck_popup": preload("res://scenes/popups/duck_popup.tscn"),
	"records": preload("res://scenes/popups/records.tscn"),
	"game_instructions": preload("res://scenes/popups/game_instructions.tscn"),
	"updates": preload("res://scenes/popups/updates.tscn")
}


func open(name, params=null):
	# disallow input until the window is opened
	$"/root".set_disable_input(true)

	if not popup_exists(name):
		var popup = popup_scene_dict[name].instance()
		# pause everything
		if not popup_stack.empty():
			popup_stack.back().set_pause_mode(Node2D.PAUSE_MODE_STOP)
			if not popup.keep_previous:
				popup_stack.back().hide()
		else:
			get_tree().set_pause(true)

		if popup.show_blur:
			show_blur()

		# add popup
		$popups.add_child(popup)
		popup_stack.append(popup)
		popup.set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
		if params != null:
			popup.setup(params)

		# multiscreen
		popup.rescale(game.resizer.s)
		popup.open()

		if popup.yield_animation:
			yield(popup.animation, "animation_finished")
			if not popup.keep_input_disabled:
				$"/root".set_disable_input(false)
	else:
		$"/root".set_disable_input(false)


func show_blur():
	$"effects/blur".show()


func popup_exists(name):
	for popup in popup_stack:
		if popup.get_name() == name:
			return true
	return false


func close(keep_input_disabled=false, keep_tree_paused=false):
	# disallow input until the window is closed
	$"/root".set_disable_input(true)

	# get popup to close at the end
	var popup_to_close = null
	if not popup_stack.empty():
		popup_to_close = popup_stack.back()
		popup_stack.pop_back()

	if popup_stack.empty():
		$"effects/blur".hide()
		if not keep_tree_paused:
			get_tree().set_pause(false)
	else:
		var popup = popup_stack.back()
		popup.set_pause_mode(Node2D.PAUSE_MODE_PROCESS)
		if not popup.is_visible():
			popup.show()

	# this is done in the end for smoother animation
	if popup_to_close != null:
		popup_to_close.close()
		if popup_to_close.wait_until_tree_exited:
			yield(popup_to_close, "tree_exited")
		else:
			yield(popup_to_close, "waiting4removal")

	if not keep_input_disabled:
		$"/root".set_disable_input(false)

	emit_signal("popup_closed")


func close_all():
	$"effects/blur".hide()
	while !popup_stack.empty():
		var popup = popup_stack.pop_back()
		popup.queue_free()
	get_tree().set_pause(false)


func closeable():
	return not popup_stack.empty() and popup_stack.back().back_button
