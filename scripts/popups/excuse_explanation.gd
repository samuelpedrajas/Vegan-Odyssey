extends Node2D


onready var animation = get_node("animation")


func close():
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	set_position(cfg.EXCUSE_WINDOW_POS)
	animation.play("open")


func setup(excuse_index):
	var image_node = get_node("window/excuse_image")
	var excuse_sprite = cfg.EXCUSES[excuse_index - 1]["book_sprite"]
	image_node.set_texture(excuse_sprite)


func _on_ok_button_pressed():
	g.game.sounds.play_audio("click")
	g.close_popup()


func _on_cancel_button_pressed():
	g.game.sounds.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()

