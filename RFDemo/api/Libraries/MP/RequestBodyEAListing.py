class RequestBodyEAListing(object):
	def __init__(self):
		pass

	@staticmethod
	def update_listings_basic_information_Body():
		body = {
			"itemName": "string",
			"longDescription": "string",
			"tags": [
				"string"
			],
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T06:25:08.083Z"
				}
			]
		}
		return body

	@staticmethod
	def get_listings_list_Body():
		body = {
			"status": 0,
			"listing": "string",
			"itemStatus": [
				0
			],
			"startDate": "2022-02-17",
			"endDate": "2022-02-17",
			"categoryPath": "string",
			"subscriptionStatus": 0,
			"defaultDiscountsStatus": 0,
			"pageInfo": {
				"pageNumber": 0,
				"pageSize": 0,
				"totalCount": 0
			},
			"sorts": [
				{
					"field": "string",
					"order": "string"
				}
			]
		}
		return body

	@staticmethod
	def edit_a_listing_body():
		body = {
			"weightUom": "string",
			"weight": "string",
			"volumeUom": "string",
			"volume": "string",
			"lengthUom": "string",
			"length": "string",
			"widthUom": "string",
			"width": "string",
			"heightUom": "string",
			"height": "string",
			"globalTradeItemNumberType": 0,
			"globalTradeItemNumber": "string",
			"pageCode": 0,
			"skuNumber": "string",
			"sellerSkuNumber": "string",
			"itemName": "string",
			"categoryPath": "string",
			"colorFamily": "string",
			"colorName": "string",
			"brandName": "string",
			"vendorName": "string",
			"manufactureName": "string",
			"longDescription": "string",
			"tags": [
				"string"
			],
			"timeZone": "string",
			"availableFrom": "2022-02-17",
			"availableTo": "2022-02-17",
			"price": 0,
			"quantity": 0,
			"taxClass": "string",
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"dynamicAttributes": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"thumbnailUrl": "string",
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T06:30:37.363Z"
				}
			],
			"videoUrl": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"hazmatIndicator": True,
			"hazardType": "string",
			"p65LabelRequirement": True,
			"groundShipOnly": True,
			"restrictAKHIShip": True,
			"restrictPoBoxDelivery": True,
			"giftingNote": True,
			"refundOnly": True,
			"returnPolicyOption": 0,
			"freeStandardShipping": True,
			"overrideShippingRate": True,
			"standardRate": 0,
			"expeditedRate": 0,
			"ltlFreightRate": 0,
			"overrideShippingReturnPolicy": True,
			"variantTypes": [
				"string"
			],
			"addImagesVariantType": "string",
			"variantSwatchUrls": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"variationDetails": [
				{
					"weightUom": "string",
					"weight": "string",
					"volumeUom": "string",
					"volume": "string",
					"lengthUom": "string",
					"length": "string",
					"widthUom": "string",
					"width": "string",
					"heightUom": "string",
					"height": "string",
					"globalTradeItemNumberType": 0,
					"globalTradeItemNumber": "string",
					"skuNumber": "string",
					"sellerSkuNumber": "string",
					"visible": True,
					"variantContents": [
						"string"
					],
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T06:30:37.363Z"
						}
					],
					"inventory": 0,
					"price": 0,
					"restrictPoBoxDelivery": True
				}
			]
			}
		return body

	@staticmethod
	def save_a_listing_body():
		body = {
			"weightUom": "string",
			"weight": "string",
			"volumeUom": "string",
			"volume": "string",
			"lengthUom": "string",
			"length": "string",
			"widthUom": "string",
			"width": "string",
			"heightUom": "string",
			"height": "string",
			"globalTradeItemNumberType": 0,
			"globalTradeItemNumber": "string",
			"pageCode": 0,
			"skuNumber": "string",
			"sellerSkuNumber": "string",
			"itemName": "string",
			"categoryPath": "string",
			"colorFamily": "string",
			"colorName": "string",
			"brandName": "string",
			"vendorName": "string",
			"manufactureName": "string",
			"longDescription": "string",
			"tags": [
				"string"
			],
			"timeZone": "string",
			"availableFrom": "2022-02-17",
			"availableTo": "2022-02-17",
			"price": 0,
			"quantity": 0,
			"taxClass": "string",
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"dynamicAttributes": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"thumbnailUrl": "string",
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T06:33:20.097Z"
				}
			],
			"videoUrl": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"hazmatIndicator": True,
			"hazardType": "string",
			"p65LabelRequirement": True,
			"groundShipOnly": True,
			"restrictAKHIShip": True,
			"restrictPoBoxDelivery": True,
			"giftingNote": True,
			"refundOnly": True,
			"returnPolicyOption": 0,
			"freeStandardShipping": True,
			"overrideShippingRate": True,
			"standardRate": 0,
			"expeditedRate": 0,
			"ltlFreightRate": 0,
			"overrideShippingReturnPolicy": True,
			"variantTypes": [
				"string"
			],
			"addImagesVariantType": "string",
			"variantSwatchUrls": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"variationDetails": [
				{
					"weightUom": "string",
					"weight": "string",
					"volumeUom": "string",
					"volume": "string",
					"lengthUom": "string",
					"length": "string",
					"widthUom": "string",
					"width": "string",
					"heightUom": "string",
					"height": "string",
					"globalTradeItemNumberType": 0,
					"globalTradeItemNumber": "string",
					"skuNumber": "string",
					"sellerSkuNumber": "string",
					"visible": True,
					"variantContents": [
						"string"
					],
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T06:33:20.097Z"
						}
					],
					"inventory": 0,
					"price": 0,
					"restrictPoBoxDelivery": True
				}
			]
		}
		return body

	@staticmethod
	def add_inventory_and_pricing_body():
		body = {
			"skuNumber": "string",
			"price": 0,
			"quantity": 0,
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"thumbnailUrl": "string",
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T06:35:09.716Z"
				}
			],
			"videoUrl": "string",
			"variantTypes": [
				"string"
			],
			"addImagesVariantType": "string",
			"variantSwatchUrls": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"variationDetails": [
				{
					"visible": True,
					"variantContents": [
						"string"
					],
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T06:35:09.716Z"
						}
					],
					"inventory": 0,
					"price": 0
				}
			]
		}
		return body

	@staticmethod
	def create_a_new_listing_body():
		body = {
			"globalTradeItemNumber": "string",
			"globalTradeItemNumberType": 0,
			"skuNumber": "string"
		}
		return body

	@staticmethod
	def create_new_bundle_option_body():
		body = {
			"bundleOptionName": "string"
		}
		return body

	@staticmethod
	def get_a_taxonomy_variant_body():
		body = {
			"channel": 0,
			"taxonomyId": "string",
			"taxonomyPath": "string"
		}
		return body

	@staticmethod
	def add_shipping_information_to_listing_body():
		body = {
			"weightUom": "string",
			"weight": "string",
			"volumeUom": "string",
			"volume": "string",
			"length": "string",
			"lengthUom": "string",
			"width": "string",
			"widthUom": "string",
			"height": "string",
			"heightUom": "string",
			"p65LabelRequirement": True,
			"groundShipOnly": True,
			"restrictAKHIShip": True,
			"restrictPoBoxDelivery": True,
			"giftingNote": True,
			"returnPolicyOption": 0,
			"refundOnly": True,
			"freeStandardShipping": True,
			"overrideShippingRate": True,
			"standardRate": 0,
			"expeditedRate": 0,
			"ltlFreightRate": 0,
			"hazmatIndicator": True,
			"hazardType": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"colorFamily": "string",
			"colorName": "string",
			"globalTradeItemNumberType": 0,
			"globalTradeItemNumber": "string",
			"sellerSkuNumber": "string",
			"overrideShippingReturnPolicy": True,
			"variantShippingInfo": [
				{
					"variantContents": [
						"string"
					],
					"weightUom": "string",
					"weight": "string",
					"volumeUom": "string",
					"volume": "string",
					"length": "string",
					"lengthUom": "string",
					"width": "string",
					"widthUom": "string",
					"height": "string",
					"heightUom": "string",
					"globalTradeItemNumberType": 0,
					"globalTradeItemNumber": "string",
					"sellerSkuNumber": "string"
				}
			]
		}
		return body

	@staticmethod
	def add_listing_detail_attributes_body():
		body = {
			"sku": "string",
			"itemName": "string",
			"globalTradeItemNumberType": 0,
			"categoryId": 0,
			"categoryPath": "string",
			"dynamicAttributes": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"colorFamily": "string",
			"colorName": "string",
			"brandName": "string",
			"vendorName": "string",
			"manufactureName": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"hazmatIndicator": True,
			"hazardType": "string",
			"p65LabelRequirement": True,
			"longDescription": "string",
			"tags": [
				"string"
			],
			"timeZone": "string",
			"availableFrom": "2022-02-17",
			"availableTo": "2022-02-17",
			"storeId": 0,
			"sellerSkuNumber": "string"
		}
		return body

	@staticmethod
	def upload_variation_images_by_url_body():
		body = [
			{
				"variantId": 0,
				"variantValue": "string",
				"variantMedia": {
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T07:27:27.460Z"
				},
				"variantSwatchUrl": "string",
				"thumbnailUrl": "string",
				"variationMedia": [
					{
						"mediaId": "string",
						"mediaUrl": "string",
						"thumbnailUrl": "string",
						"createdTime": "2022-02-17T07:27:27.460Z"
					}
				]
			}
		]
		return body

	@staticmethod
	def upload_images_by_url_body():
		body = {
			"mediaUrls": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T07:38:57.343Z"
				}
			],
			"videoUrl": "string"
		}
		return body

	@staticmethod
	def get_deactived_listing_body():
		body = [
			"string"
		]
		return body

	@staticmethod
	def add_listing_media_videoUrl_body():
		body = [
			{
				"mediaName": "string",
				"mediaId": "string",
				"mediaDescription": "string",
				"mediaSection": "string",
				"mediaSizeId": "string",
				"mimeTypeId": "string",
				"smallImageUrl": "string",
				"colorImageUrl": "string",
				"swatchImageUrl": "string",
				"isHero": "string",
				"skuNumber": "string",
				"mediaType": 0,
				"sort": 0,
				"createdTime": "2022-02-17T07:46:04.250Z",
				"thumbnailUri": "string",
				"mediumUri": "string",
				"fullSizeUri": "string",
				"fullSizeUrl": "string",
				"thumbnailUrl": "string",
				"mediumUrl": "string",
				"largeUrl": "string",
				"videoUrl": "string"
			}
		]
		return body


	@staticmethod
	def convert_seller_sku_numbers_body():
		body = [
			"string"
		]
		return body

	@staticmethod
	def update_listing_body():
		body = {
			"details": {
				"sellerSkuNumber": "string",
				"skuNumber": "string",
				"globalTradeItemNumberType": 0,
				"globalTradeItemNumber": "string",
				"categoryPath": "string",
				"itemName": "string",
				"colorFamily": "string",
				"colorName": "string",
				"brandName": "string",
				"vendorName": "string",
				"manufactureName": "string",
				"longDescription": "string",
				"tags": [
					"string"
				],
				"availableFrom": "2022-02-17",
				"availableTo": "2022-02-17",
				"status": "string",
				"isFinishedGoods": True,
				"recommendedAgeRange": "string",
				"subBrand": "string",
				"theme": "string",
				"occasion": "string",
				"indoorOutdoor": "string",
				"licensedCharacter": "string",
				"material": "string",
				"adhesiveType": "string",
				"intendedUseType": "string",
				"usageAndCare": "string",
				"isPlant": True,
				"flowerPlantType": "string",
				"garmentType": "string",
				"gender": "string",
				"isRibbon": True,
				"ribbonStyleName": "string",
				"shape": "string",
				"size": "string",
				"framedSize": "string",
				"mattedSize": "string",
				"yarnWeight": "string",
				"features": "string",
				"lightBulbColor": "string",
				"lightBulbType": "string",
				"paintType": "string",
				"pencilGrade": "string",
				"washCareInstructions": "string"
			},
			"media": {
				"sku": "string",
				"medias": [
					"string"
				],
				"videoUrl": "string"
			},
			"shippingAndRegulation": {
				"weight": 0,
				"weightUom": "string",
				"width": "string",
				"widthUom": "string",
				"length": "string",
				"lengthUom": "string",
				"height": "string",
				"heightUom": "string",
				"volume": 0,
				"volumeUom": "string",
				"groundShipOnly": True,
				"refundOnly": True,
				"restrictAKHIShip": True,
				"freeStandardShipping": True,
				"overrideShippingRate": True,
				"standardRate": 0,
				"expeditedRate": 0,
				"ltlFreightRate": 0,
				"p65LabelRequirement": True,
				"hazmatIndicator": True,
				"hazardType": "string",
				"flammableContent": True,
				"flammableContentsVerbiage": "string",
				"overrideReturnPolicy": True,
				"returnPolicyOption": 0
			},
			"priceAndInventory": {
				"price": 0,
				"quantity": "string",
				"percentOffOnPrice": 0,
				"percentOffOnRepeatDeliveries": 0
			},
			"variation": {
				"variants": [
					{
						"variantId": "string",
						"variantName": "string",
						"variantType": "string",
						"variantUom": "string",
						"variantContent": [
							"string"
						]
					}
				],
				"variationDetails": [
					{
						"attrs": {
							"additionalProp1": "string",
							"additionalProp2": "string",
							"additionalProp3": "string"
						},
						"status": 0,
						"details": {
							"sellerSkuNumber": "string",
							"skuNumber": "string",
							"globalTradeItemNumberType": 0,
							"globalTradeItemNumber": "string",
							"categoryPath": "string",
							"itemName": "string",
							"colorFamily": "string",
							"colorName": "string",
							"brandName": "string",
							"vendorName": "string",
							"manufactureName": "string",
							"longDescription": "string",
							"tags": [
								"string"
							],
							"availableFrom": "2022-02-17",
							"availableTo": "2022-02-17",
							"status": "string",
							"isFinishedGoods": True,
							"recommendedAgeRange": "string",
							"subBrand": "string",
							"theme": "string",
							"occasion": "string",
							"indoorOutdoor": "string",
							"licensedCharacter": "string",
							"material": "string",
							"adhesiveType": "string",
							"intendedUseType": "string",
							"usageAndCare": "string",
							"isPlant": True,
							"flowerPlantType": "string",
							"garmentType": "string",
							"gender": "string",
							"isRibbon": True,
							"ribbonStyleName": "string",
							"shape": "string",
							"size": "string",
							"framedSize": "string",
							"mattedSize": "string",
							"yarnWeight": "string",
							"features": "string",
							"lightBulbColor": "string",
							"lightBulbType": "string",
							"paintType": "string",
							"pencilGrade": "string",
							"washCareInstructions": "string"
						},
						"priceAndInventory": {
							"price": 0,
							"quantity": "string",
							"percentOffOnPrice": 0,
							"percentOffOnRepeatDeliveries": 0
						},
						"media": {
							"sku": "string",
							"medias": [
								"string"
							],
							"videoUrl": "string"
						},
						"shippingAndRegulation": {
							"weight": 0,
							"weightUom": "string",
							"width": "string",
							"widthUom": "string",
							"length": "string",
							"lengthUom": "string",
							"height": "string",
							"heightUom": "string",
							"volume": 0,
							"volumeUom": "string",
							"groundShipOnly": True,
							"refundOnly": True,
							"restrictAKHIShip": True,
							"freeStandardShipping": True,
							"overrideShippingRate": True,
							"standardRate": 0,
							"expeditedRate": 0,
							"ltlFreightRate": 0,
							"p65LabelRequirement": True,
							"hazmatIndicator": True,
							"hazardType": "string",
							"flammableContent": True,
							"flammableContentsVerbiage": "string",
							"overrideReturnPolicy": True,
							"returnPolicyOption": 0
						}
					}
				]
			}
		}
		return body

	@staticmethod
	def create_a_listing_body():
		body = {
			"details": {
				"sellerSkuNumber": "string",
				"skuNumber": "string",
				"globalTradeItemNumberType": 0,
				"globalTradeItemNumber": "string",
				"categoryPath": "string",
				"itemName": "string",
				"colorFamily": "string",
				"colorName": "string",
				"brandName": "string",
				"vendorName": "string",
				"manufactureName": "string",
				"longDescription": "string",
				"tags": [
					"string"
				],
				"availableFrom": "2022-02-17",
				"availableTo": "2022-02-17",
				"status": "string",
				"isFinishedGoods": True,
				"recommendedAgeRange": "string",
				"subBrand": "string",
				"theme": "string",
				"occasion": "string",
				"indoorOutdoor": "string",
				"licensedCharacter": "string",
				"material": "string",
				"adhesiveType": "string",
				"intendedUseType": "string",
				"usageAndCare": "string",
				"isPlant": True,
				"flowerPlantType": "string",
				"garmentType": "string",
				"gender": "string",
				"isRibbon": True,
				"ribbonStyleName": "string",
				"shape": "string",
				"size": "string",
				"framedSize": "string",
				"mattedSize": "string",
				"yarnWeight": "string",
				"features": "string",
				"lightBulbColor": "string",
				"lightBulbType": "string",
				"paintType": "string",
				"pencilGrade": "string",
				"washCareInstructions": "string"
			},
			"media": {
				"sku": "string",
				"medias": [
					"string"
				],
				"videoUrl": "string"
			},
			"shippingAndRegulation": {
				"weight": 0,
				"weightUom": "string",
				"width": "string",
				"widthUom": "string",
				"length": "string",
				"lengthUom": "string",
				"height": "string",
				"heightUom": "string",
				"volume": 0,
				"volumeUom": "string",
				"groundShipOnly": True,
				"refundOnly": True,
				"restrictAKHIShip": True,
				"freeStandardShipping": True,
				"overrideShippingRate": True,
				"standardRate": 0,
				"expeditedRate": 0,
				"ltlFreightRate": 0,
				"p65LabelRequirement": True,
				"hazmatIndicator": True,
				"hazardType": "string",
				"flammableContent": True,
				"flammableContentsVerbiage": "string",
				"overrideReturnPolicy": True,
				"returnPolicyOption": 0
			},
			"priceAndInventory": {
				"price": 0,
				"quantity": "string",
				"percentOffOnPrice": 0,
				"percentOffOnRepeatDeliveries": 0
			},
			"variation": {
				"variants": [
					{
						"variantId": "string",
						"variantName": "string",
						"variantType": "string",
						"variantUom": "string",
						"variantContent": [
							"string"
						]
					}
				],
				"variationDetails": [
					{
						"attrs": {
							"additionalProp1": "string",
							"additionalProp2": "string",
							"additionalProp3": "string"
						},
						"status": 0,
						"details": {
							"sellerSkuNumber": "string",
							"skuNumber": "string",
							"globalTradeItemNumberType": 0,
							"globalTradeItemNumber": "string",
							"categoryPath": "string",
							"itemName": "string",
							"colorFamily": "string",
							"colorName": "string",
							"brandName": "string",
							"vendorName": "string",
							"manufactureName": "string",
							"longDescription": "string",
							"tags": [
								"string"
							],
							"availableFrom": "2022-02-17",
							"availableTo": "2022-02-17",
							"status": "string",
							"isFinishedGoods": True,
							"recommendedAgeRange": "string",
							"subBrand": "string",
							"theme": "string",
							"occasion": "string",
							"indoorOutdoor": "string",
							"licensedCharacter": "string",
							"material": "string",
							"adhesiveType": "string",
							"intendedUseType": "string",
							"usageAndCare": "string",
							"isPlant": True,
							"flowerPlantType": "string",
							"garmentType": "string",
							"gender": "string",
							"isRibbon": True,
							"ribbonStyleName": "string",
							"shape": "string",
							"size": "string",
							"framedSize": "string",
							"mattedSize": "string",
							"yarnWeight": "string",
							"features": "string",
							"lightBulbColor": "string",
							"lightBulbType": "string",
							"paintType": "string",
							"pencilGrade": "string",
							"washCareInstructions": "string"
						},
						"priceAndInventory": {
							"price": 0,
							"quantity": "string",
							"percentOffOnPrice": 0,
							"percentOffOnRepeatDeliveries": 0
						},
						"media": {
							"sku": "string",
							"medias": [
								"string"
							],
							"videoUrl": "string"
						},
						"shippingAndRegulation": {
							"weight": 0,
							"weightUom": "string",
							"width": "string",
							"widthUom": "string",
							"length": "string",
							"lengthUom": "string",
							"height": "string",
							"heightUom": "string",
							"volume": 0,
							"volumeUom": "string",
							"groundShipOnly": True,
							"refundOnly": True,
							"restrictAKHIShip": True,
							"freeStandardShipping": True,
							"overrideShippingRate": True,
							"standardRate": 0,
							"expeditedRate": 0,
							"ltlFreightRate": 0,
							"p65LabelRequirement": True,
							"hazmatIndicator": True,
							"hazardType": "string",
							"flammableContent": True,
							"flammableContentsVerbiage": "string",
							"overrideReturnPolicy": True,
							"returnPolicyOption": 0
						}
					}
				]
			}
		}
		return body

	@staticmethod
	def relist_listing_body():
		body = {
			"skus": [
				"string"
			],
			"startTime": "2022-02-17",
			"endTime": "2022-02-17"
		}
		return body

	@staticmethod
	def export_all_listings_by_storeId_body():
		body = [
			"string"
		]
		return body

	@staticmethod
	def reorder_the_listing_medias_body():
		body = {
			"additionalProp1": 0,
			"additionalProp2": 0,
			"additionalProp3": 0
		}
		return body

	@staticmethod
	def retrieve_listings_of_specific_categories_body():
		body = {
			"categories": [
				"string"
			]
		}
		return body

	@staticmethod
	def edit_variant_medias_body():
		body = {
			"variantId": "string",
			"variantValue": "string",
			"newVariantMedia": "string",
			"newVariationMedia": "string",
			"oldVariantMedia": "string",
			"oldVariationMedia": "string"
		}
		return body

	@staticmethod
	def update_inventory_of_listing_body():
		body = [
			{
				"skuNumber": "string",
				"masterSkuNumber": "string",
				"quantity": "string"
			}
		]
		return body

	@staticmethod
	def update_price_of_listing_body():
		body = [
			{
				"skuNumber": "string",
				"masterSkuNumber": "string",
				"price": 0
			}
		]
		return body

	@staticmethod
	def download_template_file_body():
		body = [
			"string"
		]
		return body

	@staticmethod
	def create_listings_by_upload_template_file_body():
		body ={
			"file": "string"
		}
		return body

	@staticmethod
	def edit_ea_listing_body():
		body = {
			"weightUom": "string",
			"weight": "string",
			"volumeUom": "string",
			"volume": "string",
			"lengthUom": "string",
			"length": "string",
			"widthUom": "string",
			"width": "string",
			"heightUom": "string",
			"height": "string",
			"globalTradeItemNumberType": 0,
			"globalTradeItemNumber": "string",
			"pageCode": 0,
			"skuNumber": "string",
			"sellerSkuNumber": "string",
			"itemName": "string",
			"categoryPath": "string",
			"colorFamily": "string",
			"colorName": "string",
			"brandName": "string",
			"vendorName": "string",
			"manufactureName": "string",
			"longDescription": "string",
			"tags": [
				"string"
			],
			"timeZone": "string",
			"availableFrom": "2022-02-17",
			"availableTo": "2022-02-17",
			"price": 0,
			"quantity": "string",
			"taxClass": "string",
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"dynamicAttributes": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"thumbnailUrl": "string",
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T08:47:13.075Z"
				}
			],
			"videoUrl": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"hazmatIndicator": True,
			"hazardType": "string",
			"p65LabelRequirement": True,
			"groundShipOnly": True,
			"restrictAKHIShip": True,
			"restrictPoBoxDelivery": True,
			"giftingNote": True,
			"refundOnly": True,
			"returnPolicyOption": 0,
			"freeStandardShipping": True,
			"overrideShippingRate": True,
			"standardRate": 0,
			"expeditedRate": 0,
			"ltlFreightRate": 0,
			"overrideShippingReturnPolicy": True,
			"variantTypes": [
				"string"
			],
			"addImagesVariantType": "string",
			"variantSwatchUrls": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"variationDetails": [
				{
					"weightUom": "string",
					"weight": "string",
					"volumeUom": "string",
					"volume": "string",
					"lengthUom": "string",
					"length": "string",
					"widthUom": "string",
					"width": "string",
					"heightUom": "string",
					"height": "string",
					"globalTradeItemNumberType": 0,
					"globalTradeItemNumber": "string",
					"skuNumber": "string",
					"sellerSkuNumber": "string",
					"visible": True,
					"variantContents": [
						"string"
					],
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T08:47:13.075Z"
						}
					],
					"inventory": "string",
					"price": 0,
					"restrictPoBoxDelivery": True
				}
			]
		}
		return body

	@staticmethod
	def add_inventory_and_pricing_body():
		body = {
			"skuNumber": "string",
			"price": 0,
			"quantity": "string",
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"thumbnailUrl": "string",
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T08:50:13.641Z"
				}
			],
			"videoUrl": "string",
			"variantTypes": [
				"string"
			],
			"addImagesVariantType": "string",
			"variantSwatchUrls": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"variationDetails": [
				{
					"visible": True,
					"variantContents": [
						"string"
					],
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T08:50:13.641Z"
						}
					],
					"inventory": "string",
					"price": 0
				}
			]
		}
		return body

	@staticmethod
	def saving_a_listing_body():
		body = {
			"weightUom": "string",
			"weight": "string",
			"volumeUom": "string",
			"volume": "string",
			"lengthUom": "string",
			"length": "string",
			"widthUom": "string",
			"width": "string",
			"heightUom": "string",
			"height": "string",
			"globalTradeItemNumberType": 0,
			"globalTradeItemNumber": "string",
			"pageCode": 0,
			"skuNumber": "string",
			"sellerSkuNumber": "string",
			"itemName": "string",
			"categoryPath": "string",
			"colorFamily": "string",
			"colorName": "string",
			"brandName": "string",
			"vendorName": "string",
			"manufactureName": "string",
			"longDescription": "string",
			"tags": [
				"string"
			],
			"timeZone": "string",
			"availableFrom": "2022-02-17",
			"availableTo": "2022-02-17",
			"price": 0,
			"quantity": "string",
			"taxClass": "string",
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"dynamicAttributes": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"thumbnailUrl": "string",
			"medias": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T08:50:37.240Z"
				}
			],
			"videoUrl": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"hazmatIndicator": True,
			"hazardType": "string",
			"p65LabelRequirement": True,
			"groundShipOnly": True,
			"restrictAKHIShip": True,
			"restrictPoBoxDelivery": True,
			"giftingNote": True,
			"refundOnly": True,
			"returnPolicyOption": 0,
			"freeStandardShipping": True,
			"overrideShippingRate": True,
			"standardRate": 0,
			"expeditedRate": 0,
			"ltlFreightRate": 0,
			"overrideShippingReturnPolicy": True,
			"variantTypes": [
				"string"
			],
			"addImagesVariantType": "string",
			"variantSwatchUrls": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"variationDetails": [
				{
					"weightUom": "string",
					"weight": "string",
					"volumeUom": "string",
					"volume": "string",
					"lengthUom": "string",
					"length": "string",
					"widthUom": "string",
					"width": "string",
					"heightUom": "string",
					"height": "string",
					"globalTradeItemNumberType": 0,
					"globalTradeItemNumber": "string",
					"skuNumber": "string",
					"sellerSkuNumber": "string",
					"visible": True,
					"variantContents": [
						"string"
					],
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T08:50:37.240Z"
						}
					],
					"inventory": "string",
					"price": 0,
					"restrictPoBoxDelivery": True
				}
			]
		}
		return body

	@staticmethod
	def batch_upload_images_by_url_body():
		body = {
			"file": "string"
		}
		return body

	@staticmethod
	def add_listing_detail_attributes_body():
		body = {
			"sku": "string",
			"itemName": "string",
			"globalTradeItemNumberType": 0,
			"categoryId": 0,
			"categoryPath": "string",
			"dynamicAttributes": {
				"additionalProp1": "string",
				"additionalProp2": "string",
				"additionalProp3": "string"
			},
			"colorFamily": "string",
			"colorName": "string",
			"brandName": "string",
			"vendorName": "string",
			"manufactureName": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"hazmatIndicator": True,
			"hazardType": "string",
			"p65LabelRequirement": True,
			"longDescription": "string",
			"tags": [
				"string"
			],
			"timeZone": "string",
			"availableFrom": "2022-02-17",
			"availableTo": "2022-02-17",
			"storeId": "string",
			"sellerSkuNumber": "string"
		}
		return body

	@staticmethod
	def add_listing_variants_body():
		body ={
			"sku": "string",
			"price": 0,
			"quantity": 0,
			"additionalCost": 0,
			"taxClass": "string",
			"variants": [
				{
					"variantId": "string",
					"variantName": "string",
					"variantType": "string",
					"variantUom": "string",
					"variantContent": [
						"string"
					]
				}
			],
			"variationDetails": [
				{
					"price": 0,
					"inventory": "string",
					"attrs": {
						"additionalProp1": "string",
						"additionalProp2": "string",
						"additionalProp3": "string"
					},
					"status": 0,
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T09:02:06.684Z"
						}
					]
				}
			],
			"percentOffOnPrice": 0,
			"percentOffOnRepeatDeliveries": 0,
			"listingVariantMediaUrlRequests": [
				{
					"variantId": 0,
					"variantValue": "string",
					"variantMedia": {
						"mediaId": "string",
						"mediaUrl": "string",
						"thumbnailUrl": "string",
						"createdTime": "2022-02-17T09:02:06.684Z"
					},
					"variantSwatchUrl": "string",
					"thumbnailUrl": "string",
					"variationMedia": [
						{
							"mediaId": "string",
							"mediaUrl": "string",
							"thumbnailUrl": "string",
							"createdTime": "2022-02-17T09:02:06.684Z"
						}
					]
				}
			]
		}
		return body

	@staticmethod
	def add_medias_to_a_listing_body():
		body = {
			"sku": "string",
			"medias": "string",
			"videoUrl": "string"
		}
		return body

	@staticmethod
	def add_medias_for_the_listing_variation_body():
		body = {
			"variantId": "string",
			"variantValue": "string",
			"variantMedia": "string",
			"variationMedia": "string"
		}
		return body

	@staticmethod
	def add_shipping_information_to_listing_body():
		body = {
			"weightUom": "string",
			"weight": "string",
			"volumeUom": "string",
			"volume": "string",
			"length": "string",
			"lengthUom": "string",
			"width": "string",
			"widthUom": "string",
			"height": "string",
			"heightUom": "string",
			"p65LabelRequirement": True,
			"groundShipOnly": True,
			"restrictAKHIShip": True,
			"restrictPoBoxDelivery": True,
			"giftingNote": True,
			"returnPolicyOption": 0,
			"refundOnly": True,
			"freeStandardShipping": True,
			"overrideShippingRate": True,
			"standardRate": 0,
			"expeditedRate": 0,
			"ltlFreightRate": 0,
			"hazmatIndicator": True,
			"hazardType": "string",
			"flammableContent": True,
			"flammableContentsVerbiage": "string",
			"colorFamily": "string",
			"colorName": "string",
			"globalTradeItemNumberType": 0,
			"globalTradeItemNumber": "string",
			"sellerSkuNumber": "string",
			"overrideShippingReturnPolicy": True,
			"variantShippingInfo": [
				{
					"variantContents": [
						"string"
					],
					"weightUom": "string",
					"weight": "string",
					"volumeUom": "string",
					"volume": "string",
					"length": "string",
					"lengthUom": "string",
					"width": "string",
					"widthUom": "string",
					"height": "string",
					"heightUom": "string",
					"globalTradeItemNumberType": 0,
					"globalTradeItemNumber": "string",
					"sellerSkuNumber": "string"
				}
			]
		}
		return body

	@staticmethod
	def upload_images_by_url_body():
		body = {
			"mediaUrls": [
				{
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T09:10:28.553Z"
				}
			],
			"videoUrl": "string"
		}
		return body

	@staticmethod
	def create_listings_by_uploading_excel_template_file_body():
		body = {
			"file": "string"
		}
		return body

	@staticmethod
	def create_listings_and_update_inventoris_by_uploading_excel_data_body():
		body = {
			"file": "string"
		}
		return body

	@staticmethod
	def upload_variation_images_by_url_body():
		body = [
			{
				"variantId": 0,
				"variantValue": "string",
				"variantMedia": {
					"mediaId": "string",
					"mediaUrl": "string",
					"thumbnailUrl": "string",
					"createdTime": "2022-02-17T09:47:43.683Z"
				},
				"variantSwatchUrl": "string",
				"thumbnailUrl": "string",
				"variationMedia": [
					{
						"mediaId": "string",
						"mediaUrl": "string",
						"thumbnailUrl": "string",
						"createdTime": "2022-02-17T09:47:43.683Z"
					}
				]
			}
		]
		return body

	@staticmethod
	def create_listings_by_uploading_csv_excel_template_file_body():
		body = {
			"file": "string"
		}
		return body

	@staticmethod
	def edit_an_image_body():
		body = {
			"file": "string"
		}
		return body

	@staticmethod
	def create_a_store_listing_body():
		body = [
			"string"
		]
		return body

