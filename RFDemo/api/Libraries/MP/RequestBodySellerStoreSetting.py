import datetime
import random


class RequestBodySellerStoreSetting(object):
    def __int__(self):
        pass

    @staticmethod
    def update_store_profile_body(
        store_id, store_location="New York,NY", zip_code="10022"
    ):
        body = {
            "description": f"update store profile {datetime.datetime.now().strftime('%y-%m-%d %H:%M:%S')}",
            "logo": "https://static.platform.michaels.com/dev00/6046276391752531968.jpeg",
            "banner": "https://static.platform.michaels.com/dev00/6046276426112270336.jpeg",
            "storeId": store_id,
            "storeLocation": store_location,
            "zipCode": zip_code,
        }
        return body

    @staticmethod
    def update_customer_service_body(email, store_id):
        body = {
            "primaryContactInfos": [
                {
                    "email": email,
                    "phone": "477-557-6763",
                    "serviceHour": [
                        {
                            "from": "00:00 AM",
                            "to": "11:50 PM",
                            "days": random.sample(
                                [
                                    "Monday",
                                    "Tuesday",
                                    "Wednesday",
                                    "Thursday",
                                    "Friday",
                                    "Saturday",
                                    "Sunday",
                                ],
                                k=random.randint(1, 7),
                            ),
                            "fromUnit": "AM",
                            "toUnit": "PM",
                            "start": "00:00",
                            "end": "23:50",
                        }
                    ],
                    "timezone": random.choice(["-5", "-6", "-7", "-8", "-9", "-10"]),
                }
            ],
            "secondaryContactInfos": [
                {
                    "email": email,
                    "phone": "246-877-5576",
                    "department": "BILLING",
                    "selectedDepartment": random.sample(
                        [
                            "Customer Care",
                            "Billing",
                            "Order Resolution",
                            "Technical Issues",
                            "Marketing",
                        ],
                        k=random.randint(1, 5),
                    ),
                    "treeSelectorPick": [
                        {
                            "name": "Customer Care",
                            "value": "CUSTOMER_CARE",
                            "checked": False,
                        },
                        {"name": "Billing", "value": "BILLING", "checked": True},
                        {
                            "name": "Order Resolution",
                            "value": "ORDER_RESOLUTION",
                            "checked": False,
                        },
                        {
                            "name": "Technical Issues",
                            "value": "TECHNICAL",
                            "checked": False,
                        },
                        {"name": "Marketing", "value": "MARKETING", "checked": False},
                    ],
                }
            ],
            "privacyNotice": "Privacy Notice\nThis privacy statement describes how [seller name] collects and uses the personal information you provide on Michaels.com.  It also describes the choices available to you regarding our use of your personal information and how you can access and update this information.\n\nCollection and Use of Personal Information\n\nWe collect the following personal information from you:\n* Order Information such as name, mailing address, phone number, order number\n\nWe use this information to:\n* Fulfill your order\n* Respond to customer service requests\n\nInformation Sharing\nWe will share your personal information with third parties only in the ways that are described in this privacy statement. We do not sell your personal information to third parties. We may provide your personal information to companies that provide services to help us with our business activities such as shipping your order or offering customer service. These companies are authorized to use your personal information only as necessary to provide these services to us. We may also disclose your personal information as required by law such as to comply with a subpoena, or similar legal process.\n\nSecurity\nThe security of your personal information is important to us. We follow generally accepted industry standards to protect the personal information submitted to us, both during transmission and once we receive it.",
            "storeId": store_id,
        }
        return body

    @staticmethod
    def get_store_fulfillment_body(store_id):
        body = {
            "fulfillmentCenter": [
                {
                    "address1": "433 W Douglass St",
                    "address2": "s",
                    "city": "Reading",
                    "state": "PA",
                    "zipCode": "19601",
                    "phone": "",
                    "isReturnCenter": True,
                    "isDefault": True,
                    "fulfillmentName": "Fulfillment Center 1",
                    "timezone": random.choice(["-5", "-6", "-7", "-8", "-9", "-10"]),
                    "serviceHour": [
                        {
                            "from": "00:00 AM",
                            "to": "11:50 PM",
                            "timezone": "",
                            "days": [
                                "Monday",
                                "Tuesday",
                                "Wednesday",
                                "Thursday",
                                "Friday",
                                "Saturday",
                                "Sunday",
                            ],
                            "fromUnit": "AM",
                            "toUnit": "PM",
                            "start": "00:00",
                            "end": "23:50",
                        }
                    ],
                    "holidays": [
                        "New Years Day",
                        "Martin Luther King Jr. Day",
                        "Presidents' day",
                        "Memorial Day",
                        "Independence Day",
                        "Labor Day",
                        "Columbus Day",
                        "Veterans Day",
                        "Thanksgiving Day",
                        "Christmas Day",
                    ],
                    "anthorHolidays": [],
                }
            ],
            "storeId": store_id,
        }
        return body

    @staticmethod
    def add_shipping_rate_body():
        body = {
            "shippingRates": [
                {
                    "shipmentValueMin": "0.00",
                    "shipmentValueMax": "",
                    "shipmentCost": "1.00",
                    "shipmentMethod": 1,
                },
                {
                    "shipmentValueMin": "0.00",
                    "shipmentValueMax": "",
                    "shipmentCost": "20.00",
                    "shipmentMethod": 2,
                },
            ],
            "shippingSupport": ["1", "2"],
            "shippingExpeditedThreshold": True,
        }

        return body

    @staticmethod
    def add_shipping_rate_with_error_params_body():
        body = {
            "shippingRates": [
                {
                    "shipmentValueMin": "0.00",
                    "shipmentValueMax": "",
                    "shipmentCost": "1.00",
                    "shipmentMethod": 1,
                },
                {
                    "shipmentValueMin": "0.00",
                    "shipmentValueMax": "",
                    "shipmentCost": "20.00",
                    "shipmentMethod": 2,
                },
            ],
            "shippingSupport": ["1", "2"],
            "shippingExpeditedThreshold": False,
        }

        return body

    @staticmethod
    def update_return_option_body(store_info, return_policy):
        return_policy_list = [
            {
                "returnPolicyOption": 0,
                "returnPolicyTitle": "NO_RETURN",
                "returnPolicyNotice": "This is a final sale item. If your purchase does not meet your satisfaction, it cannot be returned.",
                "returnPolicyWhether": False,
            },
            {
                "returnPolicyOption": 1,
                "returnPolicyTitle": "IN_30_DAYS",
                "returnPolicyNotice": "If your purchase does not meet your satisfaction, it may be returned for full purchase amount within 30 days of your purchase.",
                "returnPolicyWhether": False,
            },
            {
                "returnPolicyOption": 2,
                "returnPolicyTitle": "IN_60_DAYS",
                "returnPolicyNotice": "If your purchase does not meet your satisfaction, it may be returned for full purchase amount within 60 days of your purchase.",
                "returnPolicyWhether": True,
            },
        ]

        if return_policy == "30_day":
            return_policy_list[0]["returnPolicyWhether"] = False
            return_policy_list[1]["returnPolicyWhether"] = True
            return_policy_list[2]["returnPolicyWhether"] = False
        elif return_policy == "60_day":
            return_policy_list[0]["returnPolicyWhether"] = False
            return_policy_list[1]["returnPolicyWhether"] = False
            return_policy_list[2]["returnPolicyWhether"] = True
        elif return_policy == "60_day":
            return_policy_list[0]["returnPolicyWhether"] = True
            return_policy_list[1]["returnPolicyWhether"] = False
            return_policy_list[2]["returnPolicyWhether"] = False
        body = {
            "fulfillmentCenter": store_info.get("fulfillmentCenter"),
            "returnCenterList": [
                {
                    "address1": "433 W Douglass St",
                    "address2": "s",
                    "city": "Reading",
                    "isDefault": True,
                    "phone": "",
                    "state": "PA",
                    "zipCode": "19601",
                }
            ],
            "returnPolicyList": return_policy_list,
            "storeId": store_info.get("sellerStoreId"),
            "upsSwitch": False,
        }

        return body

    @staticmethod
    def update_store_category_categoryItems_body(store_id, categoryId, userId):
        body = {
            "storeId": store_id,
            "categoryId": categoryId,
            "userId": userId,
            "masterSkuNumbers": [],
        }
        return body

    @staticmethod
    def create_store_category_body(store_id, store_category_name, user_id):
        body = {
            "storeId": store_id,
            "storeCategoryName": store_category_name,
            "userId": user_id,
        }
        return body

    @staticmethod
    def create_store_category_items_body(
        category_id, suk_numbers: list, store_id, user_id
    ):
        body = {
            "storeId": store_id,
            "categoryId": category_id,
            "userId": user_id,
            "masterSkuNumbers": suk_numbers,
        }
        return body

    @staticmethod
    def get_remove_group_item_body(category_id, item_id):
        body = {"categoryId": category_id, "itemId": item_id}
        return body

    @staticmethod
    def duplicate_product_groups_body(store_id, user_id, store_category_came):
        body = {
            "storeId": store_id,
            "storeCategoryName": f"{store_category_came} - copy",
            "userId": user_id,
        }
        return body

    @staticmethod
    def open_product_groups_body(group_ids):
        body = {"groupIds": [group_ids]}
        return body

    @staticmethod
    def query_project_product_body():
        body = {
            "pageInfo": {"pageNum": 1, "pageSize": 100},
            "sorts": [{"field": "createdTime", "order": "desc"}],
        }
        return body

    @staticmethod
    def update_product_groups_categoryItems_body(
        categoryId, categoryName, isAtStorefront
    ):
        body = [
            {
                "categoryId": categoryId,
                "categoryName": categoryName,
                "atStorefront": isAtStorefront,
                "isFeatured": False,
                "moreFeatured": False,
            }
        ]
        return {"productGroups": body}

    @staticmethod
    def get_set_product_group_visible_body(product_groups, is_visible):
        if is_visible.upper() == "TRUE":
            for info in product_groups:
                if not info.get("atStorefront"):
                    info["atStorefront"] = True
            body = {"productGroups": product_groups}
        elif is_visible.upper() == "FALSE":
            for info in product_groups:
                if info.get("atStorefront"):
                    info["atStorefront"] = False
            body = {"productGroups": product_groups}
        else:
            raise Exception("data is_visible error,support True or False")
        print(body)
        return body

if __name__ == "__main__":
    rr = RequestBodySellerStoreSetting()
    # print(datetime.datetime.now().strftime("%y-%m-%d %H:%M:%S"))
