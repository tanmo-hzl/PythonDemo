import random
import time


class EARequestBodyLib(object):
	def __init__(self):
		self.order_status_list = ["Pending Confirmation", "Ready to Ship", "Partially Shipped", "Shipped",
		                          "Partially Delivered", "Delivered", "Cancelled", "Completed"]
		self.order_status_values = [3000, 3500, 6800, 7000, 7300, 7500, 9000, 10000, 9700]
		self.return_status_list = ["Pending Return", "Refund Rejected", "Returned", "Return Canceled", "Pending Refund"]
		self.return_status_values = [[11000, 10500, 17000], 19100, 18000, 19000, 16000]
		self.dispute_status_list = ["Dispute Opened", "Dispute In Process", "Offer Made", "Offer Rejected",
		                            "Dispute Resolved", "Dispute Escalated", "Escalation Under Review",
		                            "Dispute Canceled"]
		self.dispute_status_values = [30000, 30100, 31000, 31100, 34000, 32000, 32100, 35000]

	def get_seller_order_list_body(self, data_type=1, search_status=None, date_range=None):
		"""

		:param data_type:  1-order management;2-return order;3-dispute order
		:param search_status:
		:param date_range:
		:return:
		"""
		if date_range is None:
			date_range = [0, 0]
		if data_type == 1:
			status = self.order_status_list
			values = self.order_status_values
		elif data_type == 2:
			status = self.return_status_list
			values = self.return_status_values
		else:
			status = self.dispute_status_list
			values = self.dispute_status_values
		value = ""
		if search_status is not None:
			for i in range(len(status)):
				if status[i] == search_status:
					value = values[i]
		if type(value) is list:
			value = ",".join(value)

		body = {"channels": 2,
		        "type": data_type,
		        "pageNum": 1,
		        "pageSize": 100,
		        "isAsc": False,
		        "dateStatusAggregate": True,
		        "isAlone": True,
		        "timeBase": int(time.time() * 1000)
		        }
		if data_type == 1:
			body["ignoreBuyerCancel"] = True
		if value != "":
			body["statuses"] = value
		if int(date_range[0]) != 0:
			body["startTime"] = int((time.time() + 24 * 60 * 60 * int(date_range[0])) * 1000)
			body["endTime"] = int((time.time() + 24 * 60 * 60 * int(date_range[1])) * 1000)
		return body

	@staticmethod
	def get_listing_info_by_status_and_variants(listings, status, have_variants=False, variationsNum=None):
		qualified_listings = []
		for item in listings:
			if item.get("status") == status and item.get("media") is not None:
				if not have_variants and item.get("variationsNum") == 0:
					qualified_listings.append(item)
				if have_variants:
					if variationsNum is None and item.get("variationsNum") > 0:
						qualified_listings.append(item)
					if variationsNum is not None and int(variationsNum) == item.get("variationsNum"):
						qualified_listings.append(item)
		return random.choice(qualified_listings)

	@staticmethod
	def get_listing_url_by_quantity_status_and_variants(listings, quantity, status, have_variants=None):
		qualified_listings = []
		for item in listings:
			if item.get("status") == status:
				if have_variants is None:
					qualified_listings.append(item)
				else:
					if not have_variants and item.get("variationsNum") == 0:
						qualified_listings.append(item)
					if have_variants and item.get("variationsNum") > 0:
						qualified_listings.append(item)
		qualified_listings = random.sample(qualified_listings, int(quantity))
		listing_urls = []
		for item in qualified_listings:
			url = "{}-{}".format(item.get("itemName").replace(" ", "-").replace("--", "-").lower(), item.get("sku"))
			listing_urls.append(url)
		return listing_urls


if __name__ == '__main__':
	print(int(time.time() * 1000))
