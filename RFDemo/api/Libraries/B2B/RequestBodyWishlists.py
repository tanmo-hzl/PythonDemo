class RequestBodyWishlists(object):
	def __init__(self):
		pass

	@staticmethod
	def get_add_wishlists_body(user_id):
		body = {
			"userId": user_id,
			"listType": 2,
			"listName": "wishlist00",
			"sortNum": 0,
			"description": "",
			"isDefault": 0,
			"isPublic": 0,
			"isDeleted": 0,
			"channel": 0
		}
		return body

	@staticmethod
	def get_update_wishlists_body(list_ame):
		body = {"listName": list_ame}
		return body

	@staticmethod
	def get_add_items_to_list_body(wishlist_id, object_id="MP532887"):
		body = {
			"wishlistItems": [
				{
					"listId": wishlist_id,
					"objectType": 1,
					"objectId": object_id,
					"currency": "USD",
					"desiredQuantity": 1
				}
			]
		}
		return body
