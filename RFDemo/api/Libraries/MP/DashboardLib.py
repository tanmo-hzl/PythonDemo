import datetime
import json
import time

import jsonpath
import requests


class DashboardLib(object):

    def get_order_list_num(self, url, headers, params=None):
        headers['User-Agent'] = 'Custom'
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        totalPages = jsonpath.jsonpath(res, '$..totalPages')[0]

        orderPendingNum = 0
        shipmentNum = 0
        returnNum = 0
        disputeNum = 0
        for i in range(totalPages):
            params['currentPage'] = i
            response = requests.get(url, params, headers=headers)
            res = json.loads(response.text)
            orderList = jsonpath.jsonpath(res, '$..orderRspVoList')[0]
            for j in range(len(orderList)):
                order = orderList[j]
                status = order['status']
                createdTime = order['createdTime']
                if status == 3000:
                    orderPendingNum = orderPendingNum + 1
                elif status == 3500 or status == 6800:
                    shipmentNum = shipmentNum + 1
                elif status == 10500 or status == 11000 or status == 11500 or status == 12000 or status == 14000 or status == 15000 or status == 17000:
                    returnNum = returnNum + 1
                elif status == 30000 or status == 30200 or status == 31000:
                    disputeNum = disputeNum + 1
        statusNum = {'orderPending': orderPendingNum, 'shipments': shipmentNum, 'returns': returnNum,
                     'disputes': disputeNum}
        return statusNum

    def get_order_list_sell(self, baseURL, headers, params=None):
        headers['User-Agent'] = 'Custom'
        listURL = baseURL + '/moh/order/v5/seller/orderList/page'
        response = requests.get(listURL, params, headers=headers)
        res = json.loads(response.text)
        totalPages = jsonpath.jsonpath(res, '$..totalPages')[0]
        yesterdayDate = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        pastSevenDaysDate = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        pastThirtyDaysDate = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        pastYearDate = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        allTimeDate = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        yesterdayONSet = set()
        pastSevenONSet = set()
        pastThirtyONSet = set()
        pastYearONSet = set()
        allTimeONSet = set()
        originalAllSet = set()

        today_zero = self.get_begin_timestamp_by_input(0)
        today_eight = today_zero + 8 * 60 * 60
        current_time = time.time()
        is_yesterday_update = True
        if current_time < today_eight:
            is_yesterday_update = False

        yesterday = (
            int(self.get_begin_timestamp_by_input(-1) * 1000),
            int(self.get_begin_timestamp_by_input(0) * 1000))
        pastSevenDay = (
            int(self.get_begin_timestamp_by_input(-7) * 1000),
            int(self.get_begin_timestamp_by_input(0) * 1000))
        pastThirtyDay = (
            int(self.get_begin_timestamp_by_input(-30) * 1000),
            int(self.get_begin_timestamp_by_input(0) * 1000))
        pastYear = (
            int(self.get_begin_timestamp_by_input(-365) * 1000),
            int(self.get_begin_timestamp_by_input(0) * 1000))
        allTime = (
            int(self.get_begin_timestamp_by_input(-365*50) * 1000),
            int(self.get_begin_timestamp_by_input(0) * 1000))

        for i in range(totalPages):
            params['currentPage'] = i
            response = requests.get(listURL, params, headers=headers)
            res = json.loads(response.text)
            orderList = jsonpath.jsonpath(res, '$..orderRspVoList')[0]
            for j in range(len(orderList)):
                order = orderList[j]
                createdTime = int(order['createdTime'])
                orderNumber = order['orderNumber']
                status = order['status']
                # query single order detail
                singleURL = baseURL + '/moh/order/v5/seller/single?orderNumber=' + orderNumber + '&simpleMode=false'
                singleResponse = requests.get(singleURL, headers=headers)
                singleRes = json.loads(singleResponse.text)
                singleData = singleRes['data']
                orderLines = singleData['orderLines']
                totalItemQuantity = 0
                for k in range(len(orderLines)):
                    orderLine = orderLines[k]
                    totalItemQuantity = totalItemQuantity + orderLine['quantity']

                originalItemsSubtotal = singleData['originalItemsSubtotal']
                allDiscount = singleData['allDiscount']
                shippingHandlingCharge = singleData['shippingHandlingCharge']

                if int(status) >= 3000:
                    originalAllSet.add(orderNumber)
                    if (createdTime >= allTime[0] and createdTime < allTime[1]):
                        allTimeDate['sales'] = allTimeDate[
                                                   'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        allTimeDate['orders'] = allTimeDate['orders'] + 1
                        allTimeDate['soldUnits'] = allTimeDate['soldUnits'] + totalItemQuantity
                        allTimeONSet.add(orderNumber)

                    if (createdTime >= yesterday[0] and createdTime < yesterday[1]):
                        yesterdayDate['sales'] = yesterdayDate[
                                                     'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        yesterdayDate['orders'] = yesterdayDate['orders'] + 1
                        yesterdayDate['soldUnits'] = yesterdayDate['soldUnits'] + totalItemQuantity
                        yesterdayONSet.add(orderNumber)
                    if (createdTime >= pastSevenDay[0] and createdTime < pastSevenDay[1]):
                        pastSevenDaysDate['sales'] = pastSevenDaysDate[
                                                         'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        pastSevenDaysDate['orders'] = pastSevenDaysDate['orders'] + 1
                        pastSevenDaysDate['soldUnits'] = pastSevenDaysDate['soldUnits'] + totalItemQuantity
                        pastSevenONSet.add(orderNumber)
                    if (createdTime >= pastThirtyDay[0] and createdTime < pastThirtyDay[1]):
                        pastThirtyDaysDate['sales'] = pastThirtyDaysDate[
                                                          'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        pastThirtyDaysDate['orders'] = pastThirtyDaysDate['orders'] + 1
                        pastThirtyDaysDate['soldUnits'] = pastThirtyDaysDate['soldUnits'] + totalItemQuantity
                        pastThirtyONSet.add(orderNumber)
                    if (createdTime >= pastYear[0] and createdTime < pastYear[1]):
                        pastYearDate['sales'] = pastYearDate[
                                                    'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        pastYearDate['orders'] = pastYearDate['orders'] + 1
                        pastYearDate['soldUnits'] = pastYearDate['soldUnits'] + totalItemQuantity
                        pastYearONSet.add(orderNumber)

        if not is_yesterday_update:
            # allTime
            allTimeDate['sales'] = allTimeDate['sales'] - yesterdayDate['sales']
            allTimeDate['orders'] = allTimeDate['orders'] - yesterdayDate['orders']
            allTimeDate['soldUnits'] = allTimeDate['soldUnits'] - yesterdayDate['soldUnits']
            allTimeONSet = allTimeONSet - yesterdayONSet
            # pastYearDate
            pastYearDate['sales'] = pastYearDate['sales'] - yesterdayDate['sales']
            pastYearDate['orders'] = pastYearDate['orders'] - yesterdayDate['orders']
            pastYearDate['soldUnits'] = pastYearDate['soldUnits'] - yesterdayDate['soldUnits']
            pastYearONSet = pastYearONSet - yesterdayONSet
            # passThirtyDate
            pastThirtyDaysDate['sales'] = pastThirtyDaysDate['sales'] - yesterdayDate['sales']
            pastThirtyDaysDate['orders'] = pastThirtyDaysDate['orders'] - yesterdayDate['orders']
            pastThirtyDaysDate['soldUnits'] = pastThirtyDaysDate['soldUnits'] - yesterdayDate['soldUnits']
            pastThirtyONSet = pastThirtyONSet - yesterdayONSet
            # passSevenDate
            pastSevenDaysDate['sales'] = pastSevenDaysDate['sales'] - yesterdayDate['sales']
            pastSevenDaysDate['orders'] = pastSevenDaysDate['orders'] - yesterdayDate['orders']
            pastSevenDaysDate['soldUnits'] = pastSevenDaysDate['soldUnits'] - yesterdayDate['soldUnits']
            pastSevenONSet = pastSevenONSet - yesterdayONSet
            # yesterdayDate
            yesterdayDate['sales'] = 0
            yesterdayDate['orders'] = 0
            yesterdayDate['soldUnits'] = 0
            # yesterdayONSet = yesterdayONSet.clear()

        orderNumberList = {
            'yesterdayONSet': yesterdayONSet,
            'pastSevenONSet': pastSevenONSet,
            'pastThirtyONSet': pastThirtyONSet,
            'pastYearONSet': pastYearONSet,
            'allTimeONSet': allTimeONSet,
            'originalAllSet':originalAllSet
        }
        print("current_time", datetime.datetime.now())
        print(orderNumberList)
        allSellerData = {
            'yesterdayDate': yesterdayDate,
            'pastSevenDaysDate': pastSevenDaysDate,
            'pastThirtyDaysDate': pastThirtyDaysDate,
            'pastYearDate': pastYearDate,
            'allTimeDate': allTimeDate}

        return allSellerData

    def get_begin_timestamp_by_input(self, num):
        '''
        Gets the start timestamp of how many days before or after the current time
        (获得当前时间前多少天或后多少天的开始时间戳)
        :param num:
        :return:
        '''
        now_time = datetime.datetime.now()
        yesterdayStr = (now_time + datetime.timedelta(days=num)).strftime("%Y-%m-%d")
        yesterdayStructTime = time.strptime(yesterdayStr, '%Y-%m-%d')
        yesterdayStamp = time.mktime(yesterdayStructTime)
        return yesterdayStamp

    def get_str_by_flag(self, flag):
        strDict = {'1': 'yesterdayDate', '2': 'pastSevenDaysDate', '3': 'pastThirtyDaysDate', '4': 'pastYearDate',
                   '5': 'allTimeDate'}
        return strDict[flag]

    def get_listings_status_by_id(self, url, headers, params=None):
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        print(res)
        listings = jsonpath.jsonpath(res, '$..listings')[0]
        activeListingNum = 0
        inactiveListingNum = 0
        lowInventoryListingNum = 0
        for i in range(len(listings)):
            listingData = listings[i]
            status = listingData['status']
            inventory = listingData['inventory']
            if status == 'Active':
                activeListingNum = activeListingNum + 1
            if status == 'Inactive':
                inactiveListingNum = inactiveListingNum + 1
            if status == 'Active' and int(inventory) <= 5:
                lowInventoryListingNum = lowInventoryListingNum + 1

        resData = {'active': activeListingNum, 'inactive': inactiveListingNum, 'lowInventory': lowInventoryListingNum}
        return resData

    def get_finance_balance_data(self, url, headers, params=None):
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        print(res['availableBalance'])
        return res['availableBalance']


if __name__ == '__main__':
    pass
