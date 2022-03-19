

class RequestBodyUser(object):
	def __init__(self):
		pass

	@staticmethod
	def get_mik_sign_in_body(sell_info, ipv4=None):
		if ipv4 is None:
			ipv4 = '172.105.37.5'
		else:
			ipv4 = ipv4.replace("\n", "")
		body = {
			"email": sell_info.get("email"),
			"password": sell_info.get("password"),
			"deviceUuid": "79185788-882b-47db-b355-91a0a2ed9339",
			"deviceType": 0,
			"deviceName": "Chrome",
			"loginAddress": ipv4
		}
		return body

	@staticmethod
	def get_mik_sign_in_secure_body(sign_data, ipv4=None):
		if ipv4 is None:
			ipv4 = '172.105.37.5'
		else:
			ipv4 = ipv4.replace("\n", "")
		body = {
			"emailPassword": sign_data,
			"deviceUuid": "79185788-882b-47db-b355-91a0a2ed9339",
			"deviceType": 0,
			"deviceName": "Chrome",
			"loginAddress": ipv4
		}
		return body
