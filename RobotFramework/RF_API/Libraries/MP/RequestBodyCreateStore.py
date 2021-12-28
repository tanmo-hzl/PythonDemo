import datetime
import random
import time
from Libraries.Common import Common


class RequestBodyCreateStore(object):
	def __init__(self):
		self.common = Common()

	@staticmethod
	def get_random_code():
		letter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		randomId = random.sample(letter, random.randint(3, 5))
		print("".join(randomId))
		return "".join(randomId)

	def get_seller_pre_application_body(self, random_id):
		upload_file_data = self.common.read_file("upload-img-data")
		filePath = upload_file_data.get("logoUrl")
		categories = ['Storage', 'Kids', 'Crafts', 'Decor', 'Art', 'Yarn', 'Papercraft', 'Jewelry', 'Baking',
		              'Craft Machines', 'Fabric', 'Wedding', 'Party', 'Frames', 'Floral']
		# randomId = datetime.datetime.now().strftime("%y-%m%d-%H%m%S")
		email = "at-" + random_id.lower() + "@snapmail.cc"
		body = {
			"companyName": "Company " + random_id,
			"email": email,
			"ein": str(time.time())[1:10],
			"soldInUS": False if random.randrange(0, 2) == 0 else True,
			"categories": [categories[random.randrange(0, len(categories))]],
			"platforms": [
				"www.baidu"
			],
			"productLinks": [
				"http://www.baidu.com"
			],
			"numberOfSkus": str(random.randrange(0, 3)),
			"sales": str(random.randrange(0, 3)),
			"preferredMethod": "0",
			"partnerCompanyName": "",
			"coFirstName": "Test",
			"coLastName": "Auto",
			"fileList": [filePath]
		}
		return body

	@staticmethod
	def get_mik_seller_query_body(company_name, status="Pending"):

		body = {
			"filters": [
				{
					"field": "companyLegalName",
					"operator": "like",
					"value": company_name
				},
				{
					"field": "status",
					"value": status
				}
			],
			"sorts": [
				{
					"field": "createdTime",
					"order": "desc"
				}
			],
			"pageInfo": {
				"pageNum": 1,
				"pageSize": 10
			}
		}
		return body

	@staticmethod
	def get_seller_approve_body(application_id):
		body = {
			"applicationId": application_id,
			"salesManagerName": "",
			"operatorName": "michaels"
		}
		return body

	@staticmethod
	def get_mik_user_create_body(seller_info, pwd):
		body = {
			"firstName": "Test",
			"lastName": "Auto",
			"email": seller_info.get("email"),
			"password": pwd,
			"phoneNumber": "",
			"signUpForEmails": True,
			"signUpForTextMessage": False,
			"signUpForRewards": False,
			"buyerDisabled": True
		}
		return body

	@staticmethod
	def get_mik_cms_content_text(seller_info):
		body = {
			"values": [
				"storeName:"+seller_info.get("companyName")
			],
			"clientId": "fgm",
			"sourceId": "string",
			"textType": "STORE_NAME",
			"needScreened": True
		}
		return body

	@staticmethod
	def get_mik_seller_bank_account_body():
		body = {
			"sellerBalanceAccountValidationRequestObjectList": [
				{
					"creditorAccountNumber": "10500008944",
					"creditorRoutingNumber": "122199983"
				}
			]
		}
		return body

	@staticmethod
	def get_mik_store_registration_body(seller_info, application_id, user_id):
		body = {
			"applicationId": application_id,
			"userId": user_id,
			"storeName": seller_info.get("companyName"),
			"storeLocation": "",
			"bankAccount": {
				"bankName": "Beijing",
				"bankAccountType": "0",
				"creditorAccountNumber": "10500008944",
				"creditorRoutingNumber": "122199983",
				"firstName": "Test",
				"lastName": "Auto",
				"companyName": seller_info.get("companyName"),
				"EIN": seller_info.get("ein"),
				"companyInfo": {
					"coFirstName": "Test",
					"coLastName": "Auto",
					"coAddress1": "555 Lexington Ave",
					"coAddress2": "",
					"coCity": "New York",
					"coState": "NY",
					"coZipCode": "10022",
					"coAddress3": "",
					"coZipCodeExtension": "",
					"coSsn": ""
				}
			},
			"payableInfos": [
				{
					"cardholderName": "Discover",
					"bankCardNickName": "Discover ",
					"cardNumber": "6011016011016011",
					"expirationDate": "1233",
					"cvv": "456",
					"firstName": "Test",
					"lastName": "Auto",
					"address1": "555 Lexington Ave",
					"address2": "",
					"city": "New York",
					"state": "NY",
					"zipCode": "10022",
					"phoneNumber": "333-333-3333",
					"setDefaultPayment": True,
					"useAddress": True
				}
			]
		}
		return body

	def get_store_profile_body(self, store_id):

		upload_file_data = self.common.read_file("upload-img-data")
		logo = upload_file_data.get("logoUrl")
		banner = upload_file_data.get("bannerUrl")
		body = {
			"description": "no descripation",
			"logo": logo,
			"banner": banner,
			"storeId": store_id
		}
		return body

	@staticmethod
	def get_new_customer_services_body(seller_info, store_id):
		email = seller_info.get("user").get("email")
		body = {
			"primaryContactInfos": [{
				"phone": "333-333-3333",
				"email": email,
				"timezone": -5,
				"serviceHour": [{
					"from": "08:00 AM",
					"start": "08:00",
					"fromUnit": "AM",
					"to": "09:00 PM",
					"end": "09:00",
					"toUnit": "PM",
					"timezone": -5,
					"days": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
				}]
			}],
			"secondaryContactInfos": [{
				"phone": "333-333-3333",
				"email": email,
				"department": "ORDER_RESOLUTION",
				"selectedDepartment": ["Order Resolution"]
			}],
			"privacyNotice": "Privacy Notice\nThis privacy statement describes how [seller name] collects and uses the personal information you provide on Michaels.com.  It also describes the choices available to you regarding our use of your personal information and how you can access and update this information.\n\nCollection and Use of Personal Information\n\nWe collect the following personal information from you:\n* Order Information such as name, mailing address, phone number, order number\n\nWe use this information to:\n* Fulfill your order\n* Respond to customer service requests\n\nInformation Sharing\nWe will share your personal information with third parties only in the ways that are described in this privacy statement. We do not sell your personal information to third parties. We may provide your personal information to companies that provide services to help us with our business activities such as shipping your order or offering customer service. These companies are authorized to use your personal information only as necessary to provide these services to us. We may also disclose your personal information as required by law such as to comply with a subpoena, or similar legal process.\n\nSecurity\nThe security of your personal information is important to us. We follow generally accepted industry standards to protect the personal information submitted to us, both during transmission and once we receive it.",
			"storeId": store_id
		}
		return body


	@staticmethod
	def get_shipping_rate_add_body():
		body = {
			"shippingRates": [{
				"shipmentCost": "3.00",
				"shipmentValueMin": "0.00",
				"shipmentValueMax": None,
				"shipmentMethod": 1
			}],
			"shippingSupport": []
		}
		return body

	@staticmethod
	def get_store_fulfillment_body(store_id):
		holidays = ["New Years Day", "Martin Luther King Jr. Day", "Presidents' day", "Memorial Day", "Independence Day", "Labor Day", "Columbus Day", "Veterans Day", "Thanksgiving Day", "Christmas Day"]
		body = {
			"fulfillmentCenter": [{
				"fulfillmentName": "Fulfillment Center 1",
				"address1": "555 Lexington Ave",
				"address2": "",
				"city": "New York",
				"state": "NY",
				"zipCode": "10022",
				"autoFillFrom": [],
				"timezone": -5,
				"isDefault": True,
				"serviceHour": [{
					"from": "08:00 AM",
					"start": "08:00",
					"fromUnit": "AM",
					"to": "09:00 PM",
					"end": "09:00",
					"toUnit": "PM",
					"days": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
				}, {
					"from": "09:00 AM",
					"start": "09:00",
					"fromUnit": "AM",
					"to": "11:00 PM",
					"end": "11:00",
					"toUnit": "PM",
					"days": ["Saturday", "Sunday"]
				}],
				"holidays": random.sample(holidays, random.randint(1, 4)),
				"anthorHolidays": [{
					"holidayName": "",
					"from": "",
					"to": ""
				}],
				"isOpenModal": False,
				"isRenameTitle": False,
				"isOpen": False,
				"customVacation": []
			}],
			"storeId": store_id
		}
		return body

	@staticmethod
	def get_store_return_option_body(store_id):
		body = {
			"returnCenterList": [{
				"address1": "ww1",
				"address2": "",
				"city": "d",
				"isDefault": True,
				"state": "AL",
				"zipCode": "12706"
			}],
			"returnPolicyList": [{
				"returnPolicyOption": 0,
				"returnPolicyTitle": "NO_RETURN",
				"returnPolicyNotice": "This is a final sale item. If your purchase does not meet your satisfaction, it cannot be returned.",
				"returnPolicyWhether": False
			}, {
				"returnPolicyOption": 1,
				"returnPolicyTitle": "IN_30_DAYS",
				"returnPolicyNotice": "If your purchase does not meet your satisfaction, it may be returned for full purchase amount within 30 days of your purchase.",
				"returnPolicyWhether": True
			}, {
				"returnPolicyOption": 2,
				"returnPolicyTitle": "IN_60_DAYS",
				"returnPolicyNotice": "If your purchase does not meet your satisfaction, it may be returned for full purchase amount within 60 days of your purchase.",
				"returnPolicyWhether": False
			}],
			"storeId": store_id
		}
		return body


if __name__ == '__main__':
	r = RequestBodyCreateStore()
	a = r.get_store_fulfillment_body("111")
	print(a)
