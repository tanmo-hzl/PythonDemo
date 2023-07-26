import datetime
import json
import os
import random


class BuyerReturnLib(object):
	def __init__(self):
		self.buyer_reason_list = ['Changed Mind', "Purchased By Mistake", "No Longer Needed"]
		self.reason_list = ['Not as Described', 'Missing Parts or Accessories', 'No Longer Needed', 'Wrong Item Was Sent', 'Changed Mind', 'Item Does Not Work', 'Item Was Damaged', 'Purchased by Mistake', 'Did Not Receive This Item']
		self.reason_item = {'Not as Described': ['New', 'Damaged'], 'Missing Parts or Accessories': ['New', 'Damaged'], 'No Longer Needed': ['New', 'Damaged'], 'Wrong Item Was Sent': ['New', 'Damaged'], 'Changed Mind': ['New', 'Damaged'], 'Item Does Not Work': ['Damaged'], 'Item Was Damaged': ['Damaged'], 'Purchased by Mistake': ['New', 'Damaged'], 'Did Not Receive This Item': ['New']}
		self.need_photos = ['Item Was Damaged', 'Item Does Not Work', 'Not as Described', 'Missing Parts or Accessories']

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

	def get_return_reason_info(self, items_name, items_price, items_quantity):
		print(items_name, items_price, items_quantity)
		item_list = []
		for i in range(len(items_name)):
			price = items_price[i].split(" ")
			print(price)
			item = {
				"name": items_name[i],
				"total": round(int(items_quantity[i]) * float(price[0][1:]), 2),
				"quantity": items_quantity[i],
				"price": price[0][1:]
			}
			item_list.append(item)
		reasons = []
		reason_values = []
		if len(self.reason_list) <= len(item_list):
			reason_values = random.sample(self.reason_list, len(item_list))
		else:
			for i in range(len(item_list)):
				reason_values.append(random.choice(self.reason_list))
		for i in range(len(reason_values)):
			item = reason_values[i]
			condition = random.choice(self.reason_item[item])
			if item in self.need_photos:
				photoPath = self.get_random_img_path()
			else:
				photoPath = None
			quantity = 2 if int(item_list[i].get("quantity")) > 3 else int(item_list[i].get("quantity"))
			reason = {
				"reason_value": item,
				"condition": None if condition == "Notes" else condition,
				"notes": "Test UI {}, {}".format(item, datetime.datetime.now()),
				"photos": photoPath,
				"quantity": quantity,
				"maxQuantity": int(item_list[i].get("quantity")),
				"returnTotal": round(quantity * float(item_list[i].get("price")), 2),
				"name": item_list[i].get("name")
			}
			reasons.append(reason)
		print(reasons)
		return reasons

	def get_shipped_order_numbers(self, returnable_order_number=None, env='tst03',
	                              file_shipped="orders_shipped.json", file_returns="orders_seller_returns.json", file_dir="MP"):
		if file_dir is not None:
			file_shipped_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_shipped)
			file_returns_path = os.path.join(self.__get_root_path(), "CaseData", "{}-{}".format(file_dir.upper(), env.upper()), file_returns)
		else:
			file_shipped_path = os.path.join(self.__get_root_path(), "CaseData", file_shipped)
			file_returns_path = os.path.join(self.__get_root_path(), "CaseData", file_returns)
		with open(file_shipped_path, "r") as f:
			data_shipped = json.load(f).get("data")

		order_returns = []
		if os.path.exists(file_returns_path):
			with open(file_returns_path, "r") as f:
				data_returns = json.load(f).get("data")

			for item in data_returns:
				if item.get("status") != 19000:
					order_returns.append(item.get("orderNumber")[3:-2])

		order_numbers = []
		for item in data_shipped:
			order = item[3:-2]
			if order not in order_returns:
				order_numbers.append(order)

		if returnable_order_number is not None and returnable_order_number in order_numbers:
			index = order_numbers.index(returnable_order_number)
			order_numbers = order_numbers[index+1:]

		print(order_numbers)
		return order_numbers

	@staticmethod
	def get_shipping_and_completed_order(order_list):
		need_orders = []
		statusStrings = []
		for item in order_list:
			statusString = item.get("statusString")
			if statusString not in statusStrings:
				statusStrings.append(statusString)
			if statusString in ("Shipping","Complete"):
				need_orders.append(item.get("parentOrderNumber"))
		random.shuffle(need_orders)
		print("statusStrings=", statusStrings)
		print(need_orders)
		return need_orders

	def get_create_return_order_body(self, order_detail, partial_item_return=False, partial_quantity_return=False,
	                                 need_buyer_reason=False, channel=2):
		try:
			subReturnOrders = []
			subOrders = order_detail.get("subOrders")
			for order in subOrders:
				orderLines = order.get("orderLines")
				if order.get("channel") != int(channel):
					continue
				returnOrderLines = []
				buyer_reason_flag = False
				for line in orderLines:
					if line.get("returnAvailableQuantity") > 0:
						seller_reason = list(set(self.reason_list) - set(self.buyer_reason_list))
						if need_buyer_reason and not buyer_reason_flag:
							afterSalesReason = random.choice(self.buyer_reason_list)
							buyer_reason_flag = True
						else:
							afterSalesReason = random.choice(seller_reason)

						itemCondition = random.choice(self.reason_item.get(afterSalesReason))
						userUploadMedia = []
						if afterSalesReason in self.need_photos:
							userUploadMedia.append(line.get("thumbnail"))
						if partial_quantity_return:
							quantity = 1
						else:
							quantity = line.get("returnAvailableQuantity")
						returnOrderLine = {
							"orderItemId": line.get("orderItemId"),
							"quantity": quantity,
							"afterSalesReason": afterSalesReason,
							"externalId": "",
							"bookingIdList": [],
							"afterSalesComment": "Test API {}, {}".format(afterSalesReason, datetime.datetime.now()),
							"userUploadMedia": userUploadMedia,
							"itemCondition": itemCondition
						}
						returnOrderLines.append(returnOrderLine)
						if partial_item_return:
							break
				address = {
					"firstName": order.get("firstName"),
					"lastName": order.get("lastName"),
					"phone": order.get("phone"),
					"country": order.get("country"),
					"state": order.get("state"),
					"city": order.get("city"),
					"zipCode": order.get("zipCode"),
					"address1": order.get("address1"),
					"address2": order.get("address2")
				}
				subReturnOrder = {
					"orderNumber": order.get("orderNumber"),
					"shippingLabelsExpected": 1,
					"channel": order.get("channel"),
					"address": address,
					"returnOrderLines": returnOrderLines
				}
				subReturnOrders.append(subReturnOrder)

			body = {
				"parentOrderNumber": order_detail.get("parentOrderNumber"),
				"disputeType": 0,
				"customerEmail": order_detail.get("customerEmail"),
				"subReturnOrders": subReturnOrders
			}
			print(body)
			return body
		except Exception as e:
			print(e)
			print(order_detail)
			return None


if __name__ == '__main__':
	r = BuyerReturnLib()
	with open("test.txt", "r") as f:
		d = json.load(f)
	a = r.get_create_return_order_body(d.get("data"))




