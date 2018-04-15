extends Node2D


onready var animation = get_node("animation")
onready var scroll_container = get_node("window/scroll_container")


func close():
	animation.play("close")
	yield(animation, "animation_finished")
	queue_free()


func open():
	set_position(cfg.BOOK_WINDOW_POS)
	animation.play("open")


func _on_close_button_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()


func _on_clickable_space_pressed():
	game.popup_layer.close()

