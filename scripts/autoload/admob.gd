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
var loadedReward = null
var admob_loaded = false


signal banner_network_error


func start_ads():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		loadBanner()
	
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
	admob_loaded = true  # used in game_loader.gd


# banner load error callback

func _on_admob_network_error():
	print("Network Error")
	admob_loaded = false
	emit_signal("banner_network_error")


# rewarded loaded callback

func _on_rewarded_video_ad_loaded():
	print("Rewarded loaded success")
	admob.showRewardedVideo()


# rewarded load error callback

func _on_rewarded_video_ad_failed_to_load(errorCode):
	print("Rewarded failed to load: " + str(errorCode))

	if errorCode == 0:
		print("ad server internal error")
	elif errorCode == 1:
		print("invalid request (ad unit id)")
	elif errorCode == 2:
		print("network error")
	elif errorCode == 3:
		print("no more ads")
	else:
		print("weird")

	loadedReward = null
	if game.event_layer != null:
		game.event_layer.stop("broccoli_girl")


# rewarded video closed -- also called on rewarded

func _on_rewarded_video_ad_closed():
	print("Rewarded closed by user")

	loadedReward = null
	game.event_layer.stop("broccoli_girl")


# rewarded video on reward

func _on_rewarded(currency, amount):
	print("Reward: " + currency + ", " + str(amount))
	print("Reward: " + str(loadedReward.amount))
	print("FIX THIS IN PRODUCTION:")
	# game.broccolis += amount
	game.broccolis += loadedReward.amount
	game.save_game()

	loadedReward = null
	game.event_layer.stop("broccoli_girl")


# resize
func on_resize():
	if admob != null:
		admob.resize()
