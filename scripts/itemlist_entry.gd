extends Control

onready var grandparent = get_parent().get_parent()
onready var lock = get_node("lock")
onready var actual = get_node("actual")
onready var button = get_node("excuse")
onready var actual_sprite = preload("res://images/actual_excuse.png")
var index = 0


func setup(i, excuse_text):
	index = i
	get_node("text").set_text(excuse_text)


func _on_excuse_pressed():
	grandparent.clicked_excuse = index


func set_lock():
	button.visible = !(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	get_node("text").visible = !(true)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	lock.visible = !(false)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review


func set_actual():
	actual.visible = !(false)  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	button.set_texture(actual_sprite)

