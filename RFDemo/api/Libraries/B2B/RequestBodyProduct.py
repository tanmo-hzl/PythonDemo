import random


class RequestBodyProduct(object):
	def __init__(self):
		pass

	@staticmethod
	def get_products_trending_now_body(path="root//Shop Categories//Art Supplies"):
		body = {
			"fullTaxonomyPath": path,
			"candidateCount": 3,
			"route": "B2B_EDU"
		}
		return body

	@staticmethod
	def get_recommendation_items_body(sku_number):
		body = {
			"sku": sku_number,
			"candidateCount": 5
		}
		return body

	@staticmethod
	def get_products_simple_body(keyword="", category="Art Supplies", minPrice="", maxPrice=""):
		body = {
			"keywords": keyword,
			"category": category,
			"minPrice": minPrice,
			"maxPrice": maxPrice,
			"pageNumber": 0,
			"pageSize": 28,
			"toAggregate": False,
			"proPackBoostValue": 1.1,
			"facetFilters": []
		}
		return body

	@staticmethod
	def get_random_sku_number(single_sku_items, multi_sku_items, sku_type, quantity: int):
		if int(sku_type) == 0:
			sku_numbers = single_sku_items.split(",")
		elif int(sku_type) == 1:
			sku_numbers = multi_sku_items.split(",")
		else:
			sku_numbers = single_sku_items.split(",") + multi_sku_items.split(",")
		# sku_numbers = sku_numbers.split(",")
		skus = random.sample(sku_numbers, int(quantity))
		return ",".join(skus)


if __name__ == '__main__':
	r = RequestBodyProduct()
	print(r.get_random_sku_number("123,232,223"))
