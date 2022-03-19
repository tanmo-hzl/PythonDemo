

class RequestBodyNotifications(object):
	def __init__(self):
		pass

	@staticmethod
	def get_notifications_body(user_id):
		body = {
			"userId": user_id,
			"pageNumber": 0,
			"pageSize": 50,
			"sortBy": "createdTime,desc"
		}
		return body

	@staticmethod
	def get_del_notifications_body(user_id):
		body = {
			"userId":user_id
		}
		return body
