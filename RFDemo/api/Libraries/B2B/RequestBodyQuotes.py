import datetime
import time
from typing import Optional


class RequestBodyQuotes(object):
	def __init__(self):
		pass

	@staticmethod
	def get_quotes_list_body(
			keywords: Optional[str] = None,
			statuses: Optional[str] = None,
			amount_lower_limit=0,
			amount_upper_limit=10000000,
			start_time_stamp=0,
			end_time_stamp: int = int(time.time() * 1000 + 8*60*60*1000),
	):
		"""
		:param keywords:
		:param statuses:  INITIATED, SUBMITTED,PRICED,CUSTOMER_ACCEPTED,CUSTOMER_REJECTED,CANCELLED,PAYMENT_NEEDED,COMPLETED,
		PENDING_MICHAELS_ADMIN_APPROVAL,MICHAELS_ADMIN_REJECTED,IN_PROGRESS,EXPIRED
		:param amount_lower_limit:
		:param amount_upper_limit:
		:param start_time_stamp:
		:param end_time_stamp:
		:return:
		"""
		if keywords is not None:
			statuses = ['SUBMITTED', 'PRICED', 'CUSTOMER_REJECTED', 'COMPLETED', 'PENDING_MICHAELS_ADMIN_APPROVAL', 'MICHAELS_ADMIN_REJECTED', 'IN_PROGRESS', 'EXPIRED']

		body = {
			"keywords": keywords,
			"statuses": statuses,
			"amountLowerLimit": amount_lower_limit,
			"amountUpperLimit": amount_upper_limit,
			"startTimeStamp": start_time_stamp,
			"endTimeStamp": end_time_stamp,
			"pageSize": 20,
			"sortBy": "updatedTime,desc"
		}
		if keywords is not None:
			body["pageNumber"] = 1
		return body

	@staticmethod
	def get_create_quotes_items_body(
			requested_by,
			organization_id,
			product_sku_info,
			expiration_time: Optional[str] = None,
			product_type="STANDARD",  # STANDARD,CUSTOM
			quantity: int = 1,
			is_multi_use: bool = False,
	):
		expiration_time = (
			expiration_time
			if expiration_time
			else (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%SZ")
		)
		create_quote_item_requests = []
		for item in product_sku_info:
			sku_number = item.get("skuNumber")
			determined_price_per_unit = round((float(item.get("price")) - 0.1), 2)
			print()
			quote_item_request = {
				"skuNumber": sku_number,
				"productType": product_type,
				"quantity": quantity,
				"determinedPricePerUnit": determined_price_per_unit,
			}
			create_quote_item_requests.append(quote_item_request)

		body = {
			"requestedBy": requested_by,
			"organizationId": organization_id,
			"expirationTime": expiration_time,
			"comment": str(datetime.datetime.now()),
			"createQuoteItemRequests": create_quote_item_requests,
			"isMultiUse": is_multi_use,
		}
		return body

	@staticmethod
	def get_update_quotes_items_body(
			requested_by,
			organization_id,
			quotes_item_detail,
			expiration_time=None,
			date_needed_by: Optional = None,
			is_multi_use: bool = False,
	):

		expiration_time = (
			expiration_time
			if expiration_time
			else (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%SZ")
		)
		quote_item_requests = []
		for quote_item in quotes_item_detail:
			quote_dict = {
				"skuNumber": quote_item.get("skuNumber"),
				"productType": quote_item.get("productType"),
				"quantity": float(quote_item.get("quantity")) + 1,
				"determinedPricePerUnit": quote_item.get("determinedPricePerUnit"),
			}
			quote_item_requests.append(quote_dict)
		body = {
			"requestedBy": requested_by,
			"organizationId": organization_id,
			"dateNeededBy": date_needed_by,
			"comment": "",
			"quoteItemRequests": quote_item_requests,
			"expirationTime": expiration_time,
			"isMultiUse": is_multi_use,
		}
		return body

	@staticmethod
	def get_quotes_shipping_cart_items(data):
		body = []
		for item in data:
			item_body = {
				"skuNumber": item.get("skuNumber"),
				"quantity": item.get("quantity"),
				"quoteId": item.get("quoteId"),
				"determinedPricePerUnit": item.get("determinedPricePerUnit")
			}
			body.append(item_body)
		return body


if __name__ == "__main__":
	print(round((float(5.99) - 0.1), 2))
	d = "INITIATED, SUBMITTED,PRICED,CUSTOMER_ACCEPTED,CUSTOMER_REJECTED,CANCELLED,PAYMENT_NEEDED,COMPLETED,PENDING_MICHAELS_ADMIN_APPROVAL,MICHAELS_ADMIN_REJECTED,IN_PROGRESS,EXPIRED"
	print(d.split(","))

