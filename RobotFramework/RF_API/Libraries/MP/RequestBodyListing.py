import datetime, random


class RequestBodyListing(object):
	def __init__(self):
		pass

	@staticmethod
	def get_listing_detail_create_body(number,):
		body = {
			"itemName": "Boutique wooden comb  P" + str(10+number),
			"categoryId": "1299",
			"categoryName": "Airbrushing",
			"categoryPath": "root//Shop Categories//Art Supplies//Paint & Painting Supplies//Airbrushing",
			"brandName": "Next",
			"manufactureName": "",
			"longDescription": "no",
			"tags": ["comb"],
			"availableFrom": datetime.datetime.now().strftime("%Y-%m-%d"),
			"availableTo": "",
			"timeZone": "Asia/Shanghai",
			"dynamicAttributes": {
				"item_properties.paint_type": "Other"
			}
		}
		return body

	@staticmethod
	def get_listing_variation_body():
		body = {
			"sku": "5891743262284455936",
			"price": 2,
			"quantity": 1,
			"masterSku": None,
			"cost": None,
			"additionalCost": None,
			"taxClass": "",
			"variants": [],
			"variationDetails": [],
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"listingVariantMediaUrlRequests": []
		}
		return body

	@staticmethod
	def get_listing_upload_images_body():
		body = {
			"mediaUrls": [
				{
					"mediaId": "5891752024017330176",
					"mediaUrl": "https://imgproxy.tst.platform.michaels.com/XXTpt9MjeIKtJwhEo-W6WCFk1c9-K_Ll4qb5g7o5vco/aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL2Ntcy1taWstdHN0MDAvNTg5MTc1MjAyNDAxNzMzMDE3Ng.webp",
					"createdTime": "2021-10-25T07:15:52.967+00:00"
				}
			]
		}
		return body

	@staticmethod
	def get_listing_shipping_set_body():
		body = {
			"groundShipOnly": False,
			"restrictAKHIShip": False,
			"giftingNote": False,
			"hazmatIndicator": False,
			"flammableContent": False,
			"overrideShippingRate": False,
			"standardRate": None,
			"expeditedRate": None,
			"ltlFreightRate": None,
			"freeStandardShipping": False,
			"listingWeightAndWarningObjects": [],
			"returnPolicyOption": None,
			"refundOnly": False,
			"colorFamily": "Green",
			"globalTradeItemNumberType": "1",
			"globalTradeItemNumber": "556677889",
			"weight": "3",
			"volumeUom": "Cu in",
			"volume": "8",
			"lengthUom": "in",
			"widthUom": "in",
			"heightUom": "in",
			"weightUom": "lb",
			"length": "2",
			"width": "2",
			"height": "2",
			"cost": "0.67"
		}
		return body

	@staticmethod
	def get_search_gtin_body():
		body = {"globalTradeItemNumber": "2312231312", "globalTradeItemNumberType": "1"}
		return body


if __name__ == '__main__':
	r = RequestBodyListing()
	print()
