extends Control


var index = 0


func setup(i, excuse_text):
	index = i
	$text.set_text(excuse_text)
	if i == cfg.EXCUSES.size():
		$bar.hide()


func _on_excuse_pressed():
	get_parent().get_parent().clicked_excuse = index


func set_lock():
	$text.visible = false
	$unlock.visible = false
	$lock.visible = true


func set_actual():
	$current.visible = true
