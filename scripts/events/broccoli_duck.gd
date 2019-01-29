extends Control


var priority = 4
var back_button = false

var step = 0

var ad_to_show = null

var unclicked = true

var grayed_out = false


func set_gray():
	if not grayed_out:
		grayed_out = true
		set_modulate(Color(0.4, 0.4, 0.4, 1))


func unset_gray():
	if grayed_out:
		grayed_out = false
		set_modulate(Color(1, 1, 1, 1))


func start():
	if game.event_layer.current_events.has("broccoli"):
		set_gray()
	$c/broccoli_duck.connect("duck_tapped", self, "on_duck_clicked")
	if not game.seen_duck:
		$c/broccoli_duck.set_hand()
	$animation.play("flying")


func stop():
	queue_free()


func quack():
	game.sounds.play_audio("quack")


func _is_clickable():
	var width = get_viewport().get_visible_rect().size.x
	return width - $"c/broccoli_duck".get_global_position().x > 130


func on_duck_clicked():
	if _is_clickable():
		if not game.seen_duck:
			game.seen_duck = true
			game.save_game()
			$c/broccoli_duck.hide_hand()
		# can't click if removing tokens
		if not grayed_out:
			if game.event_layer.current_events.has("tutorial"):
				game.event_layer.get_or_start("tutorial").unpost()
			unclicked = false
			game.duck_counter = 0
			if game.purchased:
				game.popup_layer.open("duck_popup", self)
			else:
				ad_to_show = admob.get_rewarded_ad_info()
				game.popup_layer.open("rewarded_video_confirmation", self)
		elif game.event_layer.current_events.has("broccoli"):
			game.event_layer.current_events["broccoli"].do_close()


func _on_animation_animation_finished(anim_name):
	if unclicked:
		game.duck_counter += 1
	game.event_layer.stop("broccoli_duck")


func rescale(s):
	set_scale(Vector2(s, s))
	set_position(
		Vector2(get_position().x, $"/root/stage/hud_layer/hud/bottom_border".get_position().y + 52.0)
	)
