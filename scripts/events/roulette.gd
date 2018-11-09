extends Control

const e = 2.718282

var priority = 6
var back_button = false

var still_rolling = true
var roulette_ready = false
var bouncing = false
var prev_closest = null

var complete_round = 2.0 * PI
var speed = 1.8 * PI  # rotation per second
var bounce_amplitude = complete_round / 16.0
var half_bounce_amplitude = bounce_amplitude / 2.0
var acc_delta = half_bounce_amplitude / speed

var final_rot = null
var final_rots = [
	{ "rot": half_bounce_amplitude * 1.0, "amount": 2 },
	{ "rot": half_bounce_amplitude * 3.0, "amount": 2 },
	{ "rot": half_bounce_amplitude * 5.0, "amount": 3 },
	{ "rot": half_bounce_amplitude * 7.0, "amount": 3 },
	{ "rot": half_bounce_amplitude * 9.0, "amount": 1 },
	{ "rot": half_bounce_amplitude * 11.0, "amount": 1 },
	{ "rot": half_bounce_amplitude * 13.0, "amount": 3 },
	{ "rot": half_bounce_amplitude * 15.0, "amount": 3 },
	{ "rot": half_bounce_amplitude * 17.0, "amount": 2 },
	{ "rot": half_bounce_amplitude * 19.0, "amount": 2 },
	{ "rot": half_bounce_amplitude * 21.0, "amount": 1 },
	{ "rot": half_bounce_amplitude * 23.0, "amount": 1 },
	{ "rot": half_bounce_amplitude * 25.0, "amount": 0 },
	{ "rot": half_bounce_amplitude * 27.0, "amount": 0 },
	{ "rot": half_bounce_amplitude * 29.0, "amount": 1 },
	{ "rot": half_bounce_amplitude * 31.0, "amount": 4 }
]

var broccolis_emited = false

onready var roulette_texture = $roulette/roulette_texture
onready var arrow_texture = $roulette/arrow_texture


func _get_smallest_distance(target, source):
	var a = target - source
	return fmod(a + PI, complete_round) - PI


func _get_closest_rot(rot):
	var closest = null
	var closest_dist = complete_round

	for _final_rot in final_rots:
		var dist = abs(_get_smallest_distance(_final_rot.rot, rot))
		if dist < closest_dist:
			closest_dist = dist
			closest = _final_rot

	return closest


func _update_arrow(rot, closest, amp):
	var new_rot = null
	var roll_offset = half_bounce_amplitude
	var left_pole = closest - half_bounce_amplitude
	var right_pole = closest + half_bounce_amplitude

	if rot < closest:
		if rot > left_pole + roll_offset:
			new_rot = 0.0
		else:
			var mult = 1.0 - abs(_get_smallest_distance(rot, left_pole)) / roll_offset
			new_rot = mult * amp

	else:
		if rot < right_pole - roll_offset:
			new_rot = 0.0
		else:
			var mult = abs(_get_smallest_distance(rot, right_pole - roll_offset)) / roll_offset
			new_rot = mult * amp

	arrow_texture.set_rotation(
		arrow_texture.get_rotation() * 0.75 + new_rot * 0.25
	)


func _process(delta):
	var prev_rot = roulette_texture.get_rotation()

	acc_delta += delta

	if not bouncing:
		if acc_delta > complete_round / speed:
			acc_delta = fmod(acc_delta, complete_round / speed)
			prev_rot = fmod(prev_rot, complete_round)

		var rot = acc_delta * speed
		roulette_texture.set_rotation(rot)

		var closest = _get_closest_rot(rot).rot
		if prev_closest != closest:
			game.sounds.play_audio("tick")
			pass
		prev_closest = closest

		var amp = PI * _get_smallest_distance(prev_rot, rot) / half_bounce_amplitude
		_update_arrow(rot, closest, amp)

	elif still_rolling:
		var rot = roulette_texture.get_rotation()
		if final_rot == null:
			acc_delta = 0.0
			final_rot = _get_closest_rot(rot)

		var mult = pow(e, -acc_delta * 2.0) * sin(complete_round * acc_delta * 2.0)
		var offset = mult * bounce_amplitude
		rot = final_rot.rot - offset
		roulette_texture.set_rotation(rot)

		var amp = PI * _get_smallest_distance(prev_rot, rot) / half_bounce_amplitude
		_update_arrow(rot, final_rot.rot, amp)

		if acc_delta > 3.0:
			if final_rot.amount == 0:
				acc_delta = abs(roulette_texture.get_rotation() / speed)
				roulette_ready = true
				bouncing = false
				final_rot = null
				$"/root".set_disable_input(false)
				$stop.set_disabled(false)
			else:
				still_rolling = false
				set_process(false)
				game.event_layer.stop("roulette")
				game.go_back_manually_disabled = false

				game.save_game()
		elif acc_delta > 2.0 and not broccolis_emited and final_rot.amount > 0:
			broccolis_emited = true
			game.secretly_set_broccolis(game.broccolis + final_rot.amount)
			game.effects_layer.play_rewarded_effect(final_rot.amount)
			game.hud_layer.glow_broccoli()


func start():
	game.go_back_manually_disabled = true
	$anim.play("appear")


func stop():
	$anim.play("disappear")


func _on_stop_pressed():
	if roulette_ready:
		roulette_ready = false
		game.sounds.play_audio("click")
		bouncing = true
		$"/root".set_disable_input(true)
		$stop.set_disabled(true)


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		roulette_ready = true
		$"/root".set_disable_input(false)
	elif anim_name == "disappear":
		queue_free()
