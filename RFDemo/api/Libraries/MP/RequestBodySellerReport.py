class RequestBodySellerReport(object):
	def __init__(self):
		pass

	@staticmethod
	def get_timeframe_Body(bundleId):
		body = {
			"startDate": "2022-02-15T06:07:48.007Z",
			"endDate": "2022-02-15T06:07:48.007Z",
			"bundlePhotoRequestl": [
				{
					"fullsizeUrl": "string",
					"largeUrl": "string",
					"thumbnailUrl": "string",
					"smallImageUrl": "string",
					"sort": 0
				}
			],
			"bundleDescription": "string",
			"bundleInternalShortDescription": "string",
			"ageRecommendation": "string",
			"bundleId": bundleId,
			"bundleName": "string",
			"fullTaxonomyPath": "string",
			"tags": [
				"string"
			],
			"bundleStatus": "ACTIVE"
		}
		return body

	@staticmethod
	def get_pricing_body():
		body = {
			"currency": "string",
			"amount": 0,
			"discountAmount": 0,
			"couponEligible": True
		}
		return body

	@staticmethod
	def get_photos_body():
		body = [
			{
				"fullsizeUrl": "string",
				"largeUrl": "string",
				"thumbnailUrl": "string",
				"smallImageUrl": "string",
				"sort": 0
			}
		]
		return body

	@staticmethod
	def get_option_body():
		body = {
			"bundleOptions": [
				{
					"bundleOptionName": "string",
					"options": [
						{
							"skuNumber": "string",
							"skuName": "string",
							"skuCount": 0
						}
					]
				}
			]
		}
		return body

	@staticmethod
	def get_productList_body():
		body = {
			"pageNumber": 0,
			"pageSize": 0,
			"keywords": "string",
			"category": "string",
			"channel": [
				"string"
			],
			"skuType": "string"
		}
		return body

	@staticmethod
	def get_list_body():
		body = {
			"status": "ACTIVE",
			"type": "ALL",
			"sku": "string",
			"sort": "PublishTime",
			"sortDirection": "ASC",
			"pageNumber": 0,
			"pageSize": 0
		}
		return body

	@staticmethod
	def get_create_new_bundle_option_body():
		body = {
			"bundleOptionName": "string"
		}
		return body

	@staticmethod
	def get_create_body():
		body = {
			"startDate": "2022-02-15T07:07:30.054Z",
			"endDate": "2022-02-15T07:07:30.054Z",
			"bundlePhotoRequestl": [
				{
					"fullsizeUrl": "string",
					"largeUrl": "string",
					"thumbnailUrl": "string",
					"smallImageUrl": "string",
					"sort": 0
				}
			],
			"bundleDescription": "string",
			"bundleInternalShortDescription": "string",
			"ageRecommendation": "string",
			"bundleId": "string",
			"bundleName": "string",
			"fullTaxonomyPath": "string",
			"tags": [
				"string"
			],
			"bundleStatus": "ACTIVE"
		}
		return body

	@staticmethod
	def send_email_subscription_body():
		body = {
			"email": "feng1@michaels.com",
			"deviceUuid": "d520c7a8-421b-4563-b955-f5abc56b97ec",
			"accessIp": "154.91.39.234"
		}

		return body

