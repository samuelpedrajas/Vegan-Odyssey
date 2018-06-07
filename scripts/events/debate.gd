extends Node2D

onready var dialog = $dialog
onready var message1 = $"dialog/message1"
onready var message2 = $"dialog/message2"


func _ready():
	dialog.hide()
	remove_child(dialog)
	$"/root/stage/dialog_layer".add_child(dialog)
	dialog.show()

	if game.current_max <= 1:
		return
	var debate = game.cfg.EXCUSES[game.current_max - 2].debate
	message1.set_text(debate.question)
	message2.set_text(debate.answer)


func update_text(i):
	if i <= 1:
		message1.set_text("")
		message2.set_text("")
		return
	var debate = game.cfg.EXCUSES[i - 2].debate
	message1.set_text(debate.question)
	message2.set_text(debate.answer)
