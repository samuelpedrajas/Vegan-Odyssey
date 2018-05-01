# tool
extends Control


export(int) var token_index = 1 setget set_token_index


# onready var game = get_node("/root/game")


func set_token_index(i):
	token_index = i
	var cfg = _get_cfg()
	# update excuse text
	var excuse = cfg.EXCUSES[i - 1]
	$text.set_text(excuse.text)
	if i == cfg.EXCUSES.size():
		$bar.hide()


func _get_cfg():
	if Engine.is_editor_hint():
		return load("res://scripts/cfg.gd").new()
	else:
		return game.cfg


func _on_excuse_pressed():
	get_parent().get_parent().clicked_excuse = token_index


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
