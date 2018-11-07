extends Control

var priority = 9
var back_button = false

var broccolitron_ready = false

onready var slot1 = $broccolitron/texture/slots/slot1
onready var slot2 = $broccolitron/texture/slots/slot2
onready var slot3 = $broccolitron/texture/slots/slot3
onready var slots = [slot1, slot2, slot3]

var results = []
var current_slot = 0


func start():
	$anim.play("appear")


func stop():
	$anim.play("disappear")


func _get_broccoli_amount():
	var smallest = 3
	for result in results:
		smallest = min(result, smallest)
	return smallest


func _on_stop_pressed():
	if broccolitron_ready:
		game.sounds.play_audio("click")
		var slot = slots[current_slot]
		var res = slot.stop()
		results.append(res)
		current_slot += 1

		if current_slot > 2:
			broccolitron_ready = true
			yield(slot, "slot_stopped")
			var reward = _get_broccoli_amount()
			game.event_layer.stop("broccolitron")
			game.secretly_set_broccolis(game.broccolis + reward)
			game.effects_layer.play_rewarded_effect(reward)
			game.save_game()


func start_rolling():
	for slot in slots:
		$timer.start()
		yield($timer, "timeout")
		slot.start()

	$timer.start()
	yield($timer, "timeout")
	broccolitron_ready = true
	$"/root".set_disable_input(false)


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":	
		start_rolling()
	elif anim_name == "disappear":
		queue_free()
