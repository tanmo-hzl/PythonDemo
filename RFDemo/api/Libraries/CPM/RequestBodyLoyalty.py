import datetime
import random
import time


class RequestBodyLoyalty(object):
    def __init__(self):
        pass

    @staticmethod
    def create_loyalty(email, user_id, first_name, last_name, dob, phone_number):
        if phone_number is None:
            phone_number = RequestBodyLoyalty.get_phone_number(phone_number)
        return {
            "phoneNumber": phone_number
            if phone_number is not None
            else RequestBodyLoyalty.get_phone_number(),
            "email": email,
            "userId": user_id,
            "firstName": first_name,
            "lastName": last_name,
            "dob": dob if dob is not None else "",
        }

    @staticmethod
    def create_rewrite_linked(contact_number, contact_method, user_id, dob):

        return {
            "contactNumber": contact_number,
            "contactMethod": contact_method,
            "dob": dob if dob is not None else "",
            "userId": user_id,
        }

    @staticmethod
    def create_registration(
        email: str = None,
        phone_number: str = None,
        first_name: str = None,
        last_name: str = None,
    ):

        """
        :param email:
        :param first_name:
        :param last_name:
        :param phone_number:
        :param registration_type: phone_number,email,rewards_id
        :return:
        """
        if phone_number is None:
            phone_number = RequestBodyLoyalty.get_phone_number()

        if email is None:
            time.sleep(2)
            email = f"auto{str(time.time()).split('.')[0]}{RequestBodyLoyalty.random_int(3)}@mail.com"

        message_header = {
            "channel": "ECOM",
            "timeStamp": datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%S.%fZ"),
            "companyName": "MIK",
        }
        registration_request = {
            "memberProfile": {
                "email": email,  # any non-null string
                "phoneNumber": phone_number,  # any 10-character long alphanumeric string; not necessarily a number
                "firstName": first_name if first_name is not None else "automation",
                "lastName": last_name if last_name is not None else "automation",
                "retriggerWelcomeEmail": False,  # false = won't send a welcome email to the email address
                "ignoreEmailValidation": True,  # true = won't send an  validation email
            },
            "registrationInfo": {  # this is absolutely necessary to include
                "registrationSource": "ECOM"  # placholder here; indicates that the account was created online
            },
            "system": {  # this can be used as a placeholder for now
                "status": "ACTIVE",  # activates the loyalty profile
                "operation": "NEW",  # indicates that the account is "new"
            },
        }
        return {
            "messageHeader": message_header,
            "registrationRequest": registration_request,
        }

    @staticmethod
    def get_phone_number(phone=None):
        # NXX-NXX-XXXX
        if phone is not None:
            phone_number = int(phone) + 1
            if int(str(phone_number)[0:1]) < 2:
                phone_number = int(f"2{str(phone_number)[1:]}")
            if int(str(phone_number)[3:4]) < 2:
                phone_number = int(f"{str(phone_number)[0:3]}2{str(phone_number)[5:]}")
        else:
            phone_number = int(
                f"{random.randint(2,9)}{RequestBodyLoyalty.random_int(2)}{random.randint(2,9)}{RequestBodyLoyalty.random_int(6)}"
            )
        return phone_number

    @staticmethod
    def create_check_discount(
        loyalty_id,
        email_id,
        phone_no,
        company,
        division,
        source,
        get_profile,
        get_loyalty_points_history,
        get_tax_exempt_info,
        get_crm_offers,
        get_vouchers,
    ):
        return {
            "loyaltyId": loyalty_id,
            "emailId": email_id if email_id is not None else "",
            "phoneNo": phone_no if phone_no is not None else "",
            "company": company if company is not None else "",
            "division": division if division is not None else "",
            "source": source if source is not None else "",
            "getProfile": get_profile if get_profile is not None else True,
            "getLoyaltyPointsHistory": get_loyalty_points_history
            if get_loyalty_points_history is not None
            else True,
            "getTaxExemptInfo": get_tax_exempt_info
            if get_tax_exempt_info is not None
            else True,
            "getCRMOffers": get_crm_offers if get_crm_offers is not None else True,
            "getVouchers": get_vouchers if get_vouchers is not None else True,
        }

    @staticmethod
    def random_int(length) -> int:
        return random.randint(int("1" + "0" * (length - 1)), int("9" * length))
