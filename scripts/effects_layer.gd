extends CanvasLayer


func _ready():
	set_process(false)


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
		set_process(true)
		timer.start()
		yield(timer, "timeout")


var anim_time = 0.2
var acc_time = 0.0
var init_s = 1.0
onready var broccoli_btn = $"/root/stage/hud_layer/hud/lower_buttons/broccoli"

func _process(delta):
	if acc_time == 0.0:
		init_s = broccoli_btn.get_scale()
	elif acc_time >= anim_time:
		broccoli_btn.set_scale(init_s)
		acc_time = 0.0
		set_process(false)
	elif acc_time < anim_time / 2.0:
		broccoli_btn.set_scale(
			init_s + init_s * 0.1 * (acc_time / (anim_time / 2.0))
		)
	else:
		broccoli_btn.set_scale(
			init_s * 1.1 - init_s * 0.1 * ((acc_time - anim_time / 2.0) / (anim_time / 2.0))
		)
	acc_time += delta
