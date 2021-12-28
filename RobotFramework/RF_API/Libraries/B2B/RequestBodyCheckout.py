import random
import uuid


class RequestBodyCheckout(object):
	def __init__(self):
		pass

	@staticmethod
	def get_ck_payment_detail_body(org_id, user_id):
		body = {
			"organizationId": org_id,
			"userId": user_id
		}
		return body

	@staticmethod
	def get_ck_tax_quotation_body(pro_info, cart_pro_info, address_info):
		product_items = []
		total_price = 0
		for item in pro_info:
			quantity = random.randint(1, 4)
			for cart_item in cart_pro_info:
				if cart_item.get("skuNumber") == item.get("skuNumber"):
					quantity = cart_item.get("quantity")

			extended_price = round(quantity * item.get("price"), 2)
			total_price += extended_price
			pro = {
				"productClass": item.get("cost").get("mikTaxCode"),
				"productId": item.get("skuNumber"),
				"quantity": quantity,
				"unitPrice": item.get("price"),
				"extendedPrice": round(quantity * item.get("price"), 2),
				"channel": 1
			}
			product_items.append(pro)
		# >49 免邮 否则 6.95
		shipping_price = 6.95 if total_price < 49 else 0
		shipping = {
			"productClass": "199",
			"productId": "shipping",
			"quantity": 1,
			"unitPrice": shipping_price,
			"extendedPrice": shipping_price,
			"channel": 4
		}
		product_items.append(shipping)
		address = address_info
		body = {
			"product_items": product_items,
			"address": {
				"city": address.get("city"),
				"state": address.get("state"),
				"country": "US",
				"streetAddress1": address.get("addressLine1"),
				"streetAddress2": address.get("addressLine2"),
				"postal_code": address.get("zipCode")
			},
			"rewardId": None
		}
		return body

	@staticmethod
	def get_ck_order_body(tax_quotation_info, cart_pro_info, address_info, payment_info):
		currentTotalPrice = 0
		currentTotalTax = 0
		currentTotalShipping = 0
		currentTotalShippingTax = 0
		tax_line_item = tax_quotation_info.get("lineItem")
		for item in tax_line_item:
			if item.get("productId") == "shipping":
				currentTotalShipping = item.get("extendedPrice")
				currentTotalShippingTax = item.get("lineItemTaxAmount")
			else:
				currentTotalPrice += item.get("extendedPrice")
				currentTotalTax += item.get("lineItemTaxAmount")
		currentTotalPrice = round(currentTotalPrice, 2)
		currentTotalTax = round(currentTotalTax, 2)
		shippingAddress = {
			"businessName": address_info.get("businessName"),
			"firstName": address_info.get("firstName"),
			"lastName": address_info.get("lastName"),
			"addressLine1": address_info.get("addressLine1"),
			"addressLine2": address_info.get("addressLine2"),
			"city": address_info.get("city"),
			"state": address_info.get("state"),
			"zipcode": address_info.get("zipCode"),
			"countryId": "US"
		}
		shipmentRequests = []
		for item in cart_pro_info:
			item_info = {
				"shoppingItemId": item.get("shoppingItemId"),
				"shippingMethod": "GROUND",
				"deliveryMethod": "USPS",
				"deliveryInstructions": "",
				"quantityToCheckout": item.get("quantity"),
				"avsResidential": "R",
				"shippingAddress": shippingAddress
			}
			shipmentRequests.append(item_info)
		bankCards = payment_info.get("bankCards").get("organizationBankCards")
		# print(bankCards)
		if bankCards is None:
			bankCards = payment_info.get("bankCards").get("privateBankCards")
		bankCard = random.choice(bankCards)
		# print(bankCards)
		paymentRequests = [{
			"currency": "USD",
			"amountCharged": tax_quotation_info.get("total"),
			"creditCard": {
				"expirationMonth": bankCard.get("expirationMonth"),
				"expirationYear": bankCard.get("expirationYear"),
				"cardReferenceNumber": bankCard.get("cardRefNum"),
				"cardLastFour": bankCard.get("tailNumber")
			},
			"billingAddress": {
				"firstName": bankCard.get("firstName"),
				"lastName": bankCard.get("lastName"),
				"addressLine1": bankCard.get("addressLine1"),
				"addressLine2": bankCard.get("addressLine2"),
				"city": bankCard.get("city"),
				"state": bankCard.get("state"),
				"countryId": bankCard.get("countryId"),
				"zipcode": bankCard.get("zipCode")
			}
		}]

		body = {
			"currentTotalPrice": str(currentTotalPrice),
			"currentTotalTax": str(currentTotalTax),
			"currentTotalShipping": str(currentTotalShipping),
			"currentTotalShippingTax": str(currentTotalShippingTax),
			"channel": "B2B",
			"shipmentRequests": shipmentRequests,
			"paymentRequests": paymentRequests,
			"customOrderNumber": "AutoTest{}".format(str(uuid.uuid1()).split("-")[0]),
			"budgetIds": [],
			"ackTaxExempt": False
		}
		return body

	@staticmethod
	def get_ck_order_requests_body(tax_quotation_info, cart_pro_info, address_info, payment_info):
		currentTotalPrice = 0
		currentTotalTax = 0
		currentTotalShipping = 0
		currentTotalShippingTax = 0
		tax_line_item = tax_quotation_info.get("lineItem")
		for item in tax_line_item:
			if item.get("productId") == "shipping":
				currentTotalShipping = item.get("extendedPrice")
				currentTotalShippingTax = item.get("lineItemTaxAmount")
			else:
				currentTotalPrice += item.get("extendedPrice")
				currentTotalTax += item.get("lineItemTaxAmount")
		currentTotalPrice = round(currentTotalPrice, 2)
		currentTotalTax = round(currentTotalTax, 2)
		shippingAddress = {
			"businessName": address_info.get("businessName"),
			"firstName": address_info.get("firstName"),
			"lastName": address_info.get("lastName"),
			"addressLine1": address_info.get("addressLine1"),
			"addressLine2": address_info.get("addressLine2"),
			"city": address_info.get("city"),
			"state": address_info.get("state"),
			"zipcode": address_info.get("zipCode"),
			"countryId": "US"
		}
		shipmentRequest = {
			"shippingMethod": "GROUND",
			"deliveryMethod": "USPS",
			"deliveryInstructions": "",
			"avsResidential": "R",
			"shippingAddress": shippingAddress
		}
		bankCards = payment_info.get("bankCards").get("organizationBankCards")
		if bankCards is None:
			bankCards = payment_info.get("bankCards").get("privateBankCards")
		bankCard = random.choice(bankCards)
		paymentRequests = [{
			"currency": "USD",
			"amountCharged": tax_quotation_info.get("total"),
			"paymentMethodId": bankCard.get("bankCardId"),
			"paymentMethodType": "BANK_CARD"
		}]
		shoppingItems = []
		for item in cart_pro_info:
			shoppingItem = {
				"skuNumber": item.get("skuNumber"),
				"quantity": item.get("quantity"),
				"shoppingItemId": item.get("shoppingItemId")
			}
			shoppingCartId = item.get("shoppingCartId")
			shoppingItems.append(shoppingItem)
		body = {
			"cartId": shoppingCartId,
			"currentTotalPrice": str(currentTotalPrice),
			"currentTotalTax": str(currentTotalTax),
			"currentTotalShipping": str(currentTotalShipping),
			"currentTotalShippingTax": str(currentTotalShippingTax),
			"channel": "B2B",
			"shoppingItems":shoppingItems,
			"shipmentRequest": shipmentRequest,
			"paymentRequests": paymentRequests,
			"customOrderNumber": "AutoTest{}".format(str(uuid.uuid1()).split("-")[0]),
			"budgetIds": [],
			"ackTaxExempt": False
		}
		return body
