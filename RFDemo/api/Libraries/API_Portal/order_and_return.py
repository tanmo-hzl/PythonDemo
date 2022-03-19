import random
import time


class order_and_return():

    def __init__(self):
        pass

    @staticmethod
    def get_error_item(data):
        error_item = {
            "quantity": 1,
            "orderItemId": "000"
        }
        data['shipmentsList'][0]['shipmentItemList'].append(error_item)
        return data

    @staticmethod
    def get_shipment_error_order(data):
        data['orderNumber'] = 'abc123'
        return data

    @staticmethod
    def get_error_ready_order():
        data = {
            "orderNumbers": [
                "abc123"
            ]
        }
        return data

    @staticmethod
    def get_error_item_status(data):
        content = data['shipmentsList'][0]['shipmentItemList'][0]
        data['shipmentsList'][0]['shipmentItemList'] = [content]
        return data

    @staticmethod
    def get_cancel_error_order(data):
        data['orderNumber'] = 'abc123'
        data['cancelOrderLines'][0]['orderItemId'] = 'abc123'
        return data

    @staticmethod
    def get_cancel_error_item(data):
        data['cancelOrderLines'][0]['orderItemId'] = 'abc123'
        return data

    @staticmethod
    def get_error_approve_refund(data):
        data['returnNumber'] = 'abc123'
        return data

    @staticmethod
    def get_error_approve_refund_item(data):
        data['returnItemIds'].append('abc123')
        return data

    @staticmethod
    def get_error_reject_refund(data):
        data['returnNumber'] = 'abc123'
        return data

    @staticmethod
    def get_error_reject_refund_item(data):
        content = {
            "returnItemId": "abc123",
            "refundRejectReason": "reject",
            "refundRejectComment": "reject",
            "sellerRejectRefundMedia": [
                ""
            ]
        }
        data['returnLines'].append(content)
        return data

    @staticmethod
    def get_error_process_refund_item(data):
        content = {
            "action": "REJECT",
            "returnItemId": "abc123",
            "refundRejectReason": "reject",
            "refundRejectComment": "reject",
            "sellerRejectRefundMedia": [
                ""
            ]
        }
        data['returnLines'].append(content)
        content = {
            "action": "APPROVE",
            "returnItemId": "def456",
        }
        data['returnLines'].append(content)
        return_num = data['returnNumber']
        if not return_num:
            data['returnNumber'] = '000'
        return data

    @staticmethod
    def set_invalid_track_number(data,track_number):

        data['shipmentsList'][0]['trackingNumber'] = track_number
        return data

    @staticmethod
    def set_invalid_carrier(data,carrier):

        data['shipmentsList'][0]['carrier'] = carrier
        return data

    @staticmethod
    def delete_ship_key(data,key1,key2=''):

        if not key2:
            del data['shipmentsList'][0][key1]
        else:
            del data['shipmentsList'][0][key1][0][key2]
        return data

    @staticmethod
    def delete_cancel_key(data,key1,key2=''):

        if not key2:
            del data[key1]
        else:
            del data[key1][0][key2]
        return data

    @staticmethod
    def get_exceed_cancel_reason(data):

        data['cancelReason'] = '1'*257
        return data

    @staticmethod
    def add_order_item(data,reason):

        content = {
            'orderItemId': '123',
            'orderItemCancelReason': reason
        }
        data['cancelOrderLines'].append(content)
        return data

    @staticmethod
    def get_random_query_return():

        data = {}
        time_stamp = int(time.time()) * 1000
        start_time = time_stamp - random.randint(864000000, 864000000*10)
        end_time = time_stamp - random.randint(0, 864000000)
        statu_list = ['PENDING_RETURN','REFUND_REJECTED','REFUNDED','CANCELLED','READY_TO_REFUND']
        isAsc_list = [True,False,'']
        data['startTime'] = start_time
        data['end_time'] = end_time
        data['orderNumber'] = ''
        data['returnNumber'] = ''
        data['returnStatusList'] = random.choice(statu_list)
        data['isAsc'] = random.choice(isAsc_list)
        data['pageNumber'] = random.randint(1,100)
        data['pageSize'] = random.randint(1,200)
        return data

    @staticmethod
    def delete_return_key(data,key1,key2=''):

        try:
            if not key2:
                del data[key1]
            else:
                del data[key1][0][key2]
            return data
        except Exception:
            return data

    @staticmethod
    def delete_reject_reason(data):

        return_num = data['returnNumber']
        if not return_num:
            return data
        else:
            data['returnLines'][0]['action'] = 'REJECT'
            if 'refundRejectReason' in data['returnLines'][0]:
                del data['returnLines'][0]['refundRejectReason']
        return data

    @staticmethod
    def change_reject_data(data, action, reason=''):

        return_num = data['returnNumber']
        if not reason:
            reason = '1'*500
        if not return_num:
            return data
        else:
            data['returnLines'][0]['action'] = action
            data['returnLines'][0]['refundRejectReason'] = reason
        return data

