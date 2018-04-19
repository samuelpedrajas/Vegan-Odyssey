extends Control


onready var actual_sprite = preload("res://images/popups/actual_excuse.png")
var index = 0


func setup(i, excuse_text):
	index = i
	$"text".set_text(excuse_text)


func _on_excuse_pressed():
	get_parent().get_parent().clicked_excuse = index


func set_lock():
	$"excuse".visible = false
	$"text".visible = false
	$"lock".visible = true


func set_actual():
	$"actual".visible = true
	$"excuse".set_texture(actual_sprite)

