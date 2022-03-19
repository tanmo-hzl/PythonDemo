import datetime
import os
import random
import string
import time


class RequestBodyOrderManagement(object):
    def __init__(self):
        self.root_path = self.__get_root_path()

    @staticmethod
    def get_default_downloads_path():
        user_path = os.path.expanduser("~")
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
    def __get_root_path():
        abspath = os.path.dirname(os.path.abspath(__file__))
        root_path = os.path.dirname(os.path.dirname(abspath))
        return root_path

    @staticmethod
    def get_add_shipment_item_body(order_number, order_lines):
        shipment_item_list = []
        for item in order_lines:
            item_dict = {
                "quantity": item.get("quantity"),
                "orderItemId": item.get("orderItemId"),
                "uom": "EA",
            }
            shipment_item_list.append(item_dict)
        body = {
            "orderNumber": order_number,
            "shipmentsList": [
                {
                    "trackingNumber": "".join(
                        map(
                            lambda x: random.choice(
                                string.digits + string.ascii_letters
                            ),
                            range(10),
                        )
                    ),
                    "carrier": random.choice(["UPS", "USPS", "FEDEX", "DHL"]),
                    "carrierTrackingUrl": "https://www.ups.com/us/en/Home.page",
                    "shippingLabel": None,
                    "shipmentItemList": shipment_item_list,
                }
            ],
        }
        return body

    @staticmethod
    def get_cancel_item_body(order_number, order_lines):
        cancel_order_lines = []
        for item in order_lines:
            item_dict = {
                "orderItemId": item.get("orderItemId"),
                "quantity": item.get("quantity"),
                "cancelReason": "Out of Stock",
            }
            cancel_order_lines.append(item_dict)
        body = {"orderNumber": order_number, "cancelOrderLines": cancel_order_lines}
        return body

    @staticmethod
    def get_download_order_export_param(status):
        end_time = int(time.mktime(datetime.date.today().timetuple())) * 1000
        start_time = end_time - 30 * 24 * 60 * 60 * 1000
        param = f"statusList={status}&isAll=false&startTime={start_time}&endTime={end_time}&channel=2&timeZone=8"
        return param

    @staticmethod
    def get_order_overview_param(statuses, page_num=1, page_size=10):
        time_base = int(time.mktime(datetime.date.today().timetuple())) * 1000
        param = {
            "channels": 2,
            "type": 1,
            "pageNum": page_num,
            "pageSize": page_size,
            "dateStatusAggregate": True,
            "isAlone": True,
            "statuses": statuses if statuses else "",
            "timeBase": time_base,
        }
        return param

    @staticmethod
    def get_seller_return_param(statuses, page_num=1, page_size=10,):
        time_base = int(time.mktime(datetime.date.today().timetuple())) * 1000
        param = {
            "channels": 2,
            "type": 2,
            "pageNum": page_num,
            "pageSize": page_size,
            "dateStatusAggregate": True,
            "isAlone": True,
            "statuses": statuses if statuses else "",
            "timeBase": time_base,
        }
        return param

    @staticmethod
    def get_seller_dispute_param(statuses, page_num=1, page_size=10):
        time_base = int(time.mktime(datetime.date.today().timetuple())) * 1000
        param = {
            "channels": 2,
            "type": 3,
            "pageNum": page_num,
            "pageSize": page_size,
            "dateStatusAggregate": True,
            "isAlone": True,
            "statuses": statuses if statuses else "",
            "timeBase": time_base,
        }
        return param

    @staticmethod
    def get_seller_process_refund(return_order_number, action_items):
        return_order_lines = []
        print(action_items)
        for item in action_items:
            if item.get("action") == "approveRefund":
                return_line = {
                    "orderAfterSalesItemId": item.get("orderAfterSalesItemId"),
                    "action": item.get("action"),
                    "refundRejectReason": None,
                }
                return_order_lines.append(return_line)
            else:
                return_line = {
                    "orderAfterSalesItemId": item.get("orderAfterSalesItemId"),
                    "action": item.get("action"),
                    "refundRejectReason": "Automation reject reason",
                }
                return_order_lines.append(return_line)
        body = {
            "returnOrderNumber": return_order_number,
            "returnOrderLines": return_order_lines,
        }
        return body

    @staticmethod
    def get_seller_make_decision_body(order_item_id, offer_type, seller_offered_amount=0,  is_refund_shipping_fee=0):
        """
        :param order_item_id:
        :param seller_offered_amount:
        :param is_refund_shipping_fee:
        :param offer_type: NO_OFFER, REFUND, PARTIAL_REFUND
        :return:
        """
        body = [
            {
                "orderItemId": order_item_id,
                "sellerOfferedAmount": seller_offered_amount,
                "offerType": offer_type,
                "offerReason": "automation make decision",
                "isRefundShippingFee": is_refund_shipping_fee
            }
        ]
        return body


if __name__ == "__main__":
    print(int(time.time() * 1000))
    print(int(time.mktime(datetime.date.today().timetuple())) * 1000)
