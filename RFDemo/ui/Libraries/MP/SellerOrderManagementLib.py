import random


class SellerOrderManagementLib(object):
	def __init__(self):
		self.status_list = ["Pending Confirmation", "Ready to Ship", "Partially Shipped", "Shipped",
		                    "Partially Delivered", "Delivered", "Cancelled", "Completed"]

	def get_order_status_by_number(self, quantity=1):
		if quantity <= 1:
			return random.sample(self.status_list, 1)
		if quantity > len(self.status_list):
			return self.status_list
		else:
			return random.sample(self.status_list, int(quantity))
