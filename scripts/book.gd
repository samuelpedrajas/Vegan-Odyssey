extends Node2D


onready var animation = get_node("animation")
onready var scroll_container = get_node("window/scroll_container")

var is_closing = false


func close():
	g.save_game()
	animation.play("close")
	is_closing = true


func _ready():
	set_position(cfg.BOOK_WINDOW_POS)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	scroll_container.setup()
	animation.play("open")


func _on_animation_finished(anim_name):
	if is_closing:
		queue_free()


func _on_close_button_pressed():
	g.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()

