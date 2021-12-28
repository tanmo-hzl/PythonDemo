
import random
import uuid
import os


class ListingLib(object):
	def __init__(self):
		self.root_path = self.__get_root_path()

	@staticmethod
	def __get_root_path():
		abspath = os.path.dirname(os.path.abspath(__file__))
		root_path = os.path.dirname(os.path.dirname(abspath))
		return root_path

	@staticmethod
	def get_random_data():
		return str(uuid.uuid1()).split("-")[0]

	def get_random_img_path(self):
		img_dir_path = os.path.join(self.root_path, "CaseData", "MP", "Img")
		img_list = os.listdir(img_dir_path)
		img_path = os.path.join(img_dir_path, random.choice(img_list))
		print(img_path)
		return img_path


if __name__ == '__main__':
	lib = ListingLib()
	lib.get_random_img_path()
	d = """Open
Awaits
Pending Confirmation
Ready to Ship
Partial Shipped
Shipped
Partial Delivered
Delivered
Partially Pending Return
Return Requested
Return Refund
Partial Refund
Cancelled
Partially Completed
Completed"""
	tt = d.split("\n")
	dd = ",".join(tt)
	print(dd)
