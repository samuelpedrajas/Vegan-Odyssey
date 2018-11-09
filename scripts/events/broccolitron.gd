extends Control

var priority = 6
var back_button = false

var broccolitron_ready = false

onready var slot1 = $broccolitron/texture/slots/slot1
onready var slot2 = $broccolitron/texture/slots/slot2
onready var slot3 = $broccolitron/texture/slots/slot3
onready var slots = [slot1, slot2, slot3]

var results = []
var current_slot = 0


func _ready():
	randomize()


func start():
	game.go_back_manually_disabled = true
	$anim.play("appear")


func stop():
	$anim.play("disappear")


func _get_broccoli_amount():
	var smallest = 3
	for result in results:
		smallest = min(result, smallest)
	return smallest


func get_shuffled(l):
	var aux_list = []
	for elem in l:
		aux_list.append(elem)

	var shuffled_list = []
	while not aux_list.empty():
		var i = randi() % len(aux_list)
		shuffled_list.append(aux_list[i])
		aux_list.remove(i)

	return shuffled_list


func start_rolling():
	for slot in get_shuffled(slots):
		$timer.start()
		yield($timer, "timeout")
		slot.start()

	$timer.start()
	yield($timer, "timeout")
	broccolitron_ready = true
	$"/root".set_disable_input(false)
	$stop/anim.play("appear")


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":	
		start_rolling()
	elif anim_name == "disappear":
		queue_free()


func _on_btn_pressed():
	if broccolitron_ready:
		game.sounds.play_audio("click")
		var slot = slots[current_slot]
		var res = slot.stop()
		results.append(res)
		current_slot += 1

		if current_slot > 2:
			$"/root".set_disable_input(true)
			$stop.set_disabled(true)
			$stop/anim.play("disappear")
			broccolitron_ready = false
			yield(slot, "slot_stopped")
			var reward = _get_broccoli_amount()
			game.event_layer.stop("broccolitron")
			game.go_back_manually_disabled = false
			game.secretly_set_broccolis(game.broccolis + reward)
			game.effects_layer.play_rewarded_effect(reward)
			game.save_game()
