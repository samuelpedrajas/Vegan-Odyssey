extends "popup.gd"


var back_button = true
var keep_input_disabled = false
var keep_previous = false
var show_blur = true


func open():
	if game.records[0].time == null:
		$window/no_records.show()
	else:
		$window/table.show()
	open_anim = "open_records"
	.open()


func close():
	.close()


func rescale(s):
	$window.set_scale(Vector2(s, s))


func _on_go_back_pressed():
	game.sounds.play_audio("click")
	game.popup_layer.close()
