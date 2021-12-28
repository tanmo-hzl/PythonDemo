import json
import jsonpath
import requests
import time
import datetime


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
        yesterdayONList = []
        pastSevenONList = []
        pastThirtyONList = []
        pastYearONList = []
        allTimeONList = []

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

                if int(status) >= 3000:
                    allTimeDate['sales'] = allTimeDate[
                                               'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                    allTimeDate['orders'] = allTimeDate['orders'] + 1
                    allTimeDate['soldUnits'] = allTimeDate['soldUnits'] + totalItemQuantity
                    allTimeONList.append(orderNumber)

                    if (createdTime >= yesterday[0] and createdTime < yesterday[1]):
                        yesterdayDate['sales'] = yesterdayDate[
                                                     'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        yesterdayDate['orders'] = yesterdayDate['orders'] + 1
                        yesterdayDate['soldUnits'] = yesterdayDate['soldUnits'] + totalItemQuantity
                        yesterdayONList.append(orderNumber)
                    if (createdTime >= pastSevenDay[0] and createdTime < pastSevenDay[1]):
                        pastSevenDaysDate['sales'] = pastSevenDaysDate[
                                                         'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        pastSevenDaysDate['orders'] = pastSevenDaysDate['orders'] + 1
                        pastSevenDaysDate['soldUnits'] = pastSevenDaysDate['soldUnits'] + totalItemQuantity
                        pastSevenONList.append(orderNumber)
                    if (createdTime >= pastThirtyDay[0] and createdTime < pastThirtyDay[1]):
                        pastThirtyDaysDate['sales'] = pastThirtyDaysDate[
                                                          'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        pastThirtyDaysDate['orders'] = pastThirtyDaysDate['orders'] + 1
                        pastThirtyDaysDate['soldUnits'] = pastThirtyDaysDate['soldUnits'] + totalItemQuantity
                        pastThirtyONList.append(orderNumber)
                    if (createdTime >= pastYear[0] and createdTime < pastYear[1]):
                        pastYearDate['sales'] = pastYearDate[
                                                    'sales'] + originalItemsSubtotal + shippingHandlingCharge - allDiscount
                        pastYearDate['orders'] = pastYearDate['orders'] + 1
                        pastYearDate['soldUnits'] = pastYearDate['soldUnits'] + totalItemQuantity
                        pastYearONList.append(orderNumber)

        orderNumberList = {
            'yesterdayONList': yesterdayONList,
            'pastSevenONList': pastSevenONList,
            'pastThirtyONList': pastThirtyONList,
            'pastYearONList': pastYearONList,
            'allTimeONList': allTimeONList
        }
        print("current_time",datetime.datetime.now())
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
            if status == 'Active' and inventory <= 5:
                lowInventoryListingNum = lowInventoryListingNum + 1

        resData = {'active': activeListingNum, 'inactive': inactiveListingNum, 'lowInventory': lowInventoryListingNum}
        return resData

    def get_finance_balance_data(self, url, headers, params=None):
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        print(res['availableBalance'])
        return res['availableBalance']


if __name__ == '__main__':
    dashboardLib = DashboardLib()
    # turl_dev = 'https://mik.dev.platform.michaels.com/api/store/5978490537827950592/listings'
    # turl_tst02 = 'https://mik.tst02.platform.michaels.com/api/store/5978490537827950592/listings'
    # Authorization_ak_tst02 = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI5OTA2NjAwMDEyODMwMTMiLCJfc2VsbGVyU3RvcmVJZCI6IjU5MDM2NzMwMzIxNjYxNDYwNDgiLCJfZGV2aWNlVXVpZCI6ImQ1MjBjN2E4LTQyMWItNDU2My1iOTU1LWY1YWJjNTZiOTdlYyIsIl9kZXZpY2VOYW1lIjoiQ2hyb21lIiwiX2NyZWF0ZVRpbWUiOiIxNjM5NTU2ODQzMDY0IiwiX2V4cGlyZVRpbWUiOiIxNjQyMTQ4ODQzMDY0Iiwic3ViIjoiOTkwNjYwMDAxMjgzMDEzIiwiaWF0IjoxNjM5NTU2ODQzLCJleHAiOjE2NDIxNDg4NDMsImF1ZCI6InVzZXIiLCJqdGkiOiJId3pvaHRKNGJHalMwdUtFbE5RNFA2QkpwdHZPTkFodSJ9.QCAnNsEbYDLxjbB882bIaPKcGkly33o5Ir3q9-41yYnNJyjAEeTIbm_1FZr0r2Yn0S98_mA2-zuYvRFIaHSrAw'
    # Authorization_testseller_tst02 = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI0NTA4MDEyOTQ0Mjc1NyIsIl9zZWxsZXJTdG9yZUlkIjoiNTkwMjk1MzU3MzYwNDQ1ODQ5NiIsIl9kZXZpY2VVdWlkIjoiNzkxODU3ODgtODgyYi00N2RiLWIzNTUtOTFhMGEyZWQ5MzM5IiwiX2RldmljZU5hbWUiOiJDaHJvbWUiLCJfY3JlYXRlVGltZSI6IjE2Mzk0NDU2MjE3MTciLCJfZXhwaXJlVGltZSI6IjE2Mzk3MDQ4MjE3MTciLCJzdWIiOiI0NTA4MDEyOTQ0Mjc1NyIsImlhdCI6MTYzOTQ0NTYyMSwiZXhwIjoxNjM5NzA0ODIxLCJhdWQiOiJ1c2VyIiwianRpIjoiMUQ2cHd1TklxdUFtZDduZTZZZGgyeFQ0Z29YbVJYeDEifQ.ozeepMx6HfQU3DRjcS97de19AK4W4xD9A-iN-vyngDuHKxq8PYvt8QicgGYDw5klJ7fRu5qAxyB5jHRQVhaTvg'
    # Authorization_bonrica_dev = 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI0NDA5MDQyMzM2NzA1NjUiLCJfc2VsbGVyU3RvcmVJZCI6IjU5Nzg0OTA1Mzc4Mjc5NTA1OTIiLCJfZGV2aWNlVXVpZCI6ImQ1MjBjN2E4LTQyMWItNDU2My1iOTU1LWY1YWJjNTZiOTdlYyIsIl9kZXZpY2VOYW1lIjoiQ2hyb21lIiwiX2NyZWF0ZVRpbWUiOiIxNjM5NTU5NjA2ODIzIiwiX2V4cGlyZVRpbWUiOiIxNjQyMTUxNjA2ODIzIiwic3ViIjoiNDQwOTA0MjMzNjcwNTY1IiwiaWF0IjoxNjM5NTU5NjA2LCJleHAiOjE2NDIxNTE2MDYsImF1ZCI6InVzZXIiLCJqdGkiOiJnMVJ0U0szdHhNZmxqSWFZb1R0eE03ek5FS1dBZWpTUiJ9.a_sk9E5_9gRU2DM4_g7kDfTPdwhD1MddUon-laSPzvETDhQn4QV0lNlx0hOLphWVFjGxQTbgdx_hWN8n4O6gKQ'
    # theaders = {'Content-Type': 'text/html;charset=utf-8',
    #             'Authorization': Authorization_bonrica_dev,
    #             'User-Agent': 'Custom'
    #             }
    # tparams = None
    # nums = dashboardLib.get_listings_status_by_id(turl_dev, theaders, tparams)
    # print(nums)
