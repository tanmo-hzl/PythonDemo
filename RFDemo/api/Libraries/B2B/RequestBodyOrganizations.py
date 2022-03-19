import datetime
import random
import uuid


class RequestBodyOrganizations(object):
	def __init__(self):
		self.sales_rep_ids = [5765295142923666046, 6918216642157609605, 6918216645844402814, 6918216645852791422, 6918216645861180030]
		self.tax_bus_type = ["Wholesaler", "Retailer", "Manufacturer", "Exempt_Organization"]
		self.tax_exempt_org_type = ["Church", "School", "Federal_Government", "State_Government", "Other"]
		self.state = ["AL", "AZ", "AR", "CA", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

	def get_cur_and_pending_org_body(self, org_name=None):
		body = {
			"organizationName": org_name,
			"pageSize": 20,
			"sortBy": "organizationName,asc",
			"generalOrganizationTypes": "EDUCATION,ENTERPRISE",
			"statuses": "ACTIVE,PENDING_APPROVAL",
			"salesRepresentativeIds": self.sales_rep_ids
		}
		return body

	@staticmethod
	def get_random_code(need_number=True):
		if need_number:
			letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		else:
			letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		randomId = random.sample(letter, random.randint(3, 9))
		print("".join(randomId))
		return "".join(randomId)

	@staticmethod
	def get_org_tax_id_random():
		return str(random.randint(10, 99)) + "-" + str(random.randint(1000000, 9999999))

	def get_create_org_and_account_body(self, org_type="ENT", org_name=None, tax_id=None):

		random_key = org_name.upper()
		email_s = "ent-" if org_type.upper() == "ENT" else "edu-"
		email = email_s + random_key.lower() + "@snapmail.cc"
		phone = "333" + str(random.randint(100, 999)) + str(random.randint(1000, 9999))
		body = {
			"createRootOrganizationRequest": {
				"organizationName": "Par Org " + random_key,
				"businessName": "Par Bus " + random_key,
				"employerIdNumber": tax_id,
				"generalOrganizationType": "ENTERPRISE" if org_type.upper() == "ENT" else "EDUCATION",
				"specificOrganizationType": "BUSINESS" if org_type.upper() == "ENT" else "CHARTER_SCHOOL",
				"schoolDistrict": None,
				"addressAttention": None,
				"email": email,
				"phone": phone,
				"addressLine1": "555 Lexington Ave",
				"addressLine2": None,
				"city": "New York",
				"state": "NY",
				"zipcode": "10022",
				"applyPaymentTerm": False,
				"needPurchaseOrder": False,
				"taxExemptCertificateUrl": None,
				"requestorApplyToBeAdmin": True,
				"contactFirstName": random_key,
				"contactLastName": "Auto",
				"contactPhone": phone,
				"contactEmail": email,
				"requestorFirstName": random_key,
				"requestorLastName": "Auto",
				"requestorPhone": phone,
				"requestorEmail": email,
				"createTermPaymentRequest": None,
				"createTaxExemptRequest": None
			},
			"salesRepId": random.sample(self.sales_rep_ids, 1)[0]
		}
		return body

	@staticmethod
	def get_org_active_user_search_params():
		params = {
			"pageSize": 20,
			"sortBy": ["u.firstName,asc", "u.lastName,asc"]
		}
		return params

	@staticmethod
	def get_org_active_user_body(text=None):

		body = {
			"roles": ["ADMIN", "BUYER", "VIEWER", "VIEWER2", "SUB_ACCOUNT_ADMIN", "SUB_ACCOUNT_BUYER", "SUB_ACCOUNT_VIEWER", "SUB_ACCOUNT_VIEWER2"],
			"statuses": ["ACTIVE", "INACTIVE"]
		}
		if text is not None:
			body["searchTerm"] = text
		return body

	@staticmethod
	def get_org_pending_user_search_params():
		params = {
			"pageSize": 20,
			"sortBy": ["firstName,asc", "lastName,asc"]
		}
		return params

	@staticmethod
	def get_org_pending_user_body():
		body = {
			"roles": ["ADMIN", "BUYER", "VIEWER", "VIEWER2", "SUB_ACCOUNT_ADMIN", "SUB_ACCOUNT_BUYER", "SUB_ACCOUNT_VIEWER", "SUB_ACCOUNT_VIEWER2"],
			"statuses": ["INVITED", "APPROVED", "REJECTED", "PENDING_APPROVAL"]
		}
		return body

	@staticmethod
	def get_change_org_user_body(user_info, org_info, pwd=None):
		body = {
			"userProfile": {
				"firstName": user_info.get("firstName"),
				"lastName": user_info.get("lastName"),
				"email": user_info.get("email"),
				"password": pwd
			},
			"parentOrganizationAccess": {
				"organizationId": org_info.get("organizationId"),
				"role": org_info.get("role")
			},
			"subAccountAccesses": [],
			"subAccountIdsToRemoveAccessFor": []
		}
		return body

	@staticmethod
	def get_pricing_catalog_contracts_body(org_id, contract_url, pricing_catalog_id):
		body = {
			"updatePurchasingOrganizationRequest": None,
			"pricingCatalogId": pricing_catalog_id,
			"organizationId": org_id,
			"startDate": datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:00.000Z"),
			"endDate": (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:00.000Z"),
			"contractUrl": contract_url
		}
		return body

	@staticmethod
	def get_tax_business_information_body(org_info):
		body = {
			"businessName": org_info.get("businessName"),
			"businessDba": org_info.get("businessName"),
			"addressLine1": org_info.get("addressLine1"),
			"addressLine2": "",
			"city": org_info.get("city"),
			"state": org_info.get("state"),
			"locale": "en",
			"zipcode": org_info.get("zipcode")
		}
		return body

	@staticmethod
	def get_tax_signatory_information_body():
		body = {
			"jobTitle": "Title {}".format(str(uuid.uuid1()).split("-")[0]),
			"businessDescription": "Test, no business description",
			"purchaseItemsDescription": "All Items"
		}
		return body

	def get_state_tax_exempt_body(self, cert_url):

		bus_type_len = len(self.tax_bus_type)
		org_type_len = len(self.tax_exempt_org_type)
		bus_index = random.randint(0, bus_type_len-1)
		ex_reason = None
		if bus_index+1 != bus_type_len:
			ex_org_type = self.tax_exempt_org_type[org_type_len-1]
		else:
			ex_org_index = random.randint(0, org_type_len-1)
			ex_org_type = self.tax_exempt_org_type[ex_org_index]
			if ex_org_index+1 == org_type_len:
				ex_reason = "No Reason"
		tax_id = str(uuid.uuid1()).split("-")[0]
		body = {
			"state": random.choice(self.state),
			"country": "US",
			"county": None,
			"businessType": self.tax_bus_type[bus_index].upper(),
			"exemptOrganizationType": ex_org_type.upper(),
			"stateTaxIdNumber": tax_id,
			"certificateUrls": cert_url,
			"exemptionReason": ex_reason,
			"documentName": "{}.pdf".format(tax_id)
		}
		return body

	@staticmethod
	def get_org_user_activate_body(user_info, pwd):
		body = {
			"firstName": user_info.get("firstName").upper(),
			"lastName": user_info.get("lastName").upper(),
			"email": user_info.get("email").lower(),
			"password": pwd,
			"phoneNumber": "",
			"signUpForEmails": False,
			"signupForTextMessages": False
		}
		return body

	@staticmethod
	def get_sub_accounts_list_body(org_id, org_name=None):
		body = {
			"parentOrganizationId": org_id,
			"organizationName": org_name,
			"pageNumber": 0,
			"pageSize": 20,
			"sortBy": "organizationName,asc",
			"statusList": "ACTIVE,INACTIVE"
		}
		return body

	@staticmethod
	def get_add_sub_org_body(org_info, code_number):
		code = org_info.get("organizationName").split(" ")
		try:
			code_number = int(code_number)
		except Exception as e:
			print(e)
			code_number = random.randint(100, 999)

		body = {
			"organizationName": "SUB {} {}".format(org_info.get("organizationName"), code_number + 1),
			"businessName": org_info.get("businessName"),
			"employerIdNumber": org_info.get("employerIdNumber"),
			"email": "sub-{}-{}@snapmail.cc".format(code[2].lower(), code_number + 1),
			"addressLine1": "{} Lexington Ave".format(random.randint(100, 999)),
			"addressLine2": None,
			"zipcode": "10022" if org_info.get("zipcode") is None else org_info.get("zipcode"),
			"city": "New York" if org_info.get("city") is None else org_info.get("city"),
			"state": "NY" if org_info.get("state") is None else org_info.get("state"),
			"specificOrganizationType": org_info.get("specificOrganizationType"),
			"needPurchaseOrder": False,
			"applyPaymentTerm": False,
			"contactFirstName": org_info.get("contactFirstName"),
			"contactLastName": org_info.get("contactLastName"),
			"phone": ""
		}
		return body

	@staticmethod
	def get_update_sub_account_body(sub_account_info):
		body = sub_account_info
		body["organizationName"] = "{}{}".format(sub_account_info.get("organizationName")[:-2], random.randint(100, 999))
		return body

	@staticmethod
	def get_org_by_keywords_body(org_name=None, tax_id=None):
		body = {
			"organizationName": org_name,
			"employerIdNumber": tax_id,
			"sortBy": "organizationName,asc",
			"pageSize": 10,
			"pageNumber": 0
		}
		return body

	@staticmethod
	def get_register_org_body(org_type=0):
		body = {
			"organizationName": "sub kvw",
			"employerIdNumber": "12-3131231",
			"generalOrganizationType": "EDUCATION",
			"specificOrganizationType": "PUBLIC_SCHOOL",
			"schoolDistrict": "ADAMS 12 FIVE STAR SCHOOLS",
			"addressAttention": None,
			"email": "ent-kvws-4@snapmail.cc",
			"addressLine1": "555 adc",
			"addressLine2": None,
			"city": "New York",
			"state": "NY",
			"zipcode": "10022",
			"phone": None,
			"applyPaymentTerm": False,
			"needPurchaseOrder": False,
			"purchasingOrganization": None,
			"contractNumber": None,
			"purchasingOrganizationPartnerId": None,
			"purchasingOrganizationDetails": None,
			"requestorApplyToBeAdmin": True,
			"requestorFirstName": "kvwc",
			"requestorLastName": "Auto",
			"requestorEmail": "ent-kvws-4@snapmail.cc",
			"requestorPhone": "8633333332",
			"secondRequestorFirstName": None,
			"secondRequestorLastName": None,
			"secondRequestorEmail": None,
			"secondRequestorPhone": None,
			"createTaxExemptRequest": None
		}
		return body

	def get_invite_user_body(self, org_id, role="ADMIN"):
		code = self.get_random_code(False)
		email = "invite-{}-{}@snapmail.cc".format(code.lower(), str(random.randint(10, 99)))
		body = {
			"firstName": code.upper(),
			"lastName": "Auto",
			"email": email,
			"organizationId": org_id,
			"comments": "Test account don't have comments",
			"role": role,
			"subAccountAccesses": [],
			"confirmedToInviteRemovedUser": False,
			"notAllowedToChangePassword":False
		}
		return body


if __name__ == '__main__':

	r = RequestBodyOrganizations()
	d = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%s.000Z")
	d1 = (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%S.000Z")
	print(d1)
	print(r.get_state_tax_exempt_body("123123"))
