extends ColorRect


var loading = false


func set_loading():
	print("LOADING!!!")
	if not loading:
		loading = true
		$anim.play("set_loading")


func _on_anim_animation_finished(anim_name):
	if anim_name == "set_loading" and loading:
		$anim.play("loading")


func start_loading():
	if loading:
		show()
		$text.set_text(game.lang.LOADING)
		if not game.popup_layer.popup_stack.empty():
			game.popup_layer.popup_stack.back().hide()
			game.popup_layer.get_node("effects/blur").hide()


func unset_loading():
	if loading:
		$anim.stop()
		loading = false
		modulate.a = 0
		$text.self_modulate.a = 1
		hide()

	if not game.popup_layer.popup_stack.empty():
		game.popup_layer.popup_stack.back().show()
		game.popup_layer.get_node("effects/blur").show()
	else:
		get_tree().set_pause(false)
