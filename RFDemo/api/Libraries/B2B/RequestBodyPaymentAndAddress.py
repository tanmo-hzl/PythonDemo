import datetime
import random
import re
import uuid

import execjs
import requests


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

	def get_create_payment_option_body(self, card_number, cvv):
		pie_key = self.encryption_card(card_number, cvv)
		body = {
			"bankCardNickName": "Payment Option {}".format(str(uuid.uuid1()).split("-")[0]),
			"cardHolderName": "Beijing",
			"cardNumber": pie_key.get("encrypted_card"),
			"expirationDate": f'{"%02d" % random.randint(1,12)}{"%02d" % random.randint(25,50)}',
			"securityCode": pie_key.get("encrypted_cvv"),
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
			"pieKeyId": pie_key.get("key_id"),
			"piePhaseId": pie_key.get("phase"),
			"pieIntegrityCheck": pie_key.get("integrity_check")
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

	@staticmethod
	def encryption_card(card_number: str, cvv: str):
		HOST = "https://safetechpageencryptionvar.chasepaymentech.com"
		Subscriber_ID = "100000000281"
		PIE_Format = "04"
		html = requests.request(
			method="GET",
			url=f'{HOST}/pie/v1/{PIE_Format}{Subscriber_ID}/getkey.js')
		js_script = requests.request(
			method="GET", url=f"{HOST}/pie/v1/encryption.js"
		)
		ctx = execjs.compile(js_script.text + html.text)
		func_result = ctx.call("ProtectPANandCVV", card_number, cvv, True)
		re_result = re.findall(r"PIE\.(.*)\s=\s(.*);", html.text)
		result = {
			"encrypted_card": func_result[0],
			"encrypted_cvv": func_result[1],
			"key_id": str(dict(re_result)["key_id"]).replace('"', ""),
			"phase": str(dict(re_result)["phase"]).replace('"', ""),
		}
		if len(func_result) > 2:
			result["integrity_check"] = func_result[2]
		return result


if __name__ == '__main__':
	print(datetime.datetime.now().year)