import datetime
import random
import uuid
import os


class SignUpLib(object):
    def __init__(self):
        self.root_path = self.__get_root_path()
        self.cardList = ["4112344112344113", "4110144110144115", "5111005111051128"]
        self.address_list = [['12201', 'Albany', 'NY'],
                             ['30301', 'Atlanta', 'GA'],
                             ['21401', 'Annapolis', 'MD'],
                             ['21201', 'Baltimore', 'MD'],
                             ['35201', 'Birmingham', 'AL'],
                             ['14201', 'Buffalo', 'NY']]

    @staticmethod
    def __get_root_path():
        abspath = os.path.dirname(os.path.abspath(__file__))
        root_path = os.path.dirname(os.path.dirname(abspath))
        return root_path

    @staticmethod
    def get_random_data():
        return str(uuid.uuid1()).split("-")[0]

    def get_img_dir_path(self,quantity=1):
        img_dir_path = os.path.join(self.root_path, "CaseData", "MP", "IMG", str(quantity))
        return img_dir_path

    def get_random_img_path(self, quantity=1):
        img_dir_path = os.path.join(self.root_path, "CaseData", "MP", "IMG")
        img_list = os.listdir(img_dir_path)
        img_paths = []
        if int(quantity) == 1:
            img_path = os.path.join(img_dir_path, random.choice(img_list))
            print(img_path)
            return img_path
        else:
            images = random.sample(img_list, int(quantity))
            for item in images:
                img_paths.append(os.path.join(img_dir_path, item))
            print(img_paths)
            return img_paths

    @staticmethod
    def get_add_element_js():
        js = """
        var para=document.createElement("span");
var node=document.createTextNode("end");
para.appendChild(node);
var element=document.querySelector("#docx div");
element.appendChild(para);
        """
        return js

    def get_new_seller_info(self, env="tst03", cus_email=None):
        string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        all_category = ['Storage', 'Kids', 'Crafts', 'Decor', 'Art', 'Yarn', 'Papercraft', 'Jewelry', 'Baking', 'Craft Machines', 'Fabric', 'Wedding', 'Party', 'Frames']
        link = "https://www.{}.com"
        name_len = random.randint(5, 9)
        randomId = "".join(random.sample(string, name_len)).upper()
        address = random.choice(self.address_list)
        if cus_email is not None:
            email_prefix = "{}_{}".format(cus_email.lower(), env.lower())
            email = "{}_{}@snapmail.cc".format(cus_email.lower(), env.lower())
        else:
            email_prefix = "au_{}_{}".format(randomId.lower(), env.lower())
            email = "au_{}_{}@snapmail.cc".format(randomId.lower(), env.lower())
        body = {
            "name": "AU {}".format(randomId),
            "first_name": randomId,
            "last_name": "AUTO",
            "email_prefix": email_prefix,
            "email": email,
            "ein": random.randint(100000000, 999999999),
            "photos": self.get_random_img_path(2),
            "soldUS": True,  # //*[@id="switch-label"]/following-sibling::div/label
            "categories": random.sample(all_category, random.randint(1, len(all_category))),
            "links": [link.format("".join(random.sample(string, 5)).lower()), link.format("".join(random.sample(string, 6)).lower())],
            "numberOfSkus": random.randint(0, 3),
            "sales": random.randint(0, 3),
            "preferredMethod": random.randint(0, 2),
            "agree": True,
            "password": "",
            "manager": "{} Manager".format(randomId),
            "store_name": "Store{}".format(randomId),
            "address": {
                "address1": "{} FE Load".format(random.randint(100, 999)),
                "address2": "{} BE Load".format(random.randint(100, 999)),
                "city": address[1],
                "state": address[2],
                "zipcode": address[0]
            },
            "phone": "666777{}".format(random.randint(1000, 9999)),
            "bank_info": {
                "name": "Bank{}".format(randomId),
                "accountType": random.choice([0, 1]),
                "accountNumber": 10500008944,
                "routingNumber": random.randint(300000000, 999999999),
                "businessName": "Business{}".format(randomId)
            },
            "payment_info": {
                "cardHolderName": "Card {}".format(randomId),
                "bankCardNickName": "Nick {}".format(randomId),
                "expirationDate": "0{}{}".format(random.randint(1, 9), random.randint(26, 33)),
                "cardNumber": random.choice(self.cardList),
                "cvv": "{}".format(random.randint(100, 999))
            },
            "contact": {
                "days": ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
                "start": ["08", "00", "AM"],
                "end": ["07", "00", "PM"]
            },
            "department": random.choice(['Customer Care', 'Billing', 'Order Resolution', 'Technical Issues', 'Marketing']),
            "description": "Create description data is {}".format(datetime.datetime.now()),
            "shipmentCost": "{}.{}".format(random.randint(1, 9), random.randint(10, 99))
        }
        print(body)
        return body


if __name__ == '__main__':
    lib = SignUpLib()
    # print(lib.get_random_img_path())
    # print(lib.get_random_data())
    lib.get_new_seller_info("tst02")
