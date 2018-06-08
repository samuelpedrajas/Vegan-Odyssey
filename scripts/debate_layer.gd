extends CanvasLayer

onready var dialog = $"../dialog_layer"
onready var message1 = dialog.get_node("message1")
onready var message2 = dialog.get_node("message2")

onready var laura = $"girls/laura"
onready var lucy = $"girls/lucy"

var current = 0


func init(i):
	$animation.stop()
	laura.set_frame(0)
	laura.play("default")
	lucy.set_frame(0)
	lucy.play("default")

	current = i

	var debate = game.cfg.EXCUSES[i - 1].debate
	message1.set_text(debate.question)
	message2.set_text(debate.answer)
	message1.set_percent_visible(1)
	message2.set_percent_visible(1)


func update_text(i):
	if current == i:
		init(i)
		return

	current = i
	var debate = game.cfg.EXCUSES[i - 1].debate

	message1.set_percent_visible(0)
	message2.set_percent_visible(0)
	message1.set_text(debate.question)
	message2.set_text(debate.answer)

	$animation.play("debate")
