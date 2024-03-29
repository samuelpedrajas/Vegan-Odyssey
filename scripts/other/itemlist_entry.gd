extends Control


export(int) var token_index

onready var grandpa = get_parent().get_parent()
# onready var game = get_node("/root/game")


func _ready():
	var lang = game.lang
	# update excuse text
	var excuse = lang.EXCUSES[token_index - 1]
	$text.set_text(excuse.text)
	if token_index == lang.EXCUSES.size():
		$bar.hide()

	if game.highest_max >= token_index:
		update_new_labels()


func update_new_labels():
	var some_new = false
	if not game.seen_excuses[token_index - 1].picture_seen:
		$"new/new1".show()
		some_new = true
	else:
		$"new/new1".hide()

	if not game.seen_excuses[token_index - 1].debate_seen:
		$"new/new2".show()
		some_new = true
	else:
		$"new/new2".hide()

	if some_new:
		$"new/anim".play("blink")
	else:
		$"new/anim".stop()


func set_lock():
	$text.visible = false
	$unlock.visible = false
	$lock.visible = true
	$excuse.hide()
	$debate.hide()
	$excuse_disabled.show()
	$debate_disabled.show()


func _on_excuse_pressed():
	grandpa.token_clicked = self


func _on_excuse_released():
	yield(get_tree(), "idle_frame")

	# the length is ok and last clicked token is this
	if grandpa.can_click() and grandpa.token_clicked == self:
		grandpa.tap_start_position = null
		grandpa.tap_end_position = null
		grandpa.emit_signal("meme_clicked")
		game.sounds.play_audio("click")
		game.popup_layer.open("excuse_drawing", self)


func _on_debate_released():
	yield(get_tree(), "idle_frame")

	# the length is ok and last clicked token is this
	if grandpa.can_click() and grandpa.token_clicked == self:
		grandpa.tap_start_position = null
		grandpa.tap_end_position = null
		grandpa.emit_signal("refutation_clicked")
		game.sounds.play_audio("click")
		game.popup_layer.open("debate_screen", self)
