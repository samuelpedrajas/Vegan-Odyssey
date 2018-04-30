extends Node2D

var admob = null
var isReal = false
var isTop = false
var adBannerId = "ca-app-pub-3940256099942544/6300978111" # [Replace with your Ad Unit ID and delete this message.]
var adRewardedId = "ca-app-pub-3940256099942544/5224354917" # [There is no testing option for rewarded videos, so you can use this id for testing]

var admob_ad_loaded = false
var admob_rewarded_ad_loaded = false


signal reward_action_finished


func start_ads():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadBanner()
		loadRewardedVideo()
	
	get_tree().connect("screen_resized", self, "on_resize")


# loaders
func loadBanner():
	if admob != null:
		admob.loadBanner(adBannerId, isTop)


func loadRewardedVideo():
	if admob != null:
		admob.loadRewardedVideo(adRewardedId)


# players

func showRewardedVideo():
	if admob != null:
		admob.showRewardedVideo()


func _on_admob_network_error():
	print("Network Error")


# banner callbacks

func _on_admob_ad_loaded():
	print("Ad loaded success")
	admob_ad_loaded = true


# rewarded callbacks

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	admob_rewarded_ad_loaded = true


func _on_rewarded_video_ad_failed_to_load(errorCode):
	print("Rewarded failed to load: " + str(errorCode))
	admob_rewarded_ad_loaded = false
	emit_signal("reward_action_finished")
	loadRewardedVideo()


func _on_rewarded_video_ad_closed():
	print("Rewarded closed by user")
	admob_rewarded_ad_loaded = false
	emit_signal("reward_action_finished")
	loadRewardedVideo()


func _on_rewarded(currency, amount):
	admob_rewarded_ad_loaded = false
	print("Reward: " + currency + ", " + str(amount))
	game.broccolis += amount
	game.save_game()
	emit_signal("reward_action_finished")
	loadRewardedVideo()


# resize
func on_resize():
	if admob != null:
		admob.resize()

