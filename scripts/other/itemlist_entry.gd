extends Control


export(int) var token_index

onready var grandpa = get_parent().get_parent()
# onready var game = get_node("/root/game")


func _ready():
	var cfg = _get_cfg()
	# update excuse text
	var excuse = cfg.EXCUSES[token_index - 1]
	$text.set_text(excuse.text)
	if token_index == cfg.EXCUSES.size():
		$bar.hide()


func _get_cfg():
	return game.cfg


func set_lock():
	$text.visible = false
	$unlock.visible = false
	$lock.visible = true
	$excuse.hide()
	$debate.hide()
	$excuse_disabled.show()
	$debate_disabled.show()


func set_actual():
	$text.modulate = Color(220.0 / 255, 200.0 / 255, 12.0 / 255, 1)


func _on_debate_released():
	yield(get_tree(), "idle_frame")

	# the length is ok and last clicked token is this
	if grandpa.can_click() and grandpa.token_clicked == self:
		grandpa.tap_start_position = null
		grandpa.tap_end_position = null
		game.sounds.play_audio("click")
		game.popup_layer.open("excuse_drawing", token_index)


func _on_debate_pressed():
	grandpa.token_clicked = self
