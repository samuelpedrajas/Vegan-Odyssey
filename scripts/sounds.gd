extends AudioStreamPlayer


var library = {
	"click": preload("res://audio/click.wav"),
	"merge": preload("res://audio/merge.wav"),
	"bubble": preload("res://audio/bubble.wav"),
	"boom": preload("res://audio/boom.wav")
}


func _ready():
	game.settings.connect("sound_settings_changed", self, "update_settings")
	update_settings()


func play_audio(name):
	set_stream(library[name])
	play()


func update_settings():
	if not game.settings.sound_on:
		self.bus = "Silence"
	else:
		self.bus = "Master"
