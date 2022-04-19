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

	@staticmethod
	def check_order_item_actions_by_order_detail(order_detail):
		"""
		check that Ship Item or Cancel Item display on order detail page
		:param order_detail:
		:return:
		"""
		orderLines = order_detail.get("orderLines")
		actions_flag = False
		for item in orderLines:
			if item.get("status") == 3500:
				actions_flag = True
				break
		return actions_flag

	@staticmethod
	def check_order_detail_items_price(order_items):
		items = order_items.get("items")
		itemTotal = 0
		for item in items:
			quantity = int(item.get("quantity"))
			cost = float(item.get("cost")[1:].replace(",", ""))
			itemSubTotal = float(item.get("subtotal")[1:].replace(",", ""))
			itemTotal += itemSubTotal
			assert round(quantity*cost, 2) == round(itemSubTotal, 2), "item quantity({}) * cost({}) != itemSubTotal({})".format(quantity, cost, itemSubTotal)

		orderItemTotal = float(order_items.get("subtotal")[1:].replace(",", ""))
		assert round(itemTotal, 2) == round(orderItemTotal, 2), "itemTotal({})!=orderItemTotal({})".format(itemTotal, orderItemTotal)
		shipping_rate = float(order_items.get("shipping_rate")[1:].replace(",", ""))
		discounts_total = float(order_items.get("discounts_total")[2:].replace(",", ""))
		tax = float(order_items.get("tax")[1:].replace(",", ""))
		orderTotal = float(order_items.get("total")[1:].replace(",", ""))
		assert round(orderItemTotal+shipping_rate-discounts_total+tax, 2) == round(orderTotal, 2), "Sum of item and other prices != order total"


if __name__ == '__main__':
	print(round(12.222,2))


