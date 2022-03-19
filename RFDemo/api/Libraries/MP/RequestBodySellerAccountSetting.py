class RequestBodySellerAccountSetting(object):
	def __init__(self):
		pass


	@staticmethod
	def update_account_two_factor_verify_code_body():
		body = {
			"twoStepVerification": False,
			"twoStepVerificationMethod": "0"
		}
		return body

	@staticmethod
	def update_account_two_factor_verify_auth_body():
		body = {
			"twoStepVerification": False,
			"twoStepVerificationMethod": "0",
			"token": "454781"
		}
		return body

