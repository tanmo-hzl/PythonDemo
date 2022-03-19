import datetime
import json
import os
import random
import string
from itertools import product
from typing import Optional

import requests
from openpyxl import load_workbook
from requests_toolbelt.multipart.encoder import MultipartEncoder


class RequestBodyListing(object):
    def __init__(self):
        self.save_file_path = os.path.join(self.get_parent_path(), "CaseData")

    @staticmethod
    def get_default_downloads_path():
        user_path = os.path.expanduser('~')
        default_downloads_path = os.path.join(user_path, "Downloads")
        if not os.path.exists(default_downloads_path):
            os.mkdir(default_downloads_path)
        return default_downloads_path

    def delete_file_by_name_if_exist(self, file_name):
        default_downloads_path = self.get_default_downloads_path()
        download_file_list = os.listdir(default_downloads_path)
        for file in download_file_list:
            if file_name in file:
                file_path = os.path.join(default_downloads_path, file)
                os.remove(file_path)
        print(os.listdir(self.get_default_downloads_path()))

    def save_excel_file(self, file_name, res):
        file_path = os.path.join(self.get_default_downloads_path(), file_name)
        fp = open(file_path, "wb")
        fp.write(res.content)
        fp.close()

    @staticmethod
    def get_parent_path():
        """
        获取当前文件所在绝对路劲的上一层路径
        :return:
        """
        parent_path = os.path.dirname(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        )
        return parent_path

    def get_upload_file_path(self, file_name, project_dir_name=None):
        if project_dir_name is None:
            path = os.path.join(self.save_file_path, file_name)
        else:
            path = os.path.join(self.save_file_path, project_dir_name, file_name)
        return path

    def upload_img_to_cms(self, url, path, source_type="mik"):
        content_request = {
            "clientId": source_type,
            "sourceId": source_type,
            "clientName": source_type,
            "sourceType": source_type,
            "userId": "image",
            "byPassScreening": False,
            "imageRequest": {
                "mode": "AUTOMATIC",
                "forceCompressQuality": True,
                "webpFormatConversion": True,
            },
        }
        img_path = os.path.join(self.save_file_path, "API_Portal", "test-photo")
        file_name = random.choice(os.listdir(img_path))
        file_path = self.get_upload_file_path(file_name, "API_Portal/test-photo")
        img_file = open(file_path, "rb")
        multipart_encoder = MultipartEncoder(
            fields={
                "files": (file_name, img_file, "image/jpeg"),
                "contentRequest": (
                    "blob",
                    json.dumps(content_request).encode(),
                    "application/json",
                ),
            }
        )

        headers = {
            "Content-Type": multipart_encoder.content_type,
            # "Authorization": user_info.get("token"),
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:94.0) Gecko/20100101 Firefox/94.0",
        }
        response = requests.post(url + path, headers=headers, data=multipart_encoder)
        return response

    def import_listing_excel(self, url, token, file_name):
        file_path = os.path.join(self.get_default_downloads_path(), file_name)
        multipart_encoder = MultipartEncoder(
            fields={
                "file": (
                    file_path,
                    open(file_path, "rb"),
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                )
            }
        )
        headers = {
            "Content-Type": multipart_encoder.content_type,
            "authorization": token,
        }
        response = requests.post(
            f"{url}/listings/management/parse-excel-data",
            headers=headers,
            data=multipart_encoder,
        )
        print(response.json())
        if response.json()["code"] != "200":
            raise Exception(response.json()["stackTrace"])

    @staticmethod
    def get_create_listing_detail_body(items, available_to: Optional = None):
        item_name = "automation " + datetime.datetime.now().strftime("%m%d%H%M%S")
        item = random.choice(items)
        body = {
            "itemName": item_name,
            "categoryId": item.get("categoryID"),
            "categoryName": item.get("categoryName"),
            "categoryPath": item.get("categoryPath"),
            "brandName": "Automation",
            "manufactureName": "",
            "longDescription": "Automation Test",
            "tags": ["comb", "xmind", "vscode"],
            "availableFrom": datetime.datetime.now().strftime("%Y-%m-%d"),
            "availableTo": available_to if available_to else "",
            "timeZone": "Asia/Shanghai",
            "dynamicAttributes": {},
        }
        return body

    @staticmethod
    def get_inventory_and_pricing_body(upload_files, sku, quantity: Optional = None):
        medias = []
        for file in upload_files:
            media = {
                "mediaId": file.get("contentDataId"),
                "mediaUrl": file.get("url"),
                "createdTime": datetime.datetime.now().strftime(
                    "%Y-%m-%dT%H:%M:%S+00:00"
                ),
            }
            medias.append(media)
        body = {
            "price": str(random.randint(1, 50)),
            "quantity": quantity if quantity else str(random.randint(10, 10000)),
            "videoUrl": "",
            "medias": medias,
            "skuNumber": sku,
            "variantTypes": [""],
            "addImagesVariantType": "",
            "variantSwatchUrls": {},
            "variationDetails": [],
        }
        return body

    def get_with_variant_inventory_and_pricing_body(self, url, path, sku):
        res = self.upload_img_to_cms(url, path, "mik").json()
        uploaded_files = res["data"]["uploadedFiles"]
        medias = []
        if uploaded_files:
            for file in uploaded_files:
                media = {
                    "mediaId": file.get("contentDataId"),
                    "mediaUrl": file.get("url"),
                    "createdTime": datetime.datetime.now().strftime(
                        "%Y-%m-%dT%H:%M:%S+00:00"
                    ),
                }
                medias.append(media)
        variant_name_list = ("Color", "Model", "Size", "Count")
        variant_types = random.sample(variant_name_list, random.randint(1, 3))
        variant_contents = []
        for name in variant_types:
            name_list = []
            for j in range(random.randint(1, 2)):
                name_list.append(name + str(j))
            variant_contents.append(name_list)

        variation_details = []
        for variant_cont in product(*variant_contents):
            res = self.upload_img_to_cms(url, path, "mik").json()
            uploaded_files = res["data"]["uploadedFiles"]
            variation_media = []
            for file in uploaded_files:
                media_dict = {
                    "key": file.get("fileName"),
                    "status": "done",
                    "mediaUrl": file.get("url"),
                    "mediaId": file.get("contentDataId"),
                    "createdTime": datetime.datetime.now().strftime(
                        "%Y-%m-%dT%H:%M:%S+00:00"
                    ),
                }
                variation_media.append(media_dict)
            detail = {
                "status": 1,
                "price": str(random.randint(1, 20)),
                "inventory": str(random.randint(100, 5000)),
                "visible": True,
                "variantContents": variant_cont,
                "variationMedia": variation_media,
            }
            variation_details.append(detail)

        body = {
            "videoUrl": "",
            "medias": medias,
            "skuNumber": sku,
            "variantTypes": variant_types,
            "addImagesVariantType": variant_types[0],
            "variantSwatchUrls": {},
            "variationDetails": variation_details,
        }
        return body, variant_contents

    def get_shipping_and_return_body(self):
        gtn_type, gtn_nu = self.get_gtin_data()
        body = {
            "colorName": "",
            "globalTradeItemNumber": gtn_nu,
            "length": str(random.randint(1, 30)),
            "width": str(random.randint(1, 30)),
            "height": str(random.randint(1, 30)),
            "volume": str(random.randint(1, 30)),
            "weight": str(random.randint(1, 30)),
            "globalTradeItemNumberType": gtn_type,
            "weightUom": "lb",
            "groundShipOnly": random.choice((True, False)),
            "restrictAKHIShip": random.choice((True, False)),
            "giftingNote": True,
            "hazmatIndicator": False,
            "flammableContent": random.choice((True, False)),
            "overrideShippingRate": False,
            "overrideShippingReturnPolicy": True,
            "returnPolicyOption": "1",
            "refundOnly": False,
            "isRepeatGtin": False,
            "volumeUom": "Cu in",
            "lengthUom": "in",
            "widthUom": "in",
            "heightUom": "in",
        }
        return body

    def get_shipping_with_variant_body(self, variant_contents):
        variant_shipping_info = []
        for contents in product(*variant_contents):
            gtn_type, gtn_nu = self.get_gtin_data()
            shipping_info = {
                "volumeUom": "Cu in",
                "lengthUom": "in",
                "widthUom": "in",
                "heightUom": "in",
                "globalTradeItemNumberType": gtn_type,
                "globalTradeItemNumber": gtn_nu,
                "sellerSkuNumber": "",
                "length": str(random.randint(1, 20)),
                "width": str(random.randint(1, 20)),
                "height": str(random.randint(1, 20)),
                "volume": str(random.randint(1, 20)),
                "weight": str(random.randint(1, 20)),
                "weightUom": "lb",
                "variantContents": contents,
            }
            variant_shipping_info.append(shipping_info)
        body = {
            "groundShipOnly": random.choice((True, False)),
            "restrictAKHIShip": random.choice((True, False)),
            "giftingNote": False,
            "hazmatIndicator": False,
            "flammableContent": random.choice((True, False)),
            "overrideShippingRate": False,
            "overrideShippingReturnPolicy": True,
            "variantShippingInfo": variant_shipping_info,
        }
        return body

    @staticmethod
    def get_listing_variation_body():
        body = {
            "sku": "5891743262284455936",
            "price": 2,
            "quantity": 1,
            "masterSku": None,
            "cost": None,
            "additionalCost": None,
            "taxClass": "",
            "variants": [],
            "variationDetails": [],
            "percentOffOnPrice": 0,
            "percentOffOnRepeatDeliveries": 0,
            "listingVariantMediaUrlRequests": [],
        }
        return body

    @staticmethod
    def get_listing_upload_images_body():
        body = {
            "mediaUrls": [
                {
                    "mediaId": "5891752024017330176",
                    "mediaUrl": "https://imgproxy.tst.platform.michaels.com/XXTpt9MjeIKtJwhEo-W6WCFk1c9-K_Ll4qb5g7o5vco/aHR0cHM6Ly9zdG9yYWdlLmdvb2dsZWFwaXMuY29tL2Ntcy1taWstdHN0MDAvNTg5MTc1MjAyNDAxNzMzMDE3Ng.webp",
                    "createdTime": "2021-10-25T07:15:52.967+00:00",
                }
            ]
        }
        return body

    @staticmethod
    def get_listing_shipping_set_body():
        body = {
            "groundShipOnly": False,
            "restrictAKHIShip": False,
            "giftingNote": False,
            "hazmatIndicator": False,
            "flammableContent": False,
            "overrideShippingRate": False,
            "standardRate": None,
            "expeditedRate": None,
            "ltlFreightRate": None,
            "freeStandardShipping": False,
            "listingWeightAndWarningObjects": [],
            "returnPolicyOption": None,
            "refundOnly": False,
            "colorFamily": "Green",
            "globalTradeItemNumberType": "1",
            "globalTradeItemNumber": "556677889",
            "weight": "3",
            "volumeUom": "Cu in",
            "volume": "8",
            "lengthUom": "in",
            "widthUom": "in",
            "heightUom": "in",
            "weightUom": "lb",
            "length": "2",
            "width": "2",
            "height": "2",
            "cost": "0.67",
        }
        return body

    @staticmethod
    def get_gtin_data():
        gtn_type = str(random.randint(1, 7))
        if gtn_type in ("1", "2"):
            gtn_nu = "".join(map(lambda x: random.choice(string.digits), range(12)))
        elif gtn_type == "3":
            gtn_nu = "".join(map(lambda x: random.choice(string.digits), range(14)))
        elif gtn_type == "4":
            gtn_nu = "".join(map(lambda x: random.choice(string.digits), range(9)))
        elif gtn_type == "5":
            gtn_nu = "".join(map(lambda x: random.choice(string.digits), range(8)))
        elif gtn_type == "6":
            gtn_nu = "".join(map(lambda x: random.choice(string.digits), range(13)))
        elif gtn_type == "7":
            gtn_nu = "".join(map(lambda x: random.choice(string.digits), range(10)))
        else:
            gtn_nu = None

        return gtn_type, gtn_nu

    @staticmethod
    def get_create_listing_step1_body(items):
        item_name = "automation " + datetime.datetime.now().strftime("%m%d%H%M%S")
        item = random.choice(items)
        body = {
            "itemName": item_name,
            "categoryId": item.get("categoryID"),
            "categoryName": item.get("categoryName"),
            "categoryPath": item.get("categoryPath"),
            "brandName": "",
            "manufactureName": "",
            "longDescription": "gg",
            "tags": ["Gg"],
            "availableFrom": datetime.datetime.now().strftime("%Y-%m-%d"),
            "availableTo": "",
            "timeZone": "Asia/Shanghai",
            "dynamicAttributes": {},
            "sellerSkuNumber": "",
            "sku": "",
            "pageCode": 1,
        }
        return body

    @staticmethod
    def get_create_listing_step2_no_variants_body(sku_number, upload_files):
        medias = []
        for file in upload_files:
            media = {
                "mediaId": file.get("contentDataId"),
                "mediaUrl": file.get("url"),
                "createdTime": datetime.datetime.now().strftime(
                    "%Y-%m-%dT%H:%M:%S+00:00"
                ),
            }
            medias.append(media)
        body = {
            "quantity": "",
            "videoUrl": "",
            "medias": medias,
            "skuNumber": sku_number,
            "variantTypes": [""],
            "addImagesVariantType": "",
            "variantSwatchUrls": {},
            "variationDetails": [],
            "pageCode": 2,
        }
        return body

    @staticmethod
    def get_create_listing_step2_have_variants_body(sku_number, upload_files):
        medias = []
        for file in upload_files:
            media = {
                "mediaId": file.get("contentDataId"),
                "mediaUrl": file.get("url"),
                "createdTime": datetime.datetime.now().strftime(
                    "%Y-%m-%dT%H:%M:%S+00:00"
                ),
            }
            medias.append(media)
        body = {
            "videoUrl": "",
            "medias": medias,
            "skuNumber": sku_number,
            "variantTypes": ["Color", "Count"],
            "addImagesVariantType": "Color",
            "variantSwatchUrls": {
                "Red": "https://static.platform.michaels.com/mkp/red.webp",
                "Orange": "https://static.platform.michaels.com/mkp/Orange.webp",
            },
            "variationDetails": [],
            "pageCode": 2,
        }
        return body

    def get_create_listing_step3_no_variants_body(self, sku):
        gtn_type, gtn_nu = self.get_gtin_data()
        body = {
            "colorName": "",
            "globalTradeItemNumber": gtn_nu,
            "length": str(random.randint(1, 20)),
            "width": str(random.randint(1, 20)),
            "height": str(random.randint(1, 20)),
            "volume": str(random.randint(1, 20)),
            "weight": str(random.randint(1, 20)),
            "globalTradeItemNumberType": gtn_type,
            "weightUom": "lb",
            "groundShipOnly": False,
            "restrictAKHIShip": False,
            "giftingNote": False,
            "hazmatIndicator": False,
            "flammableContent": False,
            "overrideShippingRate": False,
            "overrideShippingReturnPolicy": False,
            "returnPolicyOption": "1",
            "refundOnly": False,
            "volumeUom": "Cu in",
            "lengthUom": "in",
            "widthUom": "in",
            "heightUom": "in",
            "pageCode": 3,
            "skuNumber": sku,
        }
        return body

    @staticmethod
    def get_create_listing_step3_have_variants_body(sku, variant_contents):
        variant_shipping_info = []
        for contents in product(*variant_contents):
            shipping_info = {
                "volumeUom": "Cu in",
                "lengthUom": "in",
                "widthUom": "in",
                "heightUom": "in",
                "variantContents": contents,
            }
            variant_shipping_info.append(shipping_info)
        body = {
            "groundShipOnly": False,
            "restrictAKHIShip": False,
            "giftingNote": False,
            "hazmatIndicator": False,
            "flammableContent": False,
            "overrideShippingRate": False,
            "overrideShippingReturnPolicy": False,
            "variantShippingInfo": variant_shipping_info,
            "pageCode": 3,
            "skuNumber": sku,
        }
        return body

    def get_publish_or_update_no_variants_body(self, sku, media):
        gtn_type, gtn_nu = self.get_gtin_data()
        item_name = "auto " + datetime.datetime.now().strftime("%m%d%H%M%S")
        body = {
            "skuNumber": sku,
            "itemName": item_name,
            "categoryPath": "root//Shop Categories//Sewing & Fabric",
            "vendorName": "automation",
            "longDescription": "automation test",
            "timeZone": "Asia/Shanghai",
            "medias": [
                {
                    "key": "",
                    "mediaId": media.get("mediaId"),
                    "mediaUrl": media.get("mediumUrl"),
                    "isUploadLoading": False,
                    "createdTime": media.get("createdTime"),
                }
            ],
            "videoUrl": "",
            "flammableContent": False,
            "categoryId": "186",
            "dynamicAttributes": {},
            "returnPolicyOption": "1",
            "brandName": "automation",
            "manufactureName": "",
            "tags": ["comb", "xmind", "vscode"],
            "availableFrom": "2022-02-23",
            "hazmatIndicator": False,
            "groundShipOnly": False,
            "restrictAKHIShip": False,
            "giftingNote": False,
            "overrideShippingRate": False,
            "expeditedRate": "",
            "ltlFreightRate": "",
            "overrideShippingReturnPolicy": False,
            "sellerSkuNumber": "",
            "refundOnly": False,
            "price": 10,
            "quantity": "10000",
            "colorName": "",
            "globalTradeItemNumber": gtn_nu,
            "globalTradeItemNumberType": gtn_type,
            "weightUom": "lb",
            "weight": "4",
            "volume": "6.00",
            "length": "1",
            "width": "2",
            "height": "3",
            "volumeUom": "Cu in",
            "lengthUom": "in",
            "widthUom": "in",
            "heightUom": "in",
        }
        return body

    def get_publish_or_update_have_variants_body(self, sku, data):
        item_name = "auto " + datetime.datetime.now().strftime("%m%d%H%M%S")
        media = data["listing"]["media"][0]
        sub_listings = data["subListings"]
        variation_details = []
        for sub_list in sub_listings:
            gtn_type, gtn_nu = self.get_gtin_data()
            variant_contents = []
            variant_type = sub_list["itemProperties"]["dynamicProperties"]
            for value in variant_type.values():
                variant_contents.append(value)
            variant_media = sub_list["media"][0]
            variation_detail = {
                "status": 1,
                "price": 6,
                "inventory": "1322",
                "visible": True,
                "globalTradeItemNumber": gtn_nu,
                "globalTradeItemNumberType": gtn_type,
                "weightUom": "lb",
                "weight": "4",
                "volume": "4.00",
                "length": "1",
                "width": "2",
                "height": "2",
                "volumeUom": "Cu in",
                "lengthUom": "in",
                "widthUom": "in",
                "heightUom": "in",
                "sellerSkuNumber": "",
                "skuNumber": sub_list["skuNumber"],
                "variantContents": variant_contents,
                "variationMedia": [
                    {
                        "key": "",
                        "createdTime": variant_media.get("createdTime"),
                        "mediaId": variant_media.get("mediaId"),
                        "mediaType": 0,
                        "mediaUrl": variant_media.get("mediumUrl"),
                    }
                ],
            }
            variation_details.append(variation_detail)
        body = {
            "skuNumber": sku,
            "itemName": item_name,
            "categoryPath": "root//Shop Categories//Frames//Table Frames//Document Frames",
            "vendorName": "Automation",
            "longDescription": "Automation Test",
            "timeZone": "Asia/Shanghai",
            "medias": [
                {
                    "key": "",
                    "mediaId": media.get("mediaId"),
                    "mediaUrl": media.get("mediumUrl"),
                    "isUploadLoading": False,
                    "createdTime": media.get("createdTime"),
                }
            ],
            "videoUrl": "",
            "flammableContent": False,
            "categoryId": "1861",
            "dynamicAttributes": {},
            "returnPolicyOption": 2,
            "brandName": "Automation",
            "manufactureName": "",
            "tags": ["comb", "xmind", "vscode"],
            "availableFrom": "2022-02-23",
            "hazmatIndicator": False,
            "groundShipOnly": False,
            "restrictAKHIShip": False,
            "giftingNote": False,
            "overrideShippingRate": False,
            "expeditedRate": "",
            "ltlFreightRate": "",
            "overrideShippingReturnPolicy": False,
            "sellerSkuNumber": "",
            "refundOnly": False,
            "variantTypes": ["Model", "Color", "Count"],
            "addImagesVariantType": "Color",
            "variantSwatchUrls": {},
            "variationDetails": variation_details,
        }
        return body

    @staticmethod
    def get_relist_inactivate_to_active_body(sku):
        body = {
            "skus": [sku],
            "startTime": datetime.datetime.now().strftime("%Y-%m-%d"),
            "endTime": "",
        }
        return body

    @staticmethod
    def get_can_export_listing(listing):
        status = ["ACTIVE", "INACTIVE", "DRAFT", "SOLD_OUT", "SUSPENDED", "EXPIRED"]
        can_export_list = []
        for list_info in listing:
            if list_info["status"].upper() in status:
                can_export_list.append(list_info["sku"])
        return can_export_list

    def update_listing_data(self, file_name):
        file_path = self.get_default_downloads_path()
        file_path = os.path.join(file_path, file_name)
        book = load_workbook(file_path)
        sheet = book["Template"]
        sheet['Y6'] = "2022-01-03"
        sheet['Z6'] = "2022-02-03"
        book.save(file_path)




if __name__ == "__main__":
    r = RequestBodyListing()
    # print(r.get_default_downloads_path())
    r.update_listing_data("All_listings_6102500606034460672.xlsx")

