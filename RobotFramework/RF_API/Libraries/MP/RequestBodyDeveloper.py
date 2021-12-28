class RequestBodyDeveloper(object):
	def __init__(self):
		pass

	@staticmethod
	def get_order_query_body(order_status_list=None):
		body = {
			"startTime": None,
			"endTime": None,
			"orderNumberList": "",
			"orderStatusList": order_status_list,
			"isAsc": False,
			"simpleMode": False,
			"currentPage": 1,
			"pageSize": 10
		}
		return body

	@staticmethod
	def get_order_detail_body(order_number):
		body = {
			"orderNumber": order_number,
			"simpleMode": False
		}
		return body

	@staticmethod
	def get_order_confirm_body(order_numbers):
		body = {
			"orderNumbers": order_numbers
		}
		return body

	@staticmethod
	def get_order_shipped_body(order_line):
		body = {
			"orderNumber": order_line.get("orderNumber"),
			"shipmentsList": [
				{
					"trackingNumber": "5564645612656",
					"carrier": "UPS",
					"carrierTrackingUrl": "https://tools.usps.com/go/TrackConfirmAction_input",
					"shipmentItemList": [
						{
							"quantity": order_line.get("quantity"),
							"orderItemId": order_line.get("orderItemId"),
							"uom": ""
						}
					]
				}
			]
		}
		return body

	@staticmethod
	def get_order_cancel_body(order_line):
		body = {
			"cancelReason": "The customer doesn't want it anymore",
			"orderNumber": order_line.get("orderNumber"),
			"cancelOrderLines": [
				{
					"orderItemId": order_line.get("orderItemId"),
					"quantity": order_line.get("quantity"),
					"cancelReason": "The customer doesn't want it anymore",
					"cancelAmount": -1
				}
			]
		}
		return body

	@staticmethod
	def get_return_order_query_body(return_order_status_list):
		body = {
			"startTime": None,
			"endTime": None,
			"orderNumber": "",
			"returnOrderNumber": "",
			"returnOrderStatusList": return_order_status_list,
			"simpleMode": False,
			"isAsc": False,
			"pageNumber": 1,
			"pageSize": 10
		}
		return body

	@staticmethod
	def get_return_order_approve_body(return_order_info):
		returnOrderLines = return_order_info.get("returnOrderLines")
		returnItemIds = []
		for item in returnOrderLines:
			returnItemIds.append(item.get("returnItemId"))
		body = {
			"returnOrderNumber": return_order_info.get("returnOrderNumber"),
			"returnItemIds": returnItemIds
		}
		return body

	@staticmethod
	def get_return_order_reject_body(return_order_info):
		returnOrderLines = return_order_info.get("returnOrderLines")
		orderLines = []
		for item in returnOrderLines:
			line = {
				"orderAfterSalesItemId": item.get("returnItemId"),
				"refundRejectReason": "OK",
				"refundRejectComment": "OK",
				"sellerRejectRefundMedia": [
					"https://imgproxy.dev.platform.michaels.com/XXTpt9MjeIKtJwhEo-W6WCFk1c9-K_Ll4qb5g7o5vco/aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL2Ntcy1taWstZGV2MDAvNTcxMzc0NzIwNzUxNDI0MzA3Mg.jpg"
				]
			}
			orderLines.append(line)

		body = {
			"returnOrderNumber": return_order_info.get("returnOrderNumber"),
			"returnOrderLines": orderLines
		}
		return body
