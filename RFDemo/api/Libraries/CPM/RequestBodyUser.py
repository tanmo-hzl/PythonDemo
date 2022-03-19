import random

import requests


class RequestBodyUser(object):
    def __init__(self):
        pass

    @staticmethod
    def get_buyer_body(email_password):
        return {
            "deviceName": "Firefox",
            "deviceType": 0,
            "deviceUuid": "8e5604af-99db-47a5-b5e9-465040486690",
            "emailPassword": email_password,
        }

    @staticmethod
    def get_headers(token):
        return {
            "User-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36",
            "authorization": f"Bearer {token}",
        }

    @staticmethod
    def create_guest_user(
        email: str = "automation@michaels",
        phone_number: str = "2888888888",
        first_name: str = "automation",
        last_name: str = "Guest",
    ):
        return {
            "email": email,
            "phoneNumber": phone_number,
            "firstName": first_name,
            "lastName": last_name,
        }

    @staticmethod
    def get_admin_headers(token):
        return {
            "User-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36",
            "admin-authorization": f"{token}",
        }

    @staticmethod
    def create_email(url):
        email = f"auto{RequestBodyUser.random_int(8)}@mail.com"
        return RequestBodyUser.create_user_registration(url=url, email=email)

    @staticmethod
    def create_user_registration(
        url,
        email: str,
        first_name: str = "buyer",
        last_name: str = "Automation",
        password: str = "Password123",
        phone_number: str = "6085021043",
        signup_for_emails: bool = True,
        signup_for_text_message: bool = False,
        signup_for_rewards: bool = False,
        registration_type: int = 0,
        rewards_email: str = "",
        rewards_phone_number=None,
        rewards_type: int = 0,
    ):
        payload = {
            "firstName": first_name,
            "lastName": last_name,
            "email": email,
            "password": password,
            "phoneNumber": phone_number,
            "signUpForEmails": signup_for_emails,
            "signUpForTextMessage": signup_for_text_message,
            "signUpForRewards": signup_for_rewards,
            "registrationType": registration_type,
            "rewardsType": rewards_type,
            "dateOfBirth": "",
            "rewardsEmail": rewards_email,
            "rewardsPhoneNumber": rewards_phone_number,
        }
        requests.post(url=f"{url}/user/register", json=payload)
        token = None
        for user_token in RequestBodyUser.get_user_query_token(url=url).json()["data"]:
            if str(email) == user_token.get("receiverAddress"):
                token = user_token.get("token")
                break
        if token is None:
            raise Exception("token is None")
        RequestBodyUser.confirm_user_register(url, token=token)
        return {"email": email, "password": password}

    @staticmethod
    def confirm_user_register(url, token):
        requests.post(url=f"{url}/user/user-confirmation", json={"token": token})

    @staticmethod
    def get_user_query_token(url):
        resp = requests.post(url=f"{url}/private/user/query-user-token")
        return resp

    @staticmethod
    def random_int(length) -> int:
        return random.randint(int("1" + "0" * (length - 1)), int("9" * length))


if __name__ == "__main__":
    RequestBodyUser.create_email("https://mik.qa.platform.michaels.com/api/usr")
