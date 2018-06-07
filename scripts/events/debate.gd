extends Node2D


func _ready():
	if game.current_max <= 1:
		return
	var debate = game.cfg.EXCUSES[game.current_max - 2].debate
	$message1.set_text(debate.question)
	$message2.set_text(debate.answer)


func update_text(i):
	if i <= 1:
		$message1.set_text("")
		$message2.set_text("")
		return
	var debate = game.cfg.EXCUSES[i - 2].debate
	$message1.set_text(debate.question)
	$message2.set_text(debate.answer)
