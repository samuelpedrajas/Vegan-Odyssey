extends Control

var priority = 9
var back_button = false

var broccolitron_ready = false

onready var slot1 = $broccolitron/texture/slots/slot1
onready var slot2 = $broccolitron/texture/slots/slot2
onready var slot3 = $broccolitron/texture/slots/slot3


func start():
	$anim.play("appear")


func stop():
	$anim.play("disappear")


func _on_stop_pressed():
	if broccolitron_ready:
		game.sounds.play_audio("click")
		$"/root".set_disable_input(true)


func start_rolling():
	for slot in [slot1, slot2, slot3]:
		$timer.start()
		yield($timer, "timeout")
		slot.start()


func _on_anim_animation_finished(anim_name):
	if anim_name == "appear":
		#broccolitron_ready = true
		#$"/root".set_disable_input(false)
		start_rolling()
	elif anim_name == "disappear":
		queue_free()
