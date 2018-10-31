extends Node2D


var iap
var product_id = "com.vegames.veganodyssey.adfree"


signal request_product_info_success
signal request_product_info_error

signal purchase_success
signal purchase_error

signal restore_purchases_success
signal restore_purchases_error
signal restore_purchases_not_owned


func _ready():
	if OS.get_name() == "iOS":
		iap = Engine.get_singleton("InAppStore")


# put this on a 1 second timer or something
func check_events():
	if iap == null:
		return
	while iap.get_pending_event_count() > 0:
		var event = iap.pop_pending_event()
		print("Popping event:")
		print(event)
		if event.type == "purchase":
			if event.result == "ok" and event.has("receipt"):
				print("Purchase completed!")
				emit_signal("purchase_success")
				iap.finish_transaction(product_id)
			else:
				print("Some error during purchase")
				emit_signal("purchase_error")
		elif event.type == "product_info":
			if event.result == "ok" and event.has("localized_prices"):
				print("Request product info success")
				emit_signal("request_product_info_success", event["localized_prices"])
			else:
				print("Request product info error")
				emit_signal("request_product_info_error")
		elif event.type == "restore":
			if event.result == "ok" and event.has("product_id"):
				emit_signal("restore_purchases_success")
			elif event.result == "not_owned":
				emit_signal("restore_purchases_not_owned")


func request_product_info():
	if iap == null:
		emit_signal("request_product_info_error")
		return
	var result = iap.request_product_info( { "product_ids": [product_id] } )
	if result == OK:
		print("request_product_info ok!")
	else:
		print("request_product_info not ok!")
		emit_signal("request_product_info_error")


func purchase():
	if iap == null:
		emit_signal("purchase_error")
		return
	var result = iap.purchase()
	if result == OK:
		print("purchase ok!")
	else:
		print("purchase not ok!")
		emit_signal("purchase_error")


func restore_purchases():
	if iap == null:
		emit_signal("restore_purchases_error")
		return
	var result = iap.restore_purchases()
	if result == OK:
		print("restore ok!")
	else:
		print("restore not ok!")
		emit_signal("restore_purchases_error")


func coming_from_app_store():
	if iap == null:
		return false
	return iap.coming_from_app_store()


func continue_purchase():
	if iap == null:
		emit_signal("purchase_error")
		return
	var result = iap.continue_purchase()
	if result == OK:
		print("purchase ok!")
	else:
		print("purchase not ok!")
		emit_signal("purchase_error")
