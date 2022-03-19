import os
import random
import string
import uuid


class SellerFinanceLib(object):
	def __init__(self):
		self.cardList = ["4112344112344113", "4110144110144115", "5111005111051128", "3566003566003566"]

	@staticmethod
	def __get_root_path():
		abspath = os.path.dirname(os.path.abspath(__file__))
		root_path = os.path.dirname(os.path.dirname(abspath))
		return root_path

	def get_random_img_path(self):
		img_dir_path = os.path.join(self.__get_root_path(), "CaseData", "MP", "IMG")
		img_list = os.listdir(img_dir_path)
		img_path = os.path.join(img_dir_path, random.choice(img_list))
		print(img_path)
		return img_path

	@staticmethod
	def get_bank_detail_info():
		endNumber = random.randint(1000, 9999)
		uuCode = "".join(str(uuid.uuid1()).split("-"))[:9]
		s = string.ascii_letters
		bankName = "Bank " + "".join(random.sample(s, 5)).upper()
		body = {
			"accountNumber": "1080999{}".format(endNumber),
			"endAccountNumber": "{}".format(endNumber),
			"routingNumber": "{}".format(random.randint(100000000, 999999999)),
			"bankName": bankName,
			"firstName": "",
			"lastName": "Auto",
			"businessName": "Business {}".format(uuCode),
			"bankAccountType": random.randint(0, 1),
			"addressLineOne": "555 AD ROAD",
			"city": "New York",
			"state": "NY",
			"zipCode": "10022"
		}
		print("bank_detail=", body)
		return body

	def get_card_detail_info(self):
		uuCode = str(uuid.uuid1()).split("-")[0]
		cardNumber = random.choice(self.cardList)
		body = {
			"cardHolderName": "Card {}".format(uuCode),
			"bankCardNickName": "Nick {}".format(uuCode),
			"expirationDate": "0{}{}".format(random.randint(1, 9), random.randint(26, 33)),
			"addressLine1": "{} SANDRO RD".format(random.randint(1000, 9999)),
			"addressLine2": "{} SANDRO RD".format(random.randint(100, 999)),
			"zipCode": "55438-1229",
			"city": "MINNEAPOLIS",
			"state": "MN",
			"firstName": "Test",
			"lastName": "Auto",
			"phoneNumber": "3318{}996".format(random.randint(100,999)),
			"cardNumber": cardNumber,
			"endNumber": cardNumber[-4:],
			"cvv": "{}".format(random.randint(100, 999))
		}
		print("card_detail=", body)
		return body


if __name__ == '__main__':
	f = SellerFinanceLib()
	print(f.get_bank_detail_info())
