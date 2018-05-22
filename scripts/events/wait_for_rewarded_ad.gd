extends Node2D

var priority = 6
var closeable = false
var back_button = false


var ad_to_show
var loaded = false
var finished = false

func start(ad_to_show):
	admob.connect("rewarded_loaded", self, "on_rewarded_loaded")
	admob.connect("ad_server_error", self, "on_ad_server_error")
	admob.connect("bad_request_error", self, "on_bad_request_error")
	admob.connect("rewarded_network_error", self, "on_rewarded_network_error")
	admob.connect("no_more_ads_error", self, "on_no_more_ads_error")
	admob.connect("rewarded_ad_closed", self, "on_rewarded_ad_closed")
	admob.connect("rewarded", self, "on_rewarded")
	admob.connect("banner_network_error", self, "on_banner_network_error")
	admob.loadRewardedVideo(ad_to_show)


func stop():
	get_tree().set_pause(false)
	queue_free()


func on_rewarded_loaded():
	loaded = true
	hide()


func on_ad_server_error():
	if not finished:
		finished = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")


func on_bad_request_error():
	if not finished:
		finished = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")


func on_rewarded_network_error():
	if not finished:
		finished = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("offline")


func on_no_more_ads_error():
	if not finished:
		finished = true
		game.event_layer.stop("wait_for_rewarded_ad")
		game.popup_layer.open("no_more_ads")


func on_rewarded_ad_closed():
	if not finished:
		finished = true
		game.event_layer.stop("wait_for_rewarded_ad")
	

func on_rewarded(amount):
	game.secretly_set_broccolis(game.broccolis + amount)
	game.save_game()
	game.event_layer.stop("broccoli_duck")
	game.effects_layer.play_rewarded_effect(amount)


func on_banner_network_error():
	on_rewarded_network_error()


func _on_timer_timeout():
	if not loaded:
		admob.start_ads()
