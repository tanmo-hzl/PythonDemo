import datetime
import random


class SellerDisputeLib(object):
	def __init__(self):
		self.decisions = ["Offer Full Refund", "Offer Partial Refund", "Reject Refund"]
		self.dispute_status_list = ["Dispute Opened", "Dispute In Process", "Offer Made", "Offer Rejected", "Dispute Resolved", "Dispute Escalated", "Escalation Under Review", "Dispute Canceled"]

	def get_dispute_decision(self, items, decision, refund_shipping=True):
		"""

		:param items:
		:param decision:
		:param refund_shipping:
		:return:
		"""
		decision = str(decision)
		item_decision = []
		for item in items:
			if decision.isdigit():
				if int(decision) == 1:
					return_amount = round(float(item.get("amount")) * 0.8, 2)
				else:
					return_amount = 0
				decision_value = self.decisions[int(decision)]
			else:
				decision_value = decision
				if decision_value == self.decisions[1]:
					return_amount = round(float(item.get("amount")) * 0.8, 2)
				else:
					return_amount = 0

			body = {
				"decision": decision_value,
				"amount": return_amount,
				"reason": "Test {}, {}".format(decision_value, datetime.datetime.now())
			}
			item_decision.append(body)
		decision_info = {"decisions": item_decision, "refundShipping": refund_shipping}
		print(decision_info)
		return decision_info

	def get_dispute_status_by_number(self, number):
		if int(number) <= 1:
			return random.sample(self.dispute_status_list, 1)
		if int(number) > len(self.dispute_status_list):
			return self.dispute_status_list
		else:
			return random.sample(self.dispute_status_list, int(number))


if __name__ == '__main__':
	d = SellerDisputeLib()
	d.get_dispute_decision([{"amount": "23.45"}], 1, False)
