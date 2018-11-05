extends Node2D

var payment
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
	if OS.get_name() == "Android":
		payment = Engine.get_singleton("GodotPayments")
		print("Godot Payments loaded ", payment)
		payment.setPurchaseCallbackId(get_instance_id())
		payment.setAutoConsume(false)
	elif OS.get_name() == "iOS":
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
			else:
				emit_signal("restore_purchases_error")


func request_product_info():
	if iap == null and payment == null:
		emit_signal("request_product_info_error")
	elif iap != null:
		var result = iap.request_product_info( { "product_ids": [product_id] } )
		if result == OK:
			print("request_product_info ok!")
		else:
			print("request_product_info not ok!")
			emit_signal("request_product_info_error")
	else:
		print("Requesting product info!")
		var sku_list = PoolStringArray([product_id])
		payment.querySkuDetails(sku_list)


func purchase():
	if iap == null and payment == null:
		emit_signal("purchase_error")
	elif iap != null:
		var result = iap.purchase()
		if result == OK:
			print("purchase ok!")
		else:
			print("purchase not ok!")
			emit_signal("purchase_error")
	else:
		payment.purchase(product_id, "veganodyssey_adfree")


func restore_purchases():
	if iap == null and payment == null:
		emit_signal("restore_purchases_error")
	elif iap != null:
		var result = iap.restore_purchases()
		if result == OK:
			print("restore ok!")
		else:
			print("restore not ok!")
			emit_signal("restore_purchases_error")
	else:
		payment.requestPurchased()


func coming_from_app_store():
	if iap == null:
		return false
	return iap.coming_from_app_store()


func continue_purchase():
	if iap == null:
		emit_signal("purchase_error")
	else:
		var result = iap.continue_purchase()
		if result == OK:
			print("purchase ok!")
		else:
			print("purchase not ok!")
			emit_signal("purchase_error")

### Android

func has_purchased(receipt, signature, sku):
	if sku == "":
		print("has_purchased : nothing")
		emit_signal("restore_purchases_not_owned")
	else:
		print("has_purchased : ", sku)
		emit_signal("restore_purchases_success")


func purchase_success(receipt, signature, sku):
	print("purchase_success : ", sku)
	emit_signal("purchase_success")


func purchase_fail():
	print("purchase_fail")
	emit_signal("purchase_error")


func purchase_cancel():
	print("purchase_cancel")
	emit_signal("purchase_error")


func purchase_owned(sku):
	print("purchase_owned : ", sku)
	emit_signal("purchase_success")


# detail info of IAP items
# sku_details = {
#     product_id (String) : {
#         type (String),
#         product_id (String),
#         title (String),
#         description (String),
#         price (String),  # this can be used to display price for each country with their own currency
#         price_currency_code (String),
#         price_amount (float)
#     },
#     ...
# }
var sku_details = {}


func sku_details_complete(result):
	print("sku_details_complete : ", result)
	var price = 0
	for key in result.keys():
		sku_details[key] = result[key]
		price = (
			str(result[key]["price_amount"]) + " " + result[key]["price_currency_code"]
		)
	emit_signal("request_product_info_success", [price])

func sku_details_error(error_message):
	print("error_sku_details = ", error_message)
	emit_signal("request_product_info_error")
