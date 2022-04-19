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

	def get_card_detail_info(self, virtual_address=False):
		uuCode = str(uuid.uuid1()).split("-")[0]
		cardNumber = random.choice(self.cardList)
		body = {
			"cardHolderName": "Card {}".format(uuCode),
			"bankCardNickName": "Nick {}".format(uuCode),
			"expirationDate": "0{}{}".format(random.randint(1, 9), random.randint(26, 33)),
			"addressLine1": "{} SANDRO RD".format(random.randint(1000, 9999)) if virtual_address else "2317 Margaret St",
			"addressLine2": "{} SANDRO RD".format(random.randint(100, 999)) if virtual_address else "",
			"zipCode": "55438-1229" if virtual_address else "77093",
			"city": "MINNEAPOLIS" if virtual_address else "Houston",
			"state": "MN" if virtual_address else "TX",
			"firstName": "Test",
			"lastName": "Auto",
			"phoneNumber": "3318{}996".format(random.randint(100, 999)),
			"cardNumber": cardNumber,
			"endNumber": cardNumber[-4:],
			"cvv": "{}".format(random.randint(100, 999))
		}
		print("card_detail=", body)
		return body

	@staticmethod
	def format_prices(prices, split_by=","):
		if type(prices) is float or int:
			temp_prices = prices.split(".")
			integer_part = temp_prices[0]
			if len(temp_prices) > 1:
				fractional_part = temp_prices[1].ljust(2, "0")
			else:
				fractional_part = "00"
			index = 0
			temp_integer_part = []
			for i in range(len(integer_part)-1, -1, -1):
				temp_integer_part.append(integer_part[i])
				index += 1
				if index == 3 and i != 0:
					temp_integer_part.append(split_by)
					index = 0
			temp_integer_part.reverse()
			f_prices = "".join(temp_integer_part)+"."+fractional_part
			return f_prices
		else:
			return prices


if __name__ == '__main__':
	f = SellerFinanceLib()

	s = f.format_prices("16122323.23")
	print(s)

