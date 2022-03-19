import uuid


class RequestBodyContractPricing(object):
	def __init__(self):
		pass

	@staticmethod
	def get_contract_name():
		name = "Auto Contract " + str(uuid.uuid1()).split("-")[0]
		return name

	@staticmethod
	def get_new_contract_name(contract_name):
		number = contract_name[-2:]
		try:
			number = int(number)
			par_name = contract_name[:-2]
		except Exception as e:
			print(e)
			par_name = contract_name
			number = 10
		finally:
			number = number+1

		new_name = par_name+str(number)
		return new_name


	@staticmethod
	def get_contract_pricing_catalogs_body(name=None, status=None):
		"""

		:param name:
		:param status: ["ACTIVE", "INACTIVE", "PENDING_APPROVAL"]
		:return:
		"""
		body = {
			"pageSize": 20,
			"pricingCatalogName": name,
			"statuses": status,
			"sortBy": "createdTime,desc"
		}
		return body

	@staticmethod
	def get_pricing_tiers_items_body(pricingTierInfo, proPackInfo):

		body = {"newCatalogProducts": [{"proPackSku":proPackInfo.get("skuNumber"),"pricingTierId":pricingTierInfo.get("pricingTierId")}]}
		return body

	@staticmethod
	def get_tiers_items_body():
		body = {"keywords":"","category":"","minPrice":0,"maxPrice":999999,"minRating":0,"proPackBoostValue":2,"pageNumber":0,"pageSize":30}
		return body

	@staticmethod
	def get_pricing_catalogs_elements_body():
		body = {
			"pricingCatalogElementType": "ALL",
			"pageNumber": 0,
			"pageSize": 10
		}
		return body

	@staticmethod
	def check_item_in_list(elements, item):
		in_list = False
		for element in elements:
			if element.get("proPackSku") == item.get("proPackSku") \
					or element.get("proPackSku") == item.get("skuNumber"):
				in_list = True
				break
		return in_list
