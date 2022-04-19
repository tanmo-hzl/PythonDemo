import re
import time
import requests


class RequestBodyInventory(object):
    def __init__(self):
        pass

    @staticmethod
    def get_add_inventory_of_mahattan_body(
        quantity: int, store_id: str, sku_numbers: list
    ):
        body = {
            "quantity": quantity,
            "michaelsStoreId": store_id,
            "skuNumbers": sku_numbers,
        }
        return body

    @staticmethod
    def get_query_store_inventory_of_mahattan_body(store_id: str, sku_numbers: list):
        body = {"michaelsStoreId": store_id, "skuNumbers": sku_numbers}
        return body

    @staticmethod
    def get_edit_store_inventory_body(
        master_sku_number, channel, inventory_id_list, quantity
    ):
        edit_inventory_item_ros = []
        for inventory_id in inventory_id_list:
            inventory_item = {
                "inventoryId": inventory_id,
                "adjustAvailableQuantity": quantity,
                "adjustType": 1,
            }
            edit_inventory_item_ros.append(inventory_item)
        body = {
            "masterSkuNumber": master_sku_number,
            "token": "string",
            "channel": channel,
            "addInventoryItemRos": [],
            "editInventoryItemRos": edit_inventory_item_ros,
        }
        return body

    @staticmethod
    def init_gift_card(amount=2000):
        now = time.strftime("%Y%m%d6%H%M%S", time.localtime())
        transaction_id = f"REP{now[4:]}"
        init_url = (
            "https://webservices-cert.storedvalue.com/svsxml/v1/services/SVSXMLWay"
        )
        payload_xml = f"""<soapenv:Envelope 
                xmlns:ser="http://service.svsxml.svs.com" 
                xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" 
                xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext- 1.0.xsd">
                    <soapenv:Header>
                        <wsse:Security soapenv:mustUnderstand="1" xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
                            <wsse:UsernameToken>
                                <wsse:Username>msusg-cert</wsse:Username>
                                <wsse:Password>UQY3_Q@P^x9v&amp;d</wsse:Password>
                            </wsse:UsernameToken>
                        </wsse:Security>
                    </soapenv:Header>
                   <soapenv:Body>
                      <ser:issueVirtualGiftCard>
                         <request>
                            <date>2019-08-14T06:27:07</date>
                            <invoiceNumber>REP03517358</invoiceNumber>
                            <issueAmount>
                               <amount>{amount}</amount>
                               <currency>USD</currency>
                            </issueAmount>
                            <merchant>
                                <merchantName>Michael Stores</merchantName>
                                <merchantNumber>67352</merchantNumber>
                                <storeNumber>0000009490</storeNumber>
                                <division>00000</division>
                            </merchant>
                            <routingID>6006496911000000000</routingID>
                            <stan/>
                            <transactionID>{transaction_id}</transactionID>
                            <checkForDuplicate>true</checkForDuplicate>
                         </request>
                      </ser:issueVirtualGiftCard>
                   </soapenv:Body>
                </soapenv:Envelope>"""

        headers = {
            "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36"
        }
        s = requests.session()
        s.keep_alive = False
        s.headers = headers

        res = s.post(init_url, data=payload_xml)
        gift_card_info = res.text
        card_number = re.findall(r"<cardNumber>(.*)</cardNumber>", gift_card_info)[0]
        pin = re.findall(r"<pinNumber>(.*)</pinNumber>", gift_card_info)[0]

        card_info = {
            "card_number": card_number,
            "pin": pin[-4:],
            "balance": amount,
        }
        return card_info

    @staticmethod
    def get_add_gift_card_body(user_id, card_info):
        body = {
            "user": {"ownerType": "1", "userId": user_id},
            "giftCardNum": card_info.get("card_number"),
            "pinNum": card_info.get("pin"),
            "defaultCard": 1,
        }
        return body

    @staticmethod
    def get_delete_gift_card_body(gift_card_id, user_id):
        body = {"giftCardId": gift_card_id, "userId": user_id}
        return body

    @staticmethod
    def get_delete_credit_card_body(bank_card_id, user_id):
        body = {"bankCardId": bank_card_id, "userId": user_id}
        return body



if __name__ == "__main__":
    rr = RequestBodyInventory()
    card_dict = {
        2000: 1,
    }
    for amount in card_dict:
        for _ in range(card_dict[amount]):
            card = rr.init_gift_card(amount)
            print(card)
