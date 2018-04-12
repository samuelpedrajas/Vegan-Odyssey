extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	animation.play("close")
	is_closing = true


func _ready():
	set_position(cfg.RESET_PROGRESS_WINDOW_POS)
	animation.play("open")


func _on_animation_finished(anim_name):
	if is_closing:
		queue_free()


func _on_ok_button_pressed():
	g.reset_progress()
	g.play_audio("click")


func _on_cancel_button_pressed():
	g.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()

