import datetime
import random
import uuid


class RequestBodyBudgets(object):
	def __init__(self):
		pass

	@staticmethod
	def get_user_budgets_body(user_id):
		body = {
			"userId": user_id,
			"pageSize": 100

		}
		return body

	@staticmethod
	def get_add_org_budget_body(org_id=None, sub_account_info=None):
		amount = random.randint(1000, 5000)
		body = {
			"budgetName": "Budget {}".format(str(uuid.uuid1()).split("-")[0]),
			"amountLimit": str(amount),
			"startDate": datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%SZ"),
			"endDate": (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%SZ"),
			"currency": "USD",
			"updateSubAccountBudgetAccessRequests": []
		}
		if org_id is not None:
			body["organizationId"] = org_id

		if sub_account_info is not None:
			body["updateSubAccountBudgetAccessRequests"] = [{
				"accessType": "READ",
				"amountLimit": amount,
				"amountUsed": "",
				"organizationId": sub_account_info.get("organizationId"),
				"organizationName": sub_account_info.get("organizationName")
			}]

		return body
