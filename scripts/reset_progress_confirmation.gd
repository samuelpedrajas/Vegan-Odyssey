extends Node2D


onready var animation = get_node("animation")

var is_closing = false


func close():
	animation.play("close")
	is_closing = true


func _ready():
	set_position(cfg.RESET_PROGRESS_WINDOW_POS)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	animation.play("open")


func _on_animation_finished(anim_name):
	if is_closing:
		queue_free()


func _on_ok_button_pressed():
	var dir = Directory.new()
	if dir.file_exists(cfg.SAVE_GAME_PATH):
		dir.remove(cfg.SAVE_GAME_PATH)
	g.game.highest_max = 1
	g.game.highest_score = 0
	g.game.broccolis = 0
	g.game.current_score = 0
	g.play_audio("click")
	g.close_popups()
	g.transition.restart_game()


func _on_cancel_button_pressed():
	g.play_audio("click")
	g.close_popup()


func _on_clickable_space_pressed():
	g.close_popup()

