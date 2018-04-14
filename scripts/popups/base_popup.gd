extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	if not is_closing:
		animation.play_backwards("open")
		is_closing = true