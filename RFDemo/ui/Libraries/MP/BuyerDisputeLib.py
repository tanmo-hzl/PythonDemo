import datetime
import json
import os
import random


class BuyerDisputeLib(object):
	def __init__(self):
		self.reason_list = ['Changed Mind', 'Not as Described', 'Did Not Receive This Item', 'Item Was Damaged', 'Item Does Not Work', 'Wrong Item Was Sent', 'Missing Parts or Accessories', 'Unacceptable Offer', 'Others']
		self.need_photo_reasons = ['Not as Described', 'Item Was Damaged', 'Item Does Not Work', 'Missing Parts or Accessories']

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

	def get_dispute_reason(self, items_count=1):
		reason = random.sample(self.reason_list, items_count)
		body = []
		for i in range(items_count):
			body.append({
				"reason": reason[i],
				"notes": "Test {}, {}.".format(reason[i], datetime.datetime.now()),
				"photo": self.get_random_img_path() if reason[i] in self.need_photo_reasons else None
			})
		print(body)
		return body

	def get_disputable_order_ids(self, able_order_id=None, env='tst03',
	                             file_rejected="orders_refund_rejected.json",
	                             file_disputes="orders_seller_disputes.json", file_dir="MP"):
		if file_dir is not None:
			file_rejected_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_rejected)
			file_disputes_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_disputes)
		else:
			file_rejected_path = os.path.join(self.__get_root_path(), "CaseData", file_rejected)
			file_disputes_path = os.path.join(self.__get_root_path(), "CaseData", file_disputes)
		with open(file_rejected_path, "r") as f:
			data_rejected = json.load(f).get("data")

		order_disputes = []
		if os.path.exists(file_disputes_path):
			with open(file_disputes_path, "r") as f:
				data_disputes = json.load(f).get("data")

			for item in data_disputes:
				order_disputes.append(item.get("orderNumber"))

		return_ids = []
		for item in data_rejected:
			if item.get("orderNumber") not in order_disputes:
				return_ids.append(item.get("returnId"))

		if able_order_id is not None and able_order_id in return_ids:
			index = return_ids.index(able_order_id)
			return_ids = return_ids[index+1:]

		print(return_ids)
		return return_ids

	@staticmethod
	def get_escalate_info():
		contact = random.choice(["Phone", "Email"])
		phone = "333567{}".format(random.randint(1000, 9999))
		body = {
			"reason": "Test Escalate, {}".format(datetime.datetime.now()),
			"contact": contact,
			"phone": phone
		}
		print(body)
		return body

	@staticmethod
	def get_cancel_info():
		reasons = ["Item Received", "Seller Refunded", "Tracking Info Provided", "Replacement Item Received", "Other"]
		body = {
			"reason": random.choice(reasons),
			"notes": "Test Cancel, {}".format(datetime.datetime.now())
		}
		return body

	def get_offer_made_order_ids(self, able_order_id=None, env='tst03', file_name="orders_seller_offer_made.json", file_dir="MP"):
		if file_dir is not None:
			file_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_name)
		else:
			file_path = os.path.join(self.__get_root_path(), "CaseData", file_name)
		with open(file_path, "r") as f:
			data = json.load(f).get("data")
		return_ids = []

		for item in data:
			return_ids.append(item.get("orderNumber")[3:-2])

		if able_order_id is not None and able_order_id in return_ids:
			index = return_ids.index(able_order_id)
			return_ids = return_ids[index+1:]

		print(return_ids)
		return return_ids

	def get_cancellable_order_ids(self, able_order_id=None, env='tst03', file_name="orders_seller_disputes.json", file_dir="MP"):
		if file_dir is not None:
			file_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_name)
		else:
			file_path = os.path.join(self.__get_root_path(), "CaseData", file_name)
		with open(file_path, "r") as f:
			data = json.load(f).get("data")
		return_ids = []

		for item in data:
			if item.get("status") not in ("Dispute Resolved","Dispute Canceled"):
				return_ids.append(item.get("orderNumber")[3:-2])

		if able_order_id is not None and able_order_id in return_ids:
			index = return_ids.index(able_order_id)
			return_ids = return_ids[index+1:]

		print(return_ids)
		return return_ids


if __name__ == '__main__':
	b = BuyerDisputeLib()
	b.get_dispute_reason(2)
