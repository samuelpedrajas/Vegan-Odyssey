extends Control

const e = 2.718282

var priority = 9
var back_button = false

var still_rolling = true
var roulette_ready = false
var bouncing = false
var prev_closest = null

var complete_round = 2.0 * PI
var speed = 1.8 * PI  # rotation per second
var bounce_amplitude = complete_round / 16.0
var acc_delta = (bounce_amplitude / 2.0) / speed
var arrow_amplitude = 20.0

var bounce_offset = 0.0
var final_rot = null
var final_rots = [
	{ "rot": 0.19635, "amount": 2 },
	{ "rot": 0.589049, "amount": 2 },
	{ "rot": 0.981748, "amount": 3 },
	{ "rot": 1.374447, "amount": 3 },
	{ "rot": 1.767146, "amount": 2 },
	{ "rot": 2.159845, "amount": 2 },
	{ "rot": 2.552544, "amount": 4 },
	{ "rot": 2.945243, "amount": 4 },
	{ "rot": 3.337942, "amount": 1 },
	{ "rot": 3.730641, "amount": 1 },
	{ "rot": 4.12334, "amount": 5 },
	{ "rot": 4.516039, "amount": 5 },
	{ "rot": 4.908739, "amount": 2 },
	{ "rot": 5.301438, "amount": 2 },
	{ "rot": 5.694137, "amount": 3 },
	{ "rot": 6.086836, "amount": 3 }
]

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
	var roll_offset = bounce_amplitude / 2.0
	var left_pole = closest - bounce_amplitude / 2.0
	var right_pole = closest + bounce_amplitude / 2.0

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
			acc_delta -= complete_round / speed
			prev_rot -= complete_round

		var rot = acc_delta * speed
		roulette_texture.set_rotation(rot)

		var closest = _get_closest_rot(rot).rot
		if prev_closest != closest:
			game.sounds.play_audio("tick")
		prev_closest = closest

		_update_arrow(rot, closest, _get_smallest_distance(prev_rot, rot) * arrow_amplitude)

	elif still_rolling:
		var rot = roulette_texture.get_rotation()
		if final_rot == null:
			acc_delta = 0.0
			final_rot = _get_closest_rot(rot)

		var mult = pow(e, -acc_delta * 2.0) * sin(complete_round * acc_delta * 2.0)
		var offset = mult * bounce_amplitude
		rot = final_rot.rot - offset
		roulette_texture.set_rotation(rot)

		_update_arrow(rot, final_rot.rot, _get_smallest_distance(prev_rot, rot) * arrow_amplitude)

		if acc_delta > 2.2:
			still_rolling = false
			set_process(false)
			game.event_layer.stop("roulette")
			game.secretly_set_broccolis(game.broccolis + final_rot.amount)
			game.effects_layer.play_rewarded_effect(final_rot.amount)
			game.save_game()


func start():
	$anim.play("appear")


func stop():
	$anim.play("disappear")


func _on_stop_pressed():
	if roulette_ready:
		game.sounds.play_audio("click")
		bouncing = true
		$"/root".set_disable_input(true)


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		roulette_ready = true
		$"/root".set_disable_input(false)
	elif anim_name == "disappear":
		queue_free()
