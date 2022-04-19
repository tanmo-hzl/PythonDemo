import random
import uuid


class BuyerAccountInfoLib(object):
	def __init__(self):
		self.cardList = ["4112344112344113", "4110144110144115", "5111005111051128", "3566003566003566"]
		self.address_list = [['12201', 'Albany', 'NY'],
		                     ['30301', 'Atlanta', 'GA'],
		                     ['21401', 'Annapolis', 'MD'],
		                     ['21201', 'Baltimore', 'MD'],
		                     ['35201', 'Birmingham', 'AL'],
		                     ['14201', 'Buffalo', 'NY'],
		                     ['99501', 'ANCHORAGE', 'AK']]

	def get_address_info(self):
		address = random.choice(self.address_list)
		body = {
			"firstName": "",
			"lastName": "Auto",
			"address1": "{} AD ROAD".format(random.randint(10, 99)),
			"address2": "{} AD ROAD".format(random.randint(100, 999)),
			"city": address[1],
			"state": address[2],
			"zipcode": address[0],
			"phone": "666777{}".format(random.randint(1000, 9999))
		}
		return body

	def get_card_info(self, is_new=True):
		address = random.choice(self.address_list)
		randomCode = "".join(str(uuid.uuid1()).split("-"))[0:9]
		body = {
			"card": {
				"cardName": "Card " + randomCode,
				"nickName": "Nick " + randomCode,
				"cardNumber": random.choice(self.cardList) if is_new else "",
				"expirationDate": "0{}{}".format(random.randint(1, 9), random.randint(26, 35)),
				"cvv": random.randint(100, 999) if is_new else ""
			},
			"default": True,
			"address": {
				"firstName": "",
				"lastName": "Auto",
				"address1": "{} AD ROAD".format(random.randint(10, 99)),
				"address2": "{} AD ROAD".format(random.randint(100, 999)),
				"city": address[1],
				"state": address[2],
				"zipcode": address[0],
				"phone": "666777{}".format(random.randint(1000, 9999))
			}
		}
		return body


if __name__ == '__main__':
	a = BuyerAccountInfoLib()
	print(a.get_card_info(False))

