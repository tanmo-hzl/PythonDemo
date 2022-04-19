import json
import jsonpath
import requests
import time
import datetime
import pyperclip

class SellerDashboardLib(object):
    def __init__(self):
        pass

    def get_finance_sale_order_list(self, baseURL, sellerStoreId, headers, params=None):
        headers['User-Agent'] = 'Custom'
        listURL = baseURL + '/mda/store/' + sellerStoreId + '/finance/order/detail'
        response = requests.get(listURL, params, headers=headers)
        res = json.loads(response.text)
        totalPages = jsonpath.jsonpath(res, '$..totalPage')[0]

        yesterdayData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        doubleYesterdayData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        pastSevenDaysData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        doublePastSevenDaysData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        pastThirtyDaysData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        doublePastThirtyDaysData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        pastYearData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        doublePastYearData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        allTimeData = {'sales': 0, 'orders': 0, 'soldUnits': 0}
        yesterdayONSet = set()
        doubleYesterdayONSet = set()
        pastSevenONSet = set()
        doublePastSevenONSet = set()
        pastThirtyONSet = set()
        doublePastThirtyONSet = set()
        pastYearONSet = set()
        doublPastYearONSet = set()
        allTimeONSet = set()
        originalAllSet = set()

        today_zero = self.get_begin_datatime_by_input(0).timestamp()
        today_eight = today_zero + 8 * 60 * 60
        current_time = time.time()
        is_yesterday_update = True
        if current_time < today_eight:
            is_yesterday_update = False

        yesterday = (
            self.get_begin_datatime_by_input(-1),
            self.get_begin_datatime_by_input(0))
        doubleYesterday = (
            self.get_begin_datatime_by_input(-2),
            self.get_begin_datatime_by_input(-1))
        pastSevenDay = (
            self.get_begin_datatime_by_input(-7),
            self.get_begin_datatime_by_input(0))
        doublePastSevenDay = (
            self.get_begin_datatime_by_input(-14),
            self.get_begin_datatime_by_input(-7))
        pastThirtyDay = (
            self.get_begin_datatime_by_input(-30),
            self.get_begin_datatime_by_input(0))
        doublePastThirtyDay = (
            self.get_begin_datatime_by_input(-60),
            self.get_begin_datatime_by_input(-30))
        pastYear = (
            self.get_begin_datatime_by_input(-365),
            self.get_begin_datatime_by_input(0))
        doublePastYear = (
            self.get_begin_datatime_by_input(-730),
            self.get_begin_datatime_by_input(-365))
        allTime = (
            self.get_begin_datatime_by_input(-365 * 50),
            self.get_begin_datatime_by_input(0))

        for i in range(totalPages):
            params['currentPage'] = i
            response = requests.get(listURL, params, headers=headers)
            res = json.loads(response.text)
            balanceOrderList = jsonpath.jsonpath(res, '$..sellerBalanceOrderDetailsResponseList')[0]
            for j in range(len(balanceOrderList)):
                order = balanceOrderList[j]
                orderId = order['orderId']
                occurTime = datetime.datetime.fromisoformat(order['occurTime'])
                quantity = order['quantity']
                totalAmountWithShipping = order['totalAmountWithShipping']

                originalAllSet.add(orderId)

                if (occurTime >= allTime[0] and occurTime < allTime[1]):
                    allTimeData['sales'] = allTimeData['sales'] + totalAmountWithShipping
                    allTimeData['orders'] = allTimeData['orders'] + 1
                    allTimeData['soldUnits'] = allTimeData['soldUnits'] + quantity
                    allTimeONSet.add(orderId)

                if (occurTime >= yesterday[0] and occurTime < yesterday[1]):
                    yesterdayData['sales'] = yesterdayData['sales'] + totalAmountWithShipping
                    yesterdayData['orders'] = yesterdayData['orders'] + 1
                    yesterdayData['soldUnits'] = yesterdayData['soldUnits'] + quantity
                    yesterdayONSet.add(orderId)

                if (occurTime >= doubleYesterday[0] and occurTime < doubleYesterday[1]):
                    doubleYesterdayData['sales'] = doubleYesterdayData['sales'] + totalAmountWithShipping
                    doubleYesterdayData['orders'] = doubleYesterdayData['orders'] + 1
                    doubleYesterdayData['soldUnits'] = doubleYesterdayData['soldUnits'] + quantity
                    doubleYesterdayONSet.add(orderId)

                if (occurTime >= pastSevenDay[0] and occurTime < pastSevenDay[1]):
                    pastSevenDaysData['sales'] = pastSevenDaysData['sales'] + totalAmountWithShipping
                    pastSevenDaysData['orders'] = pastSevenDaysData['orders'] + 1
                    pastSevenDaysData['soldUnits'] = pastSevenDaysData['soldUnits'] + quantity
                    pastSevenONSet.add(orderId)

                if (occurTime >= doublePastSevenDay[0] and occurTime < doublePastSevenDay[1]):
                    doublePastSevenDaysData['sales'] = doublePastSevenDaysData['sales'] + totalAmountWithShipping
                    doublePastSevenDaysData['orders'] = doublePastSevenDaysData['orders'] + 1
                    doublePastSevenDaysData['soldUnits'] = doublePastSevenDaysData['soldUnits'] + quantity
                    doublePastSevenONSet.add(orderId)

                if (occurTime >= pastThirtyDay[0] and occurTime < pastThirtyDay[1]):
                    pastThirtyDaysData['sales'] = pastThirtyDaysData['sales'] + totalAmountWithShipping
                    pastThirtyDaysData['orders'] = pastThirtyDaysData['orders'] + 1
                    pastThirtyDaysData['soldUnits'] = pastThirtyDaysData['soldUnits'] + quantity
                    pastThirtyONSet.add(orderId)

                if (occurTime >= doublePastThirtyDay[0] and occurTime < doublePastThirtyDay[1]):
                    doublePastThirtyDaysData['sales'] = doublePastThirtyDaysData['sales'] + totalAmountWithShipping
                    doublePastThirtyDaysData['orders'] = doublePastThirtyDaysData['orders'] + 1
                    doublePastThirtyDaysData['soldUnits'] = doublePastThirtyDaysData['soldUnits'] + quantity
                    doublePastThirtyONSet.add(orderId)

                if (occurTime >= pastYear[0] and occurTime < pastYear[1]):
                    pastYearData['sales'] = pastYearData['sales'] + totalAmountWithShipping
                    pastYearData['orders'] = pastYearData['orders'] + 1
                    pastYearData['soldUnits'] = pastYearData['soldUnits'] + quantity
                    pastYearONSet.add(orderId)

                if (occurTime >= doublePastYear[0] and occurTime < doublePastYear[1]):
                    doublePastYearData['sales'] = doublePastYearData['sales'] + totalAmountWithShipping
                    doublePastYearData['orders'] = doublePastYearData['orders'] + 1
                    doublePastYearData['soldUnits'] = doublePastYearData['soldUnits'] + quantity
                    doublPastYearONSet.add(orderId)

        if not is_yesterday_update:
            # allTime
            allTimeData['sales'] = allTimeData['sales'] - yesterdayData['sales']
            allTimeData['orders'] = allTimeData['orders'] - yesterdayData['orders']
            allTimeData['soldUnits'] = allTimeData['soldUnits'] - yesterdayData['soldUnits']
            allTimeONSet = allTimeONSet - yesterdayONSet
            # pastYearData
            pastYearData['sales'] = pastYearData['sales'] - yesterdayData['sales']
            pastYearData['orders'] = pastYearData['orders'] - yesterdayData['orders']
            pastYearData['soldUnits'] = pastYearData['soldUnits'] - yesterdayData['soldUnits']
            pastYearONSet = pastYearONSet - yesterdayONSet
            # passThirtyData
            pastThirtyDaysData['sales'] = pastThirtyDaysData['sales'] - yesterdayData['sales']
            pastThirtyDaysData['orders'] = pastThirtyDaysData['orders'] - yesterdayData['orders']
            pastThirtyDaysData['soldUnits'] = pastThirtyDaysData['soldUnits'] - yesterdayData['soldUnits']
            pastThirtyONSet = pastThirtyONSet - yesterdayONSet
            # passSevenData
            pastSevenDaysData['sales'] = pastSevenDaysData['sales'] - yesterdayData['sales']
            pastSevenDaysData['orders'] = pastSevenDaysData['orders'] - yesterdayData['orders']
            pastSevenDaysData['soldUnits'] = pastSevenDaysData['soldUnits'] - yesterdayData['soldUnits']
            pastSevenONSet = pastSevenONSet - yesterdayONSet
            # yesterdayData
            yesterdayData['sales'] = 0
            yesterdayData['orders'] = 0
            yesterdayData['soldUnits'] = 0
            # yesterdayONSet = yesterdayONSet.clear()

        orderNumberList = {
            'yesterdayONSet': yesterdayONSet,
            'doubleYesterdayONSet': doubleYesterdayONSet,
            'pastSevenONSet': pastSevenONSet,
            'doublePastSevenONSet': doublePastSevenONSet,
            'pastThirtyONSet': pastThirtyONSet,
            'doublePastThirtyONSet': doublePastThirtyONSet,
            'pastYearONSet': pastYearONSet,
            'doublPastYearONSet': doublPastYearONSet,
            'allTimeONSet': allTimeONSet,
            'originalAllSet': originalAllSet
        }
        print("current_time:", datetime.datetime.now())
        # print('orderNumberList:', orderNumberList)

        allSellerData = {
            'yesterdayData': yesterdayData,
            'doubleYesterdayData': doubleYesterdayData,
            'pastSevenDaysData': pastSevenDaysData,
            'doublePastSevenDaysData': doublePastSevenDaysData,
            'pastThirtyDaysData': pastThirtyDaysData,
            'doublePastThirtyDaysData': doublePastThirtyDaysData,
            'pastYearData': pastYearData,
            'doublePastYearData': doublePastYearData,
            'allTimeData': allTimeData}

        # yesterday change rate
        yesterdayChangeRate = {'saleChangeRate': 0, 'orderChangeRate': 0, 'soldUnitChangeRate': 0}
        if (doubleYesterdayData['sales'] == 0):
            yesterdayChangeRate['saleChangeRate'] = None
        else:
            yesterdayChangeRate['saleChangeRate'] = (yesterdayData['sales'] - doubleYesterdayData['sales']) / \
                                                    doubleYesterdayData['sales']
        if (doubleYesterdayData['orders'] == 0):
            yesterdayChangeRate['orderChangeRate'] = None
        else:
            yesterdayChangeRate['orderChangeRate'] = (yesterdayData['orders'] - doubleYesterdayData['orders']) / \
                                                     doubleYesterdayData['orders']
        if (doubleYesterdayData['soldUnits'] == 0):
            yesterdayChangeRate['soldUnitChangeRate'] = None
        else:
            yesterdayChangeRate['soldUnitChangeRate'] = (yesterdayData['soldUnits'] - doubleYesterdayData[
                'soldUnits']) / doubleYesterdayData['soldUnits']

        # past seven days change rate
        pastSevenDaysChangeRate = {'saleChangeRate': 0, 'orderChangeRate': 0, 'soldUnitChangeRate': 0}
        if (doublePastSevenDaysData['sales'] == 0):
            pastSevenDaysChangeRate['saleChangeRate'] = None
        else:
            pastSevenDaysChangeRate['saleChangeRate'] = (pastSevenDaysData['sales'] - doublePastSevenDaysData[
                'sales']) / doublePastSevenDaysData['sales']
        if (doublePastSevenDaysData['orders'] == 0):
            pastSevenDaysChangeRate['orderChangeRate'] = None
        else:
            pastSevenDaysChangeRate['orderChangeRate'] = (pastSevenDaysData['orders'] - doublePastSevenDaysData[
                'orders']) / doublePastSevenDaysData['orders']
        if (doublePastSevenDaysData['soldUnits'] == 0):
            pastSevenDaysChangeRate['soldUnitChangeRate'] = None
        else:
            pastSevenDaysChangeRate['soldUnitChangeRate'] = (pastSevenDaysData['soldUnits'] - doublePastSevenDaysData[
                'soldUnits']) / doublePastSevenDaysData['soldUnits']

        # past thirty days change rate
        pastThirtyDaysChangeRate = {'saleChangeRate': 0, 'orderChangeRate': 0, 'soldUnitChangeRate': 0}
        if (doublePastThirtyDaysData['sales'] == 0):
            pastThirtyDaysChangeRate['saleChangeRate'] = None
        else:
            pastThirtyDaysChangeRate['saleChangeRate'] = (pastThirtyDaysData['sales'] - doublePastThirtyDaysData[
                'sales']) / doublePastThirtyDaysData['sales']
        if (doublePastThirtyDaysData['orders'] == 0):
            pastThirtyDaysChangeRate['orderChangeRate'] = None
        else:
            pastThirtyDaysChangeRate['orderChangeRate'] = (pastThirtyDaysData['orders'] - doublePastThirtyDaysData[
                'orders']) / doublePastThirtyDaysData['orders']
        if (doublePastThirtyDaysData['soldUnits'] == 0):
            pastThirtyDaysChangeRate['soldUnitChangeRate'] == None
        else:
            pastThirtyDaysChangeRate['soldUnitChangeRate'] = (pastThirtyDaysData['soldUnits'] -
                                                              doublePastThirtyDaysData['soldUnits']) / \
                                                             doublePastThirtyDaysData['soldUnits']

        # past year change rate
        pastYearChangeRate = {'saleChangeRate': 0, 'orderChangeRate': 0, 'soldUnitChangeRate': 0}
        if (doublePastYearData['sales'] == 0):
            pastYearChangeRate['saleChangeRate'] = None
        else:
            pastYearChangeRate['saleChangeRate'] = (pastYearData['sales'] - doublePastYearData['sales']) / \
                                                   doublePastYearData['sales']
        if (doublePastYearData['orders'] == 0):
            pastYearChangeRate['orderChangeRate'] == None
        else:
            pastYearChangeRate['orderChangeRate'] = (pastYearData['orders'] - doublePastYearData['orders']) / \
                                                    doublePastYearData['orders']
        if (doublePastYearData['soldUnits'] == 0):
            pastYearChangeRate['soldUnitChangeRate'] = None
        else:
            pastYearChangeRate['soldUnitChangeRate'] = (pastYearData['soldUnits'] - doublePastYearData['soldUnits']) / \
                                                       doublePastYearData['soldUnits']

        changeRate = {
            'yesterdayChangeRate': yesterdayChangeRate,
            'pastSevenDaysChangeRate': pastSevenDaysChangeRate,
            'pastThirtyDaysChangeRate': pastThirtyDaysChangeRate,
            'pastYearChangeRate': pastYearChangeRate
        }

        returnData = {
            'allSellerData': allSellerData,
            'changeRate': changeRate
        }

        print(returnData)
        return returnData

    def get_begin_datatime_by_input(self, num):
        '''
        Gets the start timestamp of how many days before or after the current time
        (获得当前时间前多少天或后多少天的开始时间)
        :param num:
        :return:
        '''
        now_time = datetime.datetime.now()
        pastManyDayStr = (now_time + datetime.timedelta(days=num)).strftime("%Y-%m-%d")
        pastManyDay = datetime.datetime.strptime(pastManyDayStr, '%Y-%m-%d').astimezone()
        return pastManyDay

    def get_str_by_flag(self, flag):
        strDict = {'1': 'yesterdayDate', '2': 'pastSevenDaysDate', '3': 'pastThirtyDaysDate', '4': 'pastYearDate',
                   '5': 'allTimeDate'}
        return strDict[flag]

    def get_finance_balance_data(self, baseURL, sellerStoreId, headers, params=None):
        url = baseURL + '/mda/store/' + sellerStoreId + '/finance/balance'
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        availableBalance = res['availableBalance']

        print('availableBalance=', availableBalance)
        return availableBalance


    def check_listings_number_by_status(self, baseURL, sellerStoreId, headers, businessActinsInfo, params=None):
        url = baseURL + '/mda/store/' + sellerStoreId + '/listings'
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        listStatusNum = jsonpath.jsonpath(res, '$..statusNum')[0]

        print('listStatusNum=', listStatusNum)
        print('businessActinsInfo=', businessActinsInfo['listing_info'])
        assert listStatusNum['Active'] == int(
            businessActinsInfo['listing_info']['Active']), "Listings Active Data is error"
        assert listStatusNum['Inactive'] == int(
            businessActinsInfo['listing_info']['Inactive']), "Listings Inactive Data is error"
        assert listStatusNum['Prohibited'] == int(
            businessActinsInfo['listing_info']['Prohibited']), "Listings Prohibited Data is error"
        assert listStatusNum['Draft'] == int(
            businessActinsInfo['listing_info']['Draft']), "Listings Draft Data is error"
        assert listStatusNum['Out of stock'] == int(
            businessActinsInfo['listing_info']['Out of stock']), "Listings Out of stock Data is error"
        assert listStatusNum['Pending Review'] == int(
            businessActinsInfo['listing_info']['Pending Review']), "Listings Pending Review Data is error"

    def check_orders_number_by_status(self, baseURL, headers, businessActinsInfo, params=None):
        url = baseURL + '/moh/search/order/seller/list/page'
        params = {
            'channels': 2,
            'type': 1,
            'pageNum': 1,
            'pageSize': 10,
            'dateStatusAggregate': True,
            'isAlone': True,
            'ignoreBuyerCancel': True
        }
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        responseOrderStatusNum = res['data']['aggregate']['status']
        orderStatusNum = {}
        orderStatusNum['Pending Confirmation'] = int(responseOrderStatusNum.get('3000', 0))
        orderStatusNum['Ready to Ship'] = int(responseOrderStatusNum.get('3500', 0))
        orderStatusNum['Partially Shipped'] = int(responseOrderStatusNum.get('6800', 0))

        print('orderStatusNum=', orderStatusNum)
        print("businessActinsInfo['order_info']=", businessActinsInfo['order_info'])
        assert orderStatusNum['Pending Confirmation'] == int(
            businessActinsInfo['order_info']['Pending Confirmation']), "Order Overview Pending_Confirmation Data is error"
        assert orderStatusNum['Ready to Ship'] == int(
            businessActinsInfo['order_info']['Ready to Ship']), "Order Overview Ready_to_Ship Data is error"
        assert orderStatusNum['Partially Shipped'] == int(
            businessActinsInfo['order_info']['Partially Shipped']), "Order Overview Pending_Confirmation Data is error"

    def check_return_orders_number_by_status(self, baseURL, headers, businessActinsInfo, params=None):
        url = baseURL + '/moh-rsc/afterSales/search/return/seller/list/page'
        params = {
            'channels': 2,
            'type': 2,
            'pageNum': 1,
            'pageSize': 10,
            'dateStatusAggregate': True,
            'isAlone': True
        }
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        responseReturnStatusNum = res['data']['aggregate']['status']
        returnStatusNum = {}
        returnStatusNum['Pending Return'] = int(responseReturnStatusNum.get('11000', 0)) + int(
            responseReturnStatusNum.get(
                '10500', 0)) + int(responseReturnStatusNum.get('17000', 0))
        returnStatusNum['Pending Refund'] = int(responseReturnStatusNum.get('16000', 0))

        print('returnStatusNum=', returnStatusNum)
        print("businessActinsInfo['order_info']=", businessActinsInfo['order_info'])
        assert returnStatusNum['Pending Return'] == int(
            businessActinsInfo['order_info']['Pending Return']), "Order Return Pending_Return Data is error"
        assert returnStatusNum['Pending Refund'] == int(
            businessActinsInfo['order_info']['Pending Refund']), "Order Return Pending_Refund Data is error"

    def check_dispute_orders_number_by_status(self, baseURL, headers, businessActinsInfo, params=None):
        url = baseURL + '/moh-rsc/afterSales/search/return/seller/list/page'
        params = {
            'channels': 2,
            'type': 3,
            'pageNum': 1,
            'pageSize': 10,
            'dateStatusAggregate': True
        }
        response = requests.get(url, params, headers=headers)
        res = json.loads(response.text)
        responseDisputeStatusNum = res['data']['aggregate']['status']
        disputeStatusNum = {}
        disputeStatusNum['Dispute Opened'] = int(responseDisputeStatusNum.get('30000', 0))
        disputeStatusNum['Dispute Escalated'] = int(responseDisputeStatusNum.get('32000', 0))

        print('disputeStatusNum=', disputeStatusNum)
        print("businessActinsInfo['order_info']=", businessActinsInfo['order_info'])
        assert disputeStatusNum['Dispute Opened'] == int(
            businessActinsInfo['order_info']['Dispute Opened']), "Order Dispute Dispute_Opened data is error"
        assert disputeStatusNum['Dispute Escalated'] == int(
            businessActinsInfo['order_info']['Dispute Escalated']), "Order Dispute Dispute_Escalated data is error"

    def check_promotion_number_by_status(self, baseURL, headers, businessActinsInfo, params=None):
        url = baseURL + '/mda/promotion/list'
        requestBody = {
            "end": "",
            "page": 1,
            "size": 100,
            "title": "",
            "statusQ": "",
            "start": "",
            "autoApplyQ": ""
        }
        resp = requests.post(url=url, headers=headers, json=requestBody)
        res = json.loads(resp.text)
        totalPages = jsonpath.jsonpath(res, '$..totalPages')[0]
        promotionStatus = {'Active': 0, 'Completed': 0, 'Draft': 0, 'Terminated': 0, 'Scheduled': 0, }
        for i in range(totalPages):
            requestBody['page'] = i + 1
            response = requests.post(url=url, headers=headers, json=requestBody)
            responseJSON = json.loads(response.text)
            promotionList = jsonpath.jsonpath(responseJSON, '$..content')[0]
            for j in range(len(promotionList)):
                if (promotionList[j]['status'] == 'Active'):
                    promotionStatus['Active'] = promotionStatus['Active'] + 1
                if (promotionList[j]['status'] == 'Completed'):
                    promotionStatus['Completed'] = promotionStatus['Completed'] + 1
                if (promotionList[j]['status'] == 'Draft'):
                    promotionStatus['Draft'] = promotionStatus['Draft'] + 1
                if (promotionList[j]['status'] == 'Terminated'):
                    promotionStatus['Terminated'] = promotionStatus['Terminated'] + 1
                if (promotionList[j]['status'] == 'Scheduled'):
                    promotionStatus['Scheduled'] = promotionStatus['Scheduled'] + 1

        print('promotionStatus=', promotionStatus)
        print("businessActinsInfo['marketing_info']=", businessActinsInfo['marketing_info'])
        assert promotionStatus['Active'] == int(
            businessActinsInfo['marketing_info']['Active']), "Promotion Active data is error"
        assert promotionStatus['Scheduled'] == int(
            businessActinsInfo['marketing_info']['Scheduled']), "Promotion Schedule data is error"
        assert promotionStatus['Completed'] == int(
            businessActinsInfo['marketing_info']['Completed']), "Promotion Completed data is error"
        assert promotionStatus['Draft'] == int(
            businessActinsInfo['marketing_info']['Draft']), "Promotion Draft data is error"
        assert promotionStatus['Terminated'] == int(
            businessActinsInfo['marketing_info']['Terminated']), "Promoiton Terminated data is error"


    def get_clipboard_text(self):
        print(pyperclip.paste())
        return pyperclip.paste()



if __name__ == '__main__':
    ds = SellerDashboardLib()
    pass
