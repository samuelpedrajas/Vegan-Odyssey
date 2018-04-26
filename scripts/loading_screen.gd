extends Node2D

func _ready():
	game_loader.goto_scene("res://scenes/game.tscn", $progress_bar)
