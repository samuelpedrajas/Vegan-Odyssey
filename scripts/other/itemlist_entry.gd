extends Control


var index = 0


func setup(i, excuse_text):
	index = i
	$text.set_text(excuse_text)
	if i == game.cfg.EXCUSES.size():
		$bar.hide()


func _on_excuse_pressed():
	get_parent().get_parent().clicked_excuse = index


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
