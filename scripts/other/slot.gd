extends Control

var speed = 100.0
var gravity = 1

var current_slot = 0
var current_broccoli_amount = 1
var center_positions = [0.0, -318.0, -632.0]

onready var slots = [$slot1, $slot2]


signal slot_stopped


func _ready():
	set_process(false)


func _process(delta):
	var main_slot = slots[current_slot]
	var other_slot = slots[(current_slot + 1) % 2]
	var other_offset = Vector2(0, 953.0)

	if current_broccoli_amount == 3:
		other_offset *= -1.0

	other_slot.set_position(main_slot.get_position() - other_offset)


func start():
	game.sounds.play_audio("cling")
	$anim.play("roll")


func stop():
	$anim.stop()
	var main_slot = slots[current_slot]
	var final_position = Vector2(0.0, center_positions[current_broccoli_amount - 1])
	var start_position = Vector2(0.0, main_slot.get_position().y)

	$tween.interpolate_method(
		main_slot, "set_position", start_position, final_position,
		1.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.0
	)

	$tween.start()
	set_process(true)
	return current_broccoli_amount


func set_slot1():
	current_slot = 0
	current_broccoli_amount = 1


func set_slot2():
	current_slot = 1
	current_broccoli_amount = 1

func set_two():
	current_broccoli_amount = 2


func set_three():
	current_broccoli_amount = 3


func _on_tween_tween_completed(object, key):
	set_process(false)
	emit_signal("slot_stopped")
	print("Slot stopped")
