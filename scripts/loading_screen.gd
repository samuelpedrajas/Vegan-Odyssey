extends Control

func _ready():
	game_loader.goto_stage($progress_bar)


func _on_timer_timeout():
	if OS.get_name() == "iOS":
		game_loader.check_events()
