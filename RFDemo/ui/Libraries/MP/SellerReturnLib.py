import random


class SellerReturnLib(object):
	def __init__(self):
		self.return_status_list = ["Pending Return", "Refund Rejected", "Returned", "Return Canceled", "Pending Refund"]
		self.return_duration_list = ["All Time", "Today", "Yesterday", "Past 7 Days", "Past 30 Days", "Past 6 Month"]

	def get_return_status_by_number(self, number):
		if int(number) <= 1:
			return random.sample(self.return_status_list, 1)
		if int(number) > len(self.return_status_list):
			return self.return_status_list
		else:
			return random.sample(self.return_status_list, int(number))
