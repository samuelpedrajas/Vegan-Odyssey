extends Node2D


onready var animation = get_node("animation")


func close():
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	set_position(cfg.EXIT_WINDOW_POS)
	animation.play("open")


func _on_ok_button_pressed():
	g.save_game()
	g.game.sounds.play_audio("click")
	get_tree().quit()


func _on_cancel_button_pressed():
	g.game.sounds.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()

