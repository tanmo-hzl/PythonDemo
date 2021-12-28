import uuid


class RequestBodyUser(object):
	def __init__(self):
		pass

	@staticmethod
	def get_user_sign_in_body(email):
		body = {
			"email": email,
			"deviceUuid": str(uuid.uuid1()),
			"deviceType": 0,
			"deviceName": "Chrome",
			"loginAddress": ""
		}
		return body
