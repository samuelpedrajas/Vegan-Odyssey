extends Node2D


var priority = 5
var back_button = false

var step = 0

var ad_to_show = null


func start():
	$animation.play("flying")


func stop():
	queue_free()


func quack():
	game.sounds.play_audio("quack")


func _on_click_area_gui_input(event):
	if event.is_action_pressed("click"):
		if ad_to_show == null:
			# set how much broccoli this girl will offer
			ad_to_show = admob.get_rewarded_ad_info()
		game.popup_layer.open("rewarded_video_confirmation", self)

func _on_animation_animation_finished(anim_name):
	game.event_layer.stop("broccoli_duck")


func _on_broccoli_duck_frame_changed():
	if ($broccoli_duck.get_frame() + 2) % 8 == 0:
		game.sounds.play_audio("wing_flap")
