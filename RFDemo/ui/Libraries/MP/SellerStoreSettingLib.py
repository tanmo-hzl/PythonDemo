import datetime
import os
import random
import uuid


class SellerStoreSettingLib(object):

	def __init__(self):
		self.address_list = [['12201', 'Albany', 'NY'],
		                     ['30301', 'Atlanta', 'GA'],
		                     ['21401', 'Annapolis', 'MD'],
		                     ['21201', 'Baltimore', 'MD'],
		                     ['35201', 'Birmingham', 'AL'],
		                     ['14201', 'Buffalo', 'NY']]
		self.holidays_list = ["New Years Day", "Martin Luther King Jr. Day", "Presidents' day", "Memorial Day",
		                      "Independence Day", "Labor Day", "Columbus Day", "Veterans Day", "Thanksgiving Day", "Christmas Day"]

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

	def get_address_info(self):
		address = random.choice(self.address_list)
		address_info = {
			"address1": "{} Load".format(random.randint(100, 999)),
			"address2": "{} Load".format(random.randint(10, 99)),
			"city": address[1],
			"state": address[2],
			"zipcode": address[0]
		}
		print(address_info)
		return address_info

	@staticmethod
	def get_primary_contact():
		primary_info = {
			"start1": ["08", str(random.randint(10, 20)), "AM"],
			"end1": ["09", str(random.randint(50, 59)), "PM"],
			"start2": ["08", str(random.randint(50, 59)), "AM"],
			"end2": ["10", str(random.randint(10, 20)), "PM"]
		}
		print(primary_info)
		return primary_info

	def get_fulfillment_info(self):
		uu_code = "".join(str(uuid.uuid1()).split("-"))
		address = random.choice(self.address_list)
		fulfillment_info = {
			"address1": "{} Load".format(random.randint(100, 999)),
			"address2": "{} Load".format(random.randint(10, 99)),
			"city": address[1],
			"state": address[2],
			"zipcode": address[0],
			"name": "Fulfillment {}".format(uu_code[:9]),
			"start1": ["08", "00", "AM"],
			"end1": ["08", "00", "PM"],
			"start2": ["09", "00", "AM"],
			"end2": ["10", "00", "PM"],
			"holiday1": {"name": random.choice(self.holidays_list),
			             "startDate": (datetime.datetime.now() + datetime.timedelta(days=3)).strftime("%Y-%m-%d"),
			             "endDate": (datetime.datetime.now() + datetime.timedelta(days=7)).strftime("%Y-%m-%d")},
			"holiday2": {"name": random.choice(self.holidays_list),
			             "startDate": (datetime.datetime.now() + datetime.timedelta(days=9)).strftime("%Y-%m-%d"),
			             "endDate": (datetime.datetime.now() + datetime.timedelta(days=12)).strftime("%Y-%m-%d")}
		}
		print(fulfillment_info)
		return fulfillment_info

	@staticmethod
	def get_shipping_rate_info():
		shipping_rate = {
			"Standard": ["{}.{}".format(random.randint(2, 3), random.randint(10, 99)),
			             "{}.{}".format(random.randint(29, 39), random.randint(10, 99)),
			             "{}.{}".format(random.randint(4, 6), random.randint(10, 99)),
			             "{}.{}".format(random.randint(40, 49), random.randint(10, 99)),
			             "{}.{}".format(random.randint(0, 1), random.randint(10, 99))],
			"Expedited": ["{}.{}".format(random.randint(3, 6), random.randint(10, 99)),
			              "{}.{}".format(random.randint(6, 9), random.randint(10, 99)),
			              "{}.{}".format(random.randint(0, 1), random.randint(10, 99))]
		}
		print(shipping_rate)
		return shipping_rate


if __name__ == '__main__':
	s = SellerStoreSettingLib()
	s.get_address_info()
	s.get_fulfillment_info()
	s.get_shipping_rate_info()

