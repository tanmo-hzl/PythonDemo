class RequestBodyOrder(object):
	def __init__(self):
		pass

	@staticmethod
	def get_order_list_body():
		body = {
			"pageSize": 20,
			"descending": True,
			"pageNumber": 0
		}
		return body

	@staticmethod
	def get_search_past_order_body(keywords=None, status="In Progress"):
		if status.upper() == "IN PROGRESS":
			status = ["OPEN", "PARTIALLY_BACK_ORDERED", "BACK_ORDERED", "PARTIALLY_ALLOCATED", "ALLOCATED", "RELEASED", "PARTIALLY_RELEASED", "PARTIALLY_IN_PROCESS", "IN_PROCESS", "PARTIALLY_PICKED", "PICKED", "PARTIALLY_PACKED"]
		body = {
			"pageSize": 20,
			"descending": True,
			"pageNumber": 0,
			"keywords": keywords,
			"orderStatuses": status
		}
		return body

	@staticmethod
	def get_search_pending_order_body(keywords=None, status=None, start_date=None, end_date=None):
		"""

		:param keywords:
		:param status:
		:param start_date:
		:param end_date: 2021-12-05T16:00:00.000Z
		:return:
		"""
		if status is None:
			status = ["PENDING_FOR_APPROVAL", "FAILED", "ORDER_ON_HOLD_UNDER_REVIEW", "REJECTED"]
		body = {
			"sortBy": "created_time",
			"descending": True,
			"pageNumber": 0,
			"pageSize": 20,
			"keywords": keywords,
			"orderRequestStatuses": status,
			"endDate": start_date,
			"startDate": end_date

		}
		return body
