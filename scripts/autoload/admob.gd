extends Node2D

var admob = null
var isReal = false
var isTop = false
var adBannerId = "ca-app-pub-3940256099942544/6300978111" # [Replace with your Ad Unit ID and delete this message.]
var adRewarded1 = {
	"id": "ca-app-pub-3940256099942544/5224354917",
	"amount": 1
}
var adRewarded2 = {
	"id": "ca-app-pub-3940256099942544/5224354917",
	"amount": 2
}
var adRewarded3 = {
	"id": "ca-app-pub-3940256099942544/5224354917",
	"amount": 3
}

var loadedReward = null  # needed for debugging


signal banner_loaded
signal banner_network_error

signal rewarded_loaded
signal ad_server_error
signal bad_request_error
signal rewarded_network_error
signal no_more_ads_error
signal rewarded_ad_closed
signal rewarded


func start_ads():
	if(Engine.has_singleton("AdMob")):
		print("Starting AdMob")
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadBanner()

	if not get_tree().is_connected("screen_resized", self, "on_resize"):
		get_tree().connect("screen_resized", self, "on_resize")


func get_rewarded_ad_info():
	var tmp = max(1, 4 - game.broccolis)
	var amount = min(3, tmp)
	if amount == 1:
		return adRewarded1
	elif amount == 2:
		return adRewarded2
	else:
		return adRewarded3


# loaders
func loadBanner():
	if admob != null:
		admob.loadBanner(adBannerId, isTop)


func loadRewardedVideo(ad_to_show):
	if admob != null:
		admob.loadRewardedVideo(ad_to_show.id)
		loadedReward = ad_to_show
		print("Reward " + str(ad_to_show.amount) + " broccolis")


# players

func showRewardedVideo():
	if admob != null:
		admob.showRewardedVideo()


# banner loaded callback

func _on_admob_ad_loaded():
	print("Ad loaded success")
	emit_signal("banner_loaded")


# banner load error callback

func _on_admob_network_error():
	print("Network Error")
	emit_signal("banner_network_error")


# rewarded loaded callback

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	emit_signal("rewarded_loaded")
	admob.showRewardedVideo()


# rewarded load error callback

func _on_rewarded_video_ad_failed_to_load(errorCode):
	print("Rewarded failed to load: " + str(errorCode))

	if errorCode == 0:
		print("ad server internal error")
		emit_signal("ad_server_error")
	elif errorCode == 1:
		print("invalid request (ad unit id)")
		emit_signal("bad_request_error")
	elif errorCode == 3:
		print("network error")
		emit_signal("rewarded_network_error")
	elif errorCode == 2:
		print("no more ads")
		emit_signal("no_more_ads_error")
	else:
		print("weird")


# rewarded video closed -- also called on rewarded

func _on_rewarded_video_ad_closed():
	print("Rewarded closed by user")
	emit_signal("rewarded_ad_closed")
	loadedReward = null


# rewarded video on reward

func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	print("Reward: " + str(loadedReward.amount))
	print("FIX THIS IN PRODUCTION:")
	# emit_signal("rewarded", amount)
	emit_signal("rewarded", loadedReward.amount)
	loadedReward = null


# resize
func on_resize():
	if admob != null:
		admob.resize()
