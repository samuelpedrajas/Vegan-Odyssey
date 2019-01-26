extends Node

var savegame = File.new()

# consent
var purchased = false
var personalized_ads = null  # null means unknown

# game scores
var highest_max = 1 setget _set_highest_max  # TODO: use cfg.MIN_HIGHEST_MAX
var current_max = 1 setget _set_current_max

# items
var broccolis = 3 setget _set_broccolis

# free broccoli
var error9_count = 0
var given_gifts = 0


# child nodes
var transition
var music
var sounds
var board_layer
var hud_layer
var event_layer
var popup_layer
var effects_layer
var debate_layer
var settings
var dying_tokens
var resizer
var save_game_timer

var duck_counter = 1
var revived = false
var seen_excuses = [
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false},
	{"picture_seen": false, "debate_seen": false}
]

var seen_intro = false
var seen_tutorial = {
	"1": false,
	"2": false,
	"3": false
#	"4": false
}
var seen_meme = false
var seen_refutation = false


var lang = null

var win = false

var savegame_data = null

var start_time = null
var used_broccolis = 0
var prev_game_stats = { "time": 0, "used_broccolis": 0 }
var records = [
	{ "time": null, "used_broccolis": null },
	{ "time": null, "used_broccolis": null },
	{ "time": null, "used_broccolis": null },
	{ "time": null, "used_broccolis": null },
	{ "time": null, "used_broccolis": null }
]

var release_number = 2


func _ready():
	# prevent quitting using back button
	get_tree().set_quit_on_go_back(false)
	$"/root".set_disable_input(true)


func setup():
	transition = $"/root/stage/transition"
	music = $"/root/stage/music"
	sounds = $"/root/stage/sounds"
	board_layer = $"/root/stage/board_layer"
	hud_layer = $"/root/stage/hud_layer"
	event_layer = $"/root/stage/event_layer"
	popup_layer = $"/root/stage/popup_layer"
	settings = $"/root/stage/settings"
	effects_layer = $"/root/stage/effects_layer"
	dying_tokens = $"/root/stage/dying_tokens"
	debate_layer = $"/root/stage/debate_layer"
	resizer = $"/root/stage/resizer"
	save_game_timer = $"/root/stage/save_game"


func recalculate_max():
	var tmp_max = 1
	for t in board_layer.matrix.values():
		if t.level > tmp_max:
			tmp_max = t.level
	self.current_max = tmp_max
	if win and current_max < 9:
		win = false


func update_scores(token_level):
	self.current_max = token_level if token_level > current_max else current_max
	self.highest_max = current_max if current_max > highest_max else highest_max


func restart_game(delete_progress=false):
	$"/root".set_disable_input(true)

	hud_layer.glow_stop()

	transition.play("close")
	# wait until screen is black
	yield(transition, 'animation_finished')

	# update amounts
	revived = false
	win = false
	self.current_max = 1

	start_time = null
	used_broccolis = 0
	prev_game_stats = { "time": 0, "used_broccolis": 0 }

	popup_layer.close_all()
	game.event_layer.stop("win")

	board_layer.reset()

	if delete_progress:
		music.stop()
		seen_intro = false
		seen_tutorial = {
			"1": false,
			"2": false,
			"3": false
			#"4": false
		}
		records = [
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null }
		]
		seen_meme = false
		seen_refutation = false
		self.highest_max = cfg.MIN_HIGHEST_MAX
		for excuse in seen_excuses:
			excuse.picture_seen = false
			excuse.debate_seen = false
		game.popup_layer.open("game_instructions", true)
		game.popup_layer.open("debate_screen", -2)
		debate_layer.init(1)
	else:
		board_layer.spawn_token(null, 1, false)

	save_game()

	transition.play("open")
	yield(transition, "animation_finished")
	event_layer.get_node("duck_ready").set_paused(false)
	if not delete_progress:
		$"/root".set_disable_input(false)


func reset_progress():
	restart_game(true)


### SAVE / LOAD FUNCTIONS ###

func start_game(coming_from_app_store):
	var updated = load_game()
	print("Purchase status: ", purchased)
	admob.start_ads()

	if coming_from_app_store != "no":
		if coming_from_app_store == "yes_success":
			popup_layer.open("generic_popup", {
				"title": lang.CONGRATULATIONS,
				"text": lang.PURCHASE_SUCCESSFUL
			})
		else:
			popup_layer.open("generic_popup", {
				"title": lang.OOPS_TITLE,
				"text": lang.PURCHASE_UNSUCCESSFUL
			})
		yield(popup_layer, "popup_closed")

	if not seen_intro:
		game.popup_layer.open("game_instructions", true)
		popup_layer.open("debate_screen", -2)
	else:
		$"/root/stage/popup_layer/effects/black".hide()

		# show post if needed
		if not seen_tutorial["1"]:
			event_layer.get_or_start("tutorial").post("1")
		if updated:
			popup_layer.open("updates")
		else:
			$"/root".set_disable_input(false)

	debate_layer.init(current_max)


func set_new_scene(scene_resource, translation_resource, iap_status):
	change_language('', translation_resource)
	# remove old scene
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() -1)
	current_scene.queue_free()

	# set new scene
	var new_scene = scene_resource.instance()
	new_scene.set_coming_from_app_store(iap_status)
	get_node("/root").add_child(new_scene)


func save_game_defaults(language, purchased):
	var game_status = {
		'records': to_json([
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null },
			{ "time": null, "used_broccolis": null }
		]),
		'prev_game_stats': to_json({
			"time": 0, "used_broccolis": 0
		}),
		'tutorial': to_json({
			"1": false,
			"2": false,
			"3": false
		}),
		'broccolis': 3,
		'highest_max': 1,
		'current_max': 1,
		'matrix': to_json({}),
		'settings': to_json({
			"music_on":true, "sound_on":true
		}),
		'revived': false,
		'win': false,
		'seen_excuses': to_json([
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false},
			{"picture_seen": false, "debate_seen": false}
		]),
		'lang': language,
		'seen_intro': false,
		'seen_meme': false,
		'seen_refutation': false,
		'personalized_ads': null,
		'purchased': purchased,
		'release_number': release_number
	}
	savegame_data = game_status
	save_game(game_status)


func save_game(game_status=null):
	if game_status == null:
		game_status = {
			'records': to_json(records),
			'prev_game_stats': to_json(get_current_record()),
			'tutorial': to_json(seen_tutorial),
			'broccolis': broccolis,
			'highest_max': highest_max,
			'current_max': current_max,
			'matrix': to_json(board_layer.save_info()),
			'settings': to_json(settings.save_info()),
			'revived': revived,
			'win': win,
			'seen_excuses': to_json(seen_excuses),
			'lang': lang.language,
			'seen_intro': seen_intro,
			'seen_meme': seen_meme,
			'seen_refutation': seen_refutation,
			'personalized_ads': personalized_ads,
			'purchased': purchased,
			'release_number': release_number
		}

	if OS.get_name() == "X11" or OS.get_name() == "OSX":
		savegame.open(
			cfg.SAVE_GAME_PATH, File.WRITE
		)
	else:
		print("Saving encrypted")
		savegame.open_encrypted_with_pass(
			cfg.SAVE_GAME_PATH, File.WRITE, "OS.get_unique_id()".md5_buffer()
		)

	savegame.store_line(to_json(game_status))
	savegame.close()


func get_or_default(info, key, default):
	if info.has(key):
		return info[key]
	return default


func get_or_default_json(info, key, default):
	if info.has(key):
		return parse_json(info[key])
	return default


func load_game():
	if savegame_data == null:
		return
	var info = savegame_data

	seen_tutorial = get_or_default_json(info, 'tutorial', seen_tutorial)
	seen_intro = get_or_default(info, 'seen_intro', seen_intro)

	highest_max = get_or_default(info, 'highest_max', highest_max)
	current_max = get_or_default(info, 'current_max', current_max)
	revived = get_or_default(info, 'revived', revived)
	self.broccolis = get_or_default(info, 'broccolis', broccolis)
	settings.load_info(get_or_default_json(info, 'settings', {
		'music_on': true,
		'sound_on': true
	}), seen_intro)
	board_layer.load_info(get_or_default_json(info, 'matrix', {}))
	win = get_or_default(info, 'win', win)
	seen_excuses = get_or_default_json(info, 'seen_excuses', seen_excuses)
	seen_meme = get_or_default(info, 'seen_meme', seen_meme)
	seen_refutation = get_or_default(info, 'seen_refutation', seen_refutation)
	personalized_ads = get_or_default(info, 'personalized_ads', personalized_ads)
	purchased = get_or_default(info, 'purchased', purchased)
	prev_game_stats = get_or_default_json(info, 'prev_game_stats', prev_game_stats)
	records = get_or_default_json(info, 'records', records)

	savegame.close()

	return release_number != get_or_default(info, 'release_number', -1)


func get_translation_file_path():
	if savegame.file_exists(cfg.SAVE_GAME_PATH):
		if OS.get_name() == "X11" or OS.get_name() == "OSX":
			savegame.open(
				cfg.SAVE_GAME_PATH, File.READ
			)
		else:
			print("Loading encrypted")
			savegame.open_encrypted_with_pass(
				cfg.SAVE_GAME_PATH, File.READ, "OS.get_unique_id()".md5_buffer()
			)
		savegame_data = parse_json(savegame.get_line())
		return cfg.TRANSLATIONS[savegame_data['lang']]
	else:
		var locale = OS.get_locale()
		if locale.substr(0, 2) in ['es', 'eu', 'ca', 'gl']:
			return cfg.TRANSLATIONS['es']
		else:
			return cfg.TRANSLATIONS['en']


### SETTERS ###


func _set_broccolis(v):
	broccolis = v
	hud_layer.set_broccoli_amount(v)


func _set_highest_max(v):
	if v == 2 and not seen_tutorial["2"]:
		event_layer.get_or_start("tutorial").post("2")
	highest_max = v


func _set_current_max(v):
	if current_max != v:
		debate_layer.update_text(v)
	current_max = v


func secretly_set_broccolis(amount):
	broccolis = amount


### WIN / LOSE ###


func get_current_record():
	if start_time == null:
		return prev_game_stats
	var elapsed_time = (OS.get_unix_time() - start_time)
	var record = {
		"time": elapsed_time + prev_game_stats.time,
		"used_broccolis": used_broccolis + prev_game_stats.used_broccolis
	}
	if record.time < 0:
		return { "time": 0, "used_broccolis": 0 }
	return record


func set_records():
	var new_record_pos = 0
	var new_record = get_current_record()
	if new_record.time == 0:
		return
	for record in records:
		if record.time == null or record.time > new_record.time:
			records.pop_back()
			records.insert(new_record_pos, new_record)
			break
		elif record.time == new_record.time and record.used_broccolis >= new_record.used_broccolis:
			records.pop_back()
			records.insert(new_record_pos, new_record)
			break
		else:
			new_record_pos += 1

	# true if new record
	return new_record_pos == 0 and records[1].time != null


func victory():
	$"/root".set_disable_input(true)
	var is_new_record = set_records()
	win = true
	sounds.play_audio("prewin")
	game.music.set_volume_db(-80)

	var t = $"/root/stage/timer"
	t.set_wait_time(2.0)
	t.start()
	yield(t, "timeout")

	if is_new_record:
		game.effects_layer.play_new_record()
		t.set_wait_time(2.0)
		t.start()
		yield(t, "timeout")
		game.effects_layer.stop_new_record()

	popup_layer.open("win")


func game_over():
	$"/root".set_disable_input(true)
	var t = $"/root/stage/timer"
	t.set_wait_time(0.4)
	t.start()
	yield(t, "timeout")

	sounds.play_audio("game_over")
	popup_layer.open("game_over")


var go_back_manually_disabled = false


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if $"/root".is_input_disabled() or go_back_manually_disabled:
			return
		elif popup_layer.closeable():
			sounds.play_audio("click")
			popup_layer.close()
		elif event_layer.closeable_event():
			sounds.play_audio("click")
			event_layer.stop_closeables()
		elif popup_layer.popup_stack.empty():
			sounds.play_audio("click")
			popup_layer.open("exit_confirmation")


signal language_changed


func change_language(lang_label, lang_resource):
	if lang_resource != null:
		lang = lang_resource.new()
	elif lang != null and lang_label == lang.language:
		emit_signal("language_changed")
		return
	elif lang != null:
		lang.queue_free()
		yield(get_tree().create_timer(.5), "timeout")
		lang = load(cfg.TRANSLATIONS[lang_label]).new()
		yield(get_tree().create_timer(.5), "timeout")

	for translatable in get_tree().get_nodes_in_group("translatable"):
		translatable.update_language()
	emit_signal("language_changed")
