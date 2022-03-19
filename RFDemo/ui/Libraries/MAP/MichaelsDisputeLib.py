import datetime
import random


class MichaelsDisputeLib(object):
	def __init__(self):
		self.decisions = ["Full Refund", "Partily Refund", "Reject Refund"]

	def get_michaels_decision_info(self, items_info, refund_shipping_free=None):
		decision_list = []
		for item in items_info:
			decision = random.choice(self.decisions)
			if decision == self.decisions[1]:
				amount = round(float(item.get("amount")) * 0.8, 2)
			else:
				amount = 0
			reason = "{},{}.".format(decision, datetime.datetime.now())
			decision_list.append({"decision": decision, "amount": amount, "reason": reason})
		if refund_shipping_free is None:
			refund_shipping_free = True if random.randint(0, 10) > 5 else False
		body = {"decision": decision_list, "refundShippingFree": refund_shipping_free}
		print(body)
		return body


if __name__ == '__main__':
	m = MichaelsDisputeLib()
	m.get_michaels_decision_info([{"amount": 23.56}])
