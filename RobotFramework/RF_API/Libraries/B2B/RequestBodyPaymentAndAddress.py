import random
import uuid
import datetime


class RequestBodyPaymentAndAddress(object):
	def __init__(self):
		self.cardList = ["0545618485274113", " 4110144110144115 ", "4114360123456785"]

	@staticmethod
	def get_payment_methods_body(org_id, user_id):
		body = {
			"organizationId": org_id,
			"userId": user_id
		}
		return body

	@staticmethod
	def get_random_code(need_number=True):
		if need_number:
			letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		else:
			letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		randomId = random.sample(letter, random.randint(3, 9))
		print("".join(randomId))
		return "".join(randomId)

	def get_create_payment_option_body(self, pie_info, is_new_card=True):
		month = random.randint(1, 12)
		if month < 10:
			month = "0{}".format(month)
		body = {
			"bankCardNickName": "Payment Option {}".format(str(uuid.uuid1()).split("-")[0]),
			"cardHolderName": "Beijing",
			"cardNumber": random.choice(self.cardList),
			"expirationDate": "{}{}".format(month, random.randint(22, 50)),
			"securityCode": "{}{}".format(random.randint(0, 9), random.randint(10, 99)),
			"isDefault": False,
			"cardBrandType": "VI",
			"billingAddress": {
				"firstName": "kvwa",
				"lastName": "Auto",
				"addressLine1": "555 Lexington Ave",
				"addressLine2": "",
				"city": "New York",
				"state": "AZ",
				"zipCode": "10022",
				"telephone": "3333333333",
				"countryId": "US"
			},
			"pieKeyId": "be5ac793",
			"piePhaseId": "0",
			"pieIntegrityCheck": "d1f7e3afcd9b554b"
		}
		return body

	@staticmethod
	def get_update_payment_option_body(payment_info):
		uu = str(uuid.uuid1()).split("-")[0]
		month = random.randint(1, 12)
		if month < 10:
			month = "0{}".format(month)
		now_year = datetime.datetime.now().year
		year = int(str(now_year)[2:])+1
		bankCard = payment_info.get("bankCard")
		paymentMethodAccessList = payment_info.get("paymentMethodAccessList")
		paymentMethodAccesses = []
		for item in paymentMethodAccessList:
			paymentMethodAccesses.append({
				"hasAccess": False,
				"paymentMethodAccessId": item.get("organizationPaymentMethodAccessId")
			})
		body = {
			"bankCardNickName": "Payment {}".format(uu),
			"cardHolderName": "Beijing",
			"expirationDate": "{}{}".format(month, year),
			"isDefault": False,
			"billingAddress": {
				"firstName": bankCard.get("firstName"),
				"lastName": bankCard.get("lastName"),
				"addressLine1": bankCard.get("lastName"),
				"addressLine2": "",
				"city": bankCard.get("city"),
				"state": bankCard.get("state"),
				"zipCode": bankCard.get("zipCode"),
				"telephone": "333{}{}".format(random.randint(100, 999), random.randint(1000,9999)),
				"countryId": "US"
			},
			"paymentMethodAccesses": paymentMethodAccesses
		}
		return body

	def get_create_address_body(self, org_id, user_id):
		uu = str(uuid.uuid1()).split("-")[0]
		body = {
			"businessName": "Address {}".format(uu),
			"firstName": self.get_random_code(False).upper(),
			"lastName": "Auto",
			"addressLine1": "{} Lexington Ave".format(random.randint(1, 9999)),
			"addressLine2": "",
			"city": "New York",
			"state": "NY",
			"zipCode": "10022",
			"telephone": "333{}{}".format(random.randint(100, 999), random.randint(1000, 9999)),
			"addressType": "SHIPPING",
			"countryId": "US",
			"createdBy": user_id,
			"updatedBy": user_id,
			"isCommercial": False,
			"isActive": True,
			"isVerified": False,
			"organizationIdAndAccessList": [{
				"organizationId": org_id,
				"hasAccess": True
			}]
		}
		return body

	@staticmethod
	def get_update_address_body(body):
		uu = str(uuid.uuid1()).split("-")[0]
		body["businessName"] = "Address {}".format(uu)
		return body


if __name__ == '__main__':
	print(datetime.datetime.now().year)
