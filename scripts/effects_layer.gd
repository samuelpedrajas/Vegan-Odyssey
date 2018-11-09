extends CanvasLayer

var plus1 = preload("res://scenes/other/plus1.tscn")


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
		else:
			game.hud_layer.set_broccoli_amount(game.broccolis)

		var node = plus1.instance()
		$rewarded_animation/c.add_child(node)

		game.sounds.play_audio("bubble")
		set_process(true)
		timer.start()
		yield(timer, "timeout")


var anim_time = 0.2
var acc_time = 0.0
onready var broccoli_btn = $"/root/stage/hud_layer/hud/lower_buttons/broccoli"

func _process(delta):
	if acc_time >= anim_time:
		broccoli_btn.set_scale(Vector2(game.resizer.s, game.resizer.s))
		acc_time = 0.0
		set_process(false)
	elif acc_time < anim_time / 2.0:
		var s2 = Vector2(game.resizer.s, game.resizer.s)
		broccoli_btn.set_scale(
			s2 + s2 * 0.1 * (acc_time / (anim_time / 2.0))
		)
	else:
		var s2 = Vector2(game.resizer.s, game.resizer.s)
		broccoli_btn.set_scale(
			s2 * 1.1 - s2 * 0.1 * ((acc_time - anim_time / 2.0) / (anim_time / 2.0))
		)
	acc_time += delta


func set_loading():
	$"/root/stage/transition_layer/loading".set_loading()


func unset_loading():
	$"/root/stage/transition_layer/loading".unset_loading()


func play_new_record():
	$new_record.show()
	$new_record/anim.play("blinking")
	game.sounds.play_audio("new_record")


func stop_new_record():
	$new_record/anim.stop()
	$new_record.hide()
