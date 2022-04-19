import datetime
import json
import random


class SellerReturnLib(object):
	def __init__(self):
		self.buyer_reason_list = ['Changed Mind', "Purchased By Mistake", "No Longer Needed"]
		self.return_status_list = ["Pending Return", "Refund Rejected", "Returned", "Return Canceled", "Pending Refund"]
		self.return_duration_list = ["All Time", "Today", "Yesterday", "Past 7 Days", "Past 30 Days", "Past 6 Month"]

	def get_return_status_by_number(self, number):
		if int(number) <= 1:
			return random.sample(self.return_status_list, 1)
		if int(number) > len(self.return_status_list):
			return self.return_status_list
		else:
			return random.sample(self.return_status_list, int(number))

	@staticmethod
	def get_require_pending_return_order(order_list, have_returned=False, min_item_count=1, min_flag=False):
		"""

		:param order_list:
		:param have_returned:
		:param min_item_count:
		:param min_flag: true [item.get("itemCount") == int(min_item_count)] false [item.get("itemCount") >= int(min_item_count)]
		:return:
		"""
		require_return_list = []
		min_require_return_list = []
		for item in order_list:
			if have_returned and item.get("status") == 17000:
				require_return_list.append(item)
			if not have_returned and item.get("status") == 11000:
				if item.get("itemCount") >= int(min_item_count):
					require_return_list.append(item)
				if item.get("itemCount") == int(min_item_count):
					min_require_return_list.append(item)
		require_order_info = {}
		if min_flag and len(min_require_return_list) > 0:
			require_order_info = random.choice(min_require_return_list)
		elif len(require_return_list) > 0:
			require_order_info = random.choice(require_return_list)
		return require_order_info

	@staticmethod
	def get_submit_refund_decision_body(return_detail, decision):
		returnOrderNumber = return_detail.get("returnOrderNumber")
		returnOrderLinesBody = []
		returnOrderLines = return_detail.get("returnOrderLines")
		for item in returnOrderLines:
			if item.get("status") == 11000:
				if decision.lower() == "reject":
					action = "rejectRefund"
					refundRejectReason = "Test API, Reject Refund, {}".format(datetime.datetime.now())
				else:
					action = "approveRefund"
					refundRejectReason = None

				returnOrderLinesBody.append({
					"orderAfterSalesItemId": item.get("orderAfterSalesItemId"),
					"action": action,
					"refundRejectReason": refundRejectReason
				})
		body = {
			"returnOrderNumber": returnOrderNumber,
			"returnOrderLines": returnOrderLinesBody
		}
		return body

	@staticmethod
	def get_non_duplicate_order_number(return_list):
		order_numbers = []
		for item in return_list:
			if item.get("orderNumber") not in order_numbers:
				order_numbers.append(item.get("orderNumber"))
		return order_numbers

	def compare_order_and_return_detail_data(self, order_detail, return_details):
		order_number = order_detail.get("orderNumber")
		order_status = order_detail.get("status")
		returnOrderLines = []
		for item in return_details:
			returnOrderLines.extend(item.get("returnOrderLines"))
		all_items_returned, tax_returned, returnedTotalTax = self.check_all_items_returned(order_detail, return_details)
		if all_items_returned:
			print("all_item_is_returned:", True)
			have_buyer_reason, afterSalesReasons = self.check_have_buyer_reason(returnOrderLines)
			print("have_buyer_reason:", have_buyer_reason, "-", afterSalesReasons)
			if not have_buyer_reason:
				shipping_rate_returned, msg = self.check_shipping_rate_returned(order_detail, return_details)
				print("shipping_rate_returned:", shipping_rate_returned, "-", msg)
			else:
				shipping_rate_returned, msg = self.check_shipping_rate_returned(order_detail, return_details)
				assert False, "Fail,{}({}), all_items_returned: {},have_buyer_reason: {},shipping_rate_returned: {} - {}".format(order_number, order_status,all_items_returned, have_buyer_reason, shipping_rate_returned, msg)
		else:
			print("all_item_is_returned:", False)
			shipping_rate_returned, msg = self.check_shipping_rate_returned(order_detail, return_details)
			print("shipping_rate_returned:", shipping_rate_returned, "-", msg)
			if shipping_rate_returned:
				assert False, "Fail, {}({}), all_items_returned: {}, shipping_rate_returned: {} - {}".format(order_number, order_status, all_items_returned, shipping_rate_returned, msg)
		orderTotalTax = order_detail.get("estimatedTax")
		if orderTotalTax != 0 and not tax_returned:
			assert False, "Fail, {}({}), some item non returned tax. orderTotalTax:{}, returnedTotalTax:{}".format(order_number, order_status, orderTotalTax, returnedTotalTax)

	@staticmethod
	def check_shipping_rate_returned(order_detail, return_details):
		shipping_rate_returned = False
		order_shipping_rate = order_detail.get("shippingHandlingCharge")
		refundShippingHandlingFee = 0
		for item in return_details:
			refundShippingHandlingFee += item.get("refundShippingHandlingFee")
		if order_shipping_rate + refundShippingHandlingFee == 0:
			shipping_rate_returned = True
		message = "order shipping rate: {}, refund shipping rate: {}".format(order_shipping_rate, refundShippingHandlingFee)
		return shipping_rate_returned, message

	def check_have_buyer_reason(self, return_order_lines):
		have_buyer_reason = False
		afterSalesReasons = []
		for return_order in return_order_lines:
			afterSalesReason = return_order.get("afterSalesReason")
			if afterSalesReason not in afterSalesReasons:
				afterSalesReasons.append(afterSalesReason)
			if afterSalesReason in self.buyer_reason_list:
				have_buyer_reason = True
		return have_buyer_reason, afterSalesReasons

	@staticmethod
	def check_all_items_returned(order_detail, return_details):
		all_items_returned = True
		tax_returned = True
		returnOrderLines = []
		for item in return_details:
			if item.get("status") == 18000:  # returned
				returnOrderLines.extend(item.get("returnOrderLines"))
		returnedTotalTax = 0
		for order in order_detail.get("orderLines"):
			if order.get("status") != 9000:  # not cancelled
				orderSkuNumber = order.get("skuNumber")
				orderItemQuantity = order.get("quantity")
				itemTax = order.get("estimatedTax")
				returnOrderItemQuantity = 0
				returnedItemTax = 0
				for return_order in returnOrderLines:
					if return_order.get("skuNumber") == orderSkuNumber and return_order.get("status") == 18000:
						returnOrderItemQuantity += return_order.get("quantity")
						returnedItemTax += return_order.get("refundTax")
						if itemTax != 0 and return_order.get("refundTax") == 0:
							tax_returned = False
				if orderItemQuantity != returnOrderItemQuantity:
					all_items_returned = False
				returnedTotalTax += returnedItemTax

		return all_items_returned, tax_returned, returnedTotalTax


if __name__ == '__main__':
	d = SellerReturnLib()
	with open("a.json", "r", encoding="utf-8") as f:
		data1 = json.load(f)
	with open("b.json", "r", encoding="utf-8") as f:
		data2 = json.load(f)
	d.compare_order_and_return_detail_data(data1, data2.get("data"))