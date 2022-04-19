import random
import re
import time


class EARequestBodyLib(object):
	def __init__(self):
		self.order_status_list = ["Pending Confirmation", "Ready to Ship", "Partially Shipped", "Shipped",
		                          "Partially Delivered", "Delivered", "Cancelled", "Completed"]
		self.order_status_values = [3000, 3500, 6800, 7000, 7300, 7500, 9000, 10000, 9700]
		self.return_status_list = ["Pending Return", "Refund Rejected", "Returned", "Return Canceled", "Pending Refund"]
		self.return_status_values = [["11000", "10500", "17000"], 19100, 18000, 19000, 16000]
		self.dispute_status_list = ["Dispute Opened", "Dispute In Process", "Offer Made", "Offer Rejected",
		                            "Dispute Resolved", "Dispute Escalated", "Escalation Under Review",
		                            "Dispute Canceled"]
		self.dispute_status_values = [30000, 30100, 31000, 31100, 34000, 32000, 32100, 35000]

	def get_return_order_status_value(self, status_key):
		index = self.return_status_list.index(status_key)
		status_value = self.return_status_values[index]
		if type(status_value) is list:
			status_values = status_value
		else:
			status_values = [str(status_value)]
		return status_values

	def get_seller_order_list_body(self, data_type=1, **kwargs):
		"""

		:param data_type:  1-order management;2-return order;3-dispute order
		:param kwargs: dateRange,status,keyWords
		:return:
		"""
		print(kwargs)
		keys = kwargs.keys()
		if "dateRange" not in keys:
			date_range = [0, 0]
		else:
			if kwargs["dateRange"] is None:
				date_range = [0, 0]
			else:
				date_range = kwargs["dateRange"]
		if data_type == 1:
			status = self.order_status_list
			values = self.order_status_values
		elif data_type == 2:
			status = self.return_status_list
			values = self.return_status_values
		else:
			status = self.dispute_status_list
			values = self.dispute_status_values
		statuses = ""

		if "status" in keys:
			for i in range(len(status)):
				if status[i] == kwargs["status"]:
					statuses = values[i]
		if type(statuses) is list:
			last_status = ",".join(statuses)
		else:
			last_status = statuses

		body = {"channels": 2,
		        "type": data_type,
		        "pageNum": 1,
		        "pageSize": 100,
		        "isAsc": False,
		        "dateStatusAggregate": True,
		        "isAlone": True,
		        "timeBase": int(time.time() * 1000)
		        }
		if data_type == 1:
			body["ignoreBuyerCancel"] = True
		if statuses != "":
			body["statuses"] = last_status
		if int(date_range[0]) != 0:
			body["startTime"] = int((time.time() + 24 * 60 * 60 * int(date_range[0])) * 1000)
			body["endTime"] = int((time.time() + 24 * 60 * 60 * int(date_range[1])) * 1000)
		if "keyWords" in keys:
			body["keyWords"] = kwargs["keyWords"]
		return body

	@staticmethod
	def get_listing_info_by_status_and_variants(listings, status, have_variants=False, location=4, variationsNum=None):
		qualified_listings = []
		for item in listings:
			if item.get("status") == status and item.get("media") is not None:
				if not have_variants and item.get("variationsNum") == 0:
					qualified_listings.append(item)
				if have_variants:
					if variationsNum is None and item.get("variationsNum") > 0:
						qualified_listings.append(item)
					if variationsNum is not None and int(variationsNum) == item.get("variationsNum"):
						qualified_listings.append(item)
		listings_count = len(qualified_listings)
		if listings_count < 4:
			qualified_listings = random.sample(qualified_listings, 1)
		else:
			qualified_listings = qualified_listings[int(listings_count*(int(location)-1)/4):int(listings_count*int(location)/4)]
		return random.choice(qualified_listings)

	def get_listing_url_by_quantity_status_and_variants(self,listings, quantity, status, have_variants=None):
		qualified_listings = []
		for item in listings:
			if item.get("status") == status:
				if have_variants is None:
					qualified_listings.append(item)
				else:
					if not have_variants and item.get("variationsNum") == 0:
						qualified_listings.append(item)
					if have_variants and item.get("variationsNum") > 0:
						qualified_listings.append(item)
		listing_count = len(qualified_listings)
		qualified_listings = qualified_listings[int(listing_count/4):int(listing_count/2)]
		qualified_listings = random.sample(qualified_listings, int(quantity))
		listing_urls = []
		for item in qualified_listings:
			url = "{}-{}".format(self.replace_listings_title(item.get("itemName")), item.get("sku"))
			listing_urls.append(url)
		return listing_urls

	@staticmethod
	def replace_listings_title(listing_title):
		code_list = ["(", ")", "#", "@", "-"]
		listing_title = listing_title.replace(" ", "-")
		for item in code_list:
			listing_title = listing_title.replace(item, "")
		uu_data = re.findall(r"-{2,}", listing_title)
		print(uu_data)
		for item in uu_data:
			listing_title = listing_title.replace(item, "-")
		return listing_title.lower()

	@staticmethod
	def get_ship_item_body(order_detail, all_item_shipped=True, all_quantity_shipped=True):
		orderLines = order_detail.get("orderLines")
		shipmentItemList = []

		for line in orderLines:
			if line.get("status") in (3500, 6800):
				quantity = line.get("quantity") if line.get("status") == 3500 else line.get("quantity")-line.get("fulfilledQuantity")
				shipmentItemList.append({
					"quantity": quantity,
					"orderItemId": line.get("orderItemId"),
					"uom": line.get("uom")
				})

		if all_item_shipped and not all_quantity_shipped:
			for item in shipmentItemList:
				item["quantity"] = 1
		if not all_item_shipped and all_quantity_shipped:
			shipmentItemList = shipmentItemList[:1]

		if not all_item_shipped and not all_quantity_shipped:
			shipmentItemList = shipmentItemList[:1]
			shipmentItemList[0]["quantity"] = 1

		body = {
			"orderNumber": order_detail.get("orderNumber"),
			"shipmentsList": [
				{
					"trackingNumber": random.randint(100010001, 10001000999),
					"carrier": "UPS",
					"carrierTrackingUrl": "https://www.ups.com/us/en/Home.page",
					"shippingLabel": None,
					"shipmentItemList": shipmentItemList
				}
			]
		}
		return body

	def get_listings_skus_by_kwargs(self, listings_data, total=2, **kwargs):
		add_listings = []
		over_rate_listings = []
		default_rate_listings = []
		no_items_listings = []
		need_items_listings = []
		no_return_listing = []
		for item in listings_data:
			if item.get("itemName").count("OverrideRate"):
				over_rate_listings.append(item)
			if item.get("itemName").count("DefaultRate"):
				default_rate_listings.append(item)
			if item.get("itemName").count("NoItems"):
				no_items_listings.append(item)
			if item.get("itemName").count("NeedItems"):
				need_items_listings.append(item)
			if item.get("itemName").count("NoReturn"):
				no_return_listing.append(item)

		add_listings = self.__loop_to_add_listings("OverrideRate", over_rate_listings, add_listings, kwargs)
		add_listings = self.__loop_to_add_listings("DefaultRate", default_rate_listings, add_listings, kwargs)
		add_listings = self.__loop_to_add_listings("NoItems", no_items_listings, add_listings, kwargs)
		add_listings = self.__loop_to_add_listings("NeedItems", need_items_listings, add_listings, kwargs)
		add_listings = self.__loop_to_add_listings("NoReturn", no_return_listing, add_listings, kwargs)
		random.shuffle(listings_data)
		for item in listings_data:
			if len(add_listings) >= int(total):
				break
			if item not in add_listings:
				add_listings.append(item)

		sku_numbers = []
		sku_names = []
		for item in add_listings:
			sku_numbers.append(item.get("skuNumber"))
			sku_names.append(item.get("skuName"))

		print("sku_numbers: {}; sku_names: {}".format(sku_numbers, sku_names))
		return sku_numbers

	@staticmethod
	def __loop_to_add_listings(key, base_listings, add_listings, kwargs):
		random.shuffle(base_listings)
		if key in kwargs.keys():
			add_quantity = 0
			for item in base_listings:
				if item not in add_listings:
					add_listings.append(item)
					add_quantity += 1
					if add_quantity == int(kwargs.get(key)):
						break
		return add_listings

	@staticmethod
	def get_address_with_free_tax(address_list, **kwargs):
		tax_address = []
		free_tax_address = []
		for address in address_list:
			if address.get("state") in ("AK",):
				free_tax_address.append(address)
			else:
				tax_address.append(address)

		if "freeTax" in kwargs and kwargs["freeTax"] and len(free_tax_address)>0:
			address = random.choice(free_tax_address)
		else:
			address = random.choice(tax_address)
		return address

	@staticmethod
	def get_product_detail_body(sku_number, store_id=None):
		body = {
			"skuNumbers": sku_number,
			"michaelsStoreId": store_id,
			"needPromotion": True,
			"needPrice": True,
			"needInventory": True,
		}
		return body

	@staticmethod
	def get_cart_random_items_add_body(user_id, cart_id, product_data_list, quantity=None):
		cart_items = []
		for product in product_data_list:
			if not product["addToCartStatus"]["addToCartStatus"]:
				continue
			sub_sku_number = ""
			sub_skus = product["subSkus"]
			if sub_skus:
				for sbu_sku in sub_skus:
					if sbu_sku["availability"]:
						sub_sku_number = sbu_sku["skuNumber"]
						break
			if quantity is None:
				quantity = random.randint(2, 6)
			item = {
				"skuNumber": product["skuNumber"],
				"subSkuNumber": sub_sku_number,
				"shipMethod": 0,
				"michaelsStoreId": -1,
				"sellerStoreName": "",
				"isSelected": False,
				"isGift": False,
				"quantity": quantity,
				"canSchedule": False,
				"intervalSeconds": None,
				"itemType": 1,
				"scheduleId": None,
				"bundleSkus": [],
				"bundleSkuCounts": [],
				"cartItemGifts": [],
				"userId": user_id,
				"shoppingCartId": cart_id,
			}
			cart_items.append(item)
		body = {
			"isBuyNow": False,
			"cartItems": cart_items,
		}
		return body

	@staticmethod
	def get_pre_initiate_body(item_info_list, shipping_address: dict):
		pre_initial_item_vo_list = []
		for item in item_info_list:
			item_info = {
				"shoppingCartItemId": item.get("shoppingItemId"),
				"skuNumber": item.get("skuNumber"),
				"subSkuNumber": item.get("subSkuNumber"),
				"price": item.get("price"),
				"quantity": item.get("quantity"),
				"totalPrice": int(item.get("quantity")) * float(item.get("price")),
				"channelType": 2,
				"storeId": item.get("sellerStoreId"),
				"mikStoreId": "-1",
				"generalShippingType": 0,
			}
			pre_initial_item_vo_list.append(item_info)
		body = {
			"shippingAddress": shipping_address,
			"localTimeVo": {
				"timeInMillis": round(time.time() * 1000),
				"timeZone": "GMT+0800",
			},
			"preInitialItemVoList": pre_initial_item_vo_list,
		}
		return body

	@staticmethod
	def get_split_order_and_initiate_body(order_res, address_info, buyer_info):
		pre_initial_sub_order_vo_list = []
		for suborder in order_res:
			chosen_able_shipping_method_list = suborder.get("chosenAbleShippingMethodList")
			# chosen_able_shipping_method_list[0]["checked"] = 1
			sub_od = {
				"storeId": suborder.get("storeId"),
				"mikStoreId": "-1",
				"channelType": 2,
				"itemList": suborder.get("itemList"),
				"chosenAbleShippingMethodList": chosen_able_shipping_method_list,
				"generalShippingType": 0,
				"pickupPersons": [],
				"giftFrom": None,
				"giftMessage": None,
				"chosenGift": None,
			}
			pre_initial_sub_order_vo_list.append(sub_od)
		body = {
			"orderSource": "Default",
			"areaCode": "US",
			"couponCodes": [],
			"ackTaxExempt": True,
			"smsPreference": True,
			"shippingAddressInfo": {
				"firstName": address_info.get("firstName"),
				"lastName": address_info.get("lastName"),
				"addressLine1": address_info.get("addressLine1"),
				"addressLine2": "",
				"city": address_info.get("city"),
				"state": address_info.get("state"),
				"countryId": address_info.get("countryId"),
				"zipcode": address_info.get("zipCode"),
				"zipCode": address_info.get("zipCode"),
				"phoneNumber": address_info.get("telephone"),
				"email": buyer_info.get("email"),  #
				"sameAsShipping": True,
			},
			"preInitialSubOrderVoList": pre_initial_sub_order_vo_list,
		}
		return body

	@staticmethod
	def get_submit_order_body(initiate_data, wallet_bankcard, address_info, buyer_info):
		user = buyer_info.get("user")
		card_type = {1: "Visa", 2: "MasterCard", 3: "Amex", 4: "Discover"}
		credit_card_payment = {
			"payment": "CREDIT_CARD",
			"billingAddressInfo": {
				"firstName": wallet_bankcard.get("firstName"),
				"lastName": wallet_bankcard.get("lastName"),
				"addressLine1": wallet_bankcard.get("addressLine1"),
				"addressLine2": "",
				"city": wallet_bankcard.get("city"),
				"state": wallet_bankcard.get("state"),
				"countryId": wallet_bankcard.get("countryId"),
				"zipCode": wallet_bankcard.get("zipCode"),
				"phoneNumber": wallet_bankcard.get("telephone"),
				"email": user.get("email"),
				"sameAsShipping": True,
				"isAddressSaved": True,
				"isAllItemsPickup": False,
			},
			"cardReferenceNumber": wallet_bankcard.get("cardRefNum"),
			"cardLastFour": wallet_bankcard.get("tailNumber"),
			"expirationMonth": wallet_bankcard.get("expirationDate")[:2],
			"expirationYear": wallet_bankcard.get("expirationDate")[2:],
			"cardType": card_type[wallet_bankcard.get("cardChannelType")],
			"nameOnCard": "",
			"currency": "USD",
		}
		shipping_address_info = {
			"firstName": address_info.get("firstName"),
			"lastName": address_info.get("lastName"),
			"addressLine1": address_info.get("addressLine1"),
			"addressLine2": "",
			"city": address_info.get("city"),
			"state": address_info.get("state"),
			"countryId": address_info.get("countryId"),
			"zipcode": address_info.get("zipCode"),
			"zipCode": address_info.get("zipCode"),
			"phoneNumber": address_info.get("telephone"),
			"email": buyer_info.get("email"),
			"sameAsShipping": True,
		}
		initiate_data["shippingAddressInfo"] = shipping_address_info
		initiate_data["timeZone"] = "GMT+0800"
		initiate_data["voucherPayments"] = []
		initiate_data["creditCardPayment"] = credit_card_payment
		return initiate_data


if __name__ == '__main__':
	lib = EARequestBodyLib()
	a = lib.get_seller_order_list_body(1, status="Shipped",dateRange=[-7,1])
	print(a)
