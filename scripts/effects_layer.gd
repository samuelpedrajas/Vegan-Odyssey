extends CanvasLayer


func play_rewarded_effect(n):
	var real_n = game.broccolis
	var shadow_broccolis = game.broccolis - n
	var timer = $"rewarded_animation/timer"
	var initial_delay = 0.5
	var between_delay = 0.3
	timer.set_wait_time(initial_delay)
	timer.start()
	yield(timer, "timeout")

	timer.set_wait_time(between_delay)
	for i in range(1, n + 1):
		print("Playing rewarded effect")
		if real_n == game.broccolis:
			game.hud_layer.set_broccoli_amount(shadow_broccolis + i)
		var node = "c/plus" + str(i)
		var anim = $rewarded_animation.get_node(node + "/animation")
		game.sounds.play_audio("bubble")
		anim.play("plus1")
		timer.start()
		yield(timer, "timeout")
