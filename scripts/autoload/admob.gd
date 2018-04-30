extends Node2D

var admob = null
var isReal = false
var isTop = false
var adBannerId = "ca-app-pub-3940256099942544/6300978111" # [Replace with your Ad Unit ID and delete this message.]

var admob_ad_loaded = true


func start_ads():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		admob.init(isReal, get_instance_id())
		admob.loadBanner(adBannerId, isTop)
	
	get_tree().connect("screen_resized", self, "on_resize")


func _on_admob_network_error():
	print("Network Error")


func _on_admob_ad_loaded():
	admob_ad_loaded = true
	print("Ad loaded success")


# resize
func on_resize():
	if admob != null:
		admob.resize()

