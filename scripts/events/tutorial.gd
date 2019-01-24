extends Control


var post_scene = preload("res://scenes/other/tutorial_post.tscn")
var post = null


var priority = 5
var back_button = false

var black_bg = null


func start():
	black_bg = $"/root/stage/hud_layer/hud/lower_buttons/black_bg"
	black_bg.connect("unpost_tutorial", self, "unpost")


func post(n):
	if post != null:
		unpost()
	black_bg.show_bg(n)
	game.seen_tutorial[n] = true
	if n == "1":
		$arrows.show()
		$arrows/anim.play("down")
	post = post_scene.instance()
	post.set_post(n)
	$post.add_child(post)
	post.animation.play("appear")


func check_finished():
	var msg1 = game.seen_tutorial["1"]
	var msg2 = game.seen_tutorial["2"]
	var msg3 = game.seen_tutorial["3"]
	#var msg4 = game.seen_tutorial["4"]
	return msg1 and msg2 and msg3# and msg4


func unpost():
	if post != null:
		var n = post.n_string
		post.close()
		post = null

		black_bg.unpost(n)
		$arrows.hide()
		$arrows/hand.set_position(Vector2(305, 24))

		if check_finished():
			$timer.start()
			yield($timer, "timeout")
			game.event_layer.stop("tutorial")


func stop():
	black_bg.hide()
	queue_free()


func rescale(s):
	$post.set_scale(Vector2(s, s))
	$arrows.set_scale(Vector2(s, s))
	var board = $"/root/stage/board_layer/board"
	$arrows.set_position(
		Vector2(
			get_viewport().get_visible_rect().size.x / 2.0 - $arrows.get_size().x / 2.0,
			board.get_position().y + board.get_size().y * s / 2.0 - $arrows.get_size().y / 2.0
		)
	)


func _on_anim_animation_finished(anim_name):
	if anim_name == "down":
		$"arrows/anim".play("right")
	else:
		$"arrows/anim".play("down")
