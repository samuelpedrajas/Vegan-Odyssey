extends CanvasLayer

onready var dialog = $"../dialog_layer"
onready var message1 = dialog.get_node("text/dialog/message1")
onready var message2 = dialog.get_node("text/dialog/message2")

onready var laura = $"girls/laura"
onready var lucy = $"girls/lucy"

var current = 0


func adjust_font_size():
	message2.get_font("font").set_size(42)
	var line_count = message2.get_line_count()
	var line_height = message2.get_line_height()
	var height = line_count * line_height
	var real_height = message2.get_size().y
	print(height, " - ", real_height)
	if real_height < height:
		var ratio = float(real_height) / float(height)
		var font_height = message2.get_font("font").get_size()
		message2.get_font("font").set_size(floor(font_height * ratio))

func init(i):
	$animation.stop()
	laura.set_frame(0)
	laura.play("default")
	lucy.set_frame(0)
	lucy.play("default")

	current = i

	var debate = game.lang.EXCUSES[i - 1].debate
	message1.set_text(debate.question)
	message2.set_text(debate.answer)
	adjust_font_size()
	message1.set_percent_visible(1)
	message2.set_percent_visible(1)


func update_text(i):
	if current == i:
		init(i)
		return
	elif i == cfg.GOAL:
		$animation.stop()
		message1.set_text("")
		message2.set_text("")
		return

	current = i
	var debate = game.lang.EXCUSES[i - 1].debate

	message1.set_percent_visible(0)
	message2.set_percent_visible(0)
	message1.set_text(debate.question)
	message2.set_text(debate.answer)
	adjust_font_size()
	$animation.play("debate")


func _on_debate_btn_pressed():
	if cfg.DEV_MODE and game.purchased:
		iap_helper.consume_unconsumed()
		game.purchased = false
	elif cfg.DEV_MODE:
		game.purchased = true
		iap_helper.emit_signal("purchase_success")

	if current > 0:
		game.sounds.play_audio("click")
		game.popup_layer.open("debate_screen", current)


func update_language():
	init(current)
