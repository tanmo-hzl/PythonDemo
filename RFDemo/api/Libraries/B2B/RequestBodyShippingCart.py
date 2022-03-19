import random


class RequestBodyShippingCart(object):
	def __init__(self):
		pass

	@staticmethod
	def get_add_item_to_cart_body(user_id, cart_id, sku_number, subSkuNumber=None, quantity=1):
		body = {
			"cartItems": [{
				"skuNumber": sku_number,
				"subSkuNumber": subSkuNumber,
				"quantity": quantity,
				"shoppingCartId": cart_id,
				"userId": user_id,
				"isSelected": True,
				"isGift": False,
				"canSchedule": False,
				"itemType": 1,
				"michaelsStoreId": "-2"
			}]
		}
		return body

	@staticmethod
	def get_add_multi_items_to_cart_body(user_id, cart_id, pro_info, max_quantity=5):
		if max_quantity < 1:
			max_quantity = 1
		cart_items = []
		for item in pro_info:
			if item.get("masterSkuNumber") is None:
				skuNumber = item.get("skuNumber")
				subSkuNumber = None
			else:
				skuNumber = item.get("masterSkuNumber")
				subSkuNumber = item.get("skuNumber")
			cart_item = {
				"skuNumber": skuNumber,
				"subSkuNumber": subSkuNumber,
				"quantity": random.randint(1, int(max_quantity)),
				"shoppingCartId": cart_id,
				"userId": user_id,
				"isSelected": True,
				"isGift": False,
				"canSchedule": False,
				"itemType": 1,
				"michaelsStoreId": "-2"
			}
			cart_items.append(cart_item)
		body = {"cartItems": cart_items}
		return body

	@staticmethod
	def get_user_cart_info_body(user_id):
		body = {
			"userId": user_id,
			"channel": "RETAIL"
		}
		return body

	@staticmethod
	def get_all_items_id(data):
		items = []
		for item in data:
			items.append(item.get("shoppingItemId"))
		if len(items) == 0:
			return None
		body = ",".join(items)
		return body
