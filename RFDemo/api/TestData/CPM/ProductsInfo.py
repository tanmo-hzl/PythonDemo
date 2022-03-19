class ProductsInfo(object):
    def __init__(self):
        pass

    @staticmethod
    def get_payment():
        return {
            "gift_card": [{"payment_method": "gift_card", "balance": "2000"}],
            "gift_card_id": [{"payment_method": "gift_card"}],
            "insufficient_gift_card": [{"payment_method": "gift_card", "balance": "1"}],
            "enough_gift_card": [{"payment_method": "gift_card"}],
            "credit_id": [{"payment_method": "credit_id"}],
            "multi_gift_card": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card"},
            ],
            "multi_gift_card_insufficient": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card", "balance": "1"},
            ],
            "multi_gift_card_zero": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card", "balance": "0"},
            ],
            "multi_gift_card_enough": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card", "balance": "2000"},
            ],
            "multi_gift_card_credit_card_id": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card"},
                {"payment_method": "credit_id"},
            ],
            "multi_gift_card_credit_card": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card"},
                {"payment_method": "credit"},
            ],
            "gift_card_credit_card_id": [
                {"payment_method": "gift_card"},
                {"payment_method": "credit_id"},
            ],
            "gift_card_credit_card": [
                {"payment_method": "gift_card"},
                {"payment_method": "credit"},
            ],
            "gift_card_gift_card_id": [
                {"payment_method": "gift_card"},
                {"payment_method": "gift_card", "balance": "2000"},
            ],
            "multi_gift_card_number": [
                {"payment_method": "gift_card", "balance": "2000"},
                {"payment_method": "gift_card", "balance": "2000"},
            ],
            "guest_gift_card_credit_card": [
                {"payment_method": "gift_card", "balance": "2000"},
                {"payment_method": "credit"},
            ],
            "guest_multi_gift_card_credit_card": [
                {"payment_method": "gift_card", "balance": "2000"},
                {"payment_method": "gift_card", "balance": "2000"},
                {"payment_method": "credit"},
            ],
            "guest_multi_gift_card_zero": [
                {"payment_method": "gift_card", "balance": "2000"},
                {"payment_method": "gift_card", "balance": "0"},
            ],
            "guest_multi_gift_card_insufficient": [
                {"payment_method": "gift_card", "balance": "2000"},
                {"payment_method": "gift_card", "balance": "1"},
            ],
        }

    @staticmethod
    def get_skus():
        return {
            "Test single MIK goods shipped by ISPU": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                }
            ],
            "Test single MIK goods shipped by GROUND_STANDARD": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                }
            ],
            "Test single MIK goods shipped by GROUND_SECONDDAY": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_SECONDDAY",
                }
            ],
            "Test single MIK goods shipped by GROUND_OVERNIGHT": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_OVERNIGHT",
                }
            ],
            "Test single MIK goods shipped by SAMEDAYDELIVERY": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                }
            ],
            "Test the modes of multiple transports ISPU and GROUND_STANDARD": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                },
                {
                    "skuNumber": 10665180,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
            ],
            "Test the modes of multiple transports ISPU and GROUND_OVERNIGHT": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                },
                {
                    "skuNumber": 10665180,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_OVERNIGHT",
                },
            ],
            "Test the same skuNumber different subSkuNumber": [
                {
                    "skuNumber": 10603162,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                    "attrs": "0: Medium,1: Safety Green",
                },
                {
                    "skuNumber": 10603162,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                    "attrs": "0: X-Small,1: Daisy",
                },
            ],
            "Test Submit Order Including :FGM, THP, MIK": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                },
                {
                    "skuNumber": 10665180,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_OVERNIGHT",
                },
                {"skuNumber": 6025999748069736448, "shipMethod": "STM"},
                {
                    "skuNumber": 6025999748069736448,
                    "shipMethod": "STM",
                    "variantTypeValues": {"Style": "Circle", "Size": "L"},
                },
                {
                    "skuNumber": 6147033163421171712,
                    "shipMethod": "STM",
                },
            ],
            "Test single MIK ARR goods shipped by DIGITAL": [
                {
                    "skuNumber": 920291327733013,
                    "Class": True,
                    "channel": "MIK",
                    "fees": True,
                },
            ],
            "Test the modes of multiple transports ISPU + DIGITAL+ GROUND_SECONDDAY + SAMEDAYDELIVERY": [
                {
                    "skuNumber": 920291327733013,
                    "Class": True,
                    "channel": "MIK",
                    "fees": True,
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_SECONDDAY",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                    "storeId": "2733",
                },
            ],
            "Test Submit Order Including :ARR , MIK, FGM, THP, Subscription, Bundle": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                },
                {
                    "skuNumber": 10665180,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_OVERNIGHT",
                },
                {"skuNumber": 6025999748069736448, "shipMethod": "STM"},
                {
                    "skuNumber": 6025999748069736448,
                    "shipMethod": "STM",
                    "variantTypeValues": {"Style": "Circle", "Size": "L"},
                },
                {"skuNumber": 10662935, "shipMethod": "STM", "intervalSeconds": 604800},
                {
                    "skuNumber": 6147033163421171712,
                    "shipMethod": "STM",
                },
                {
                    "skuNumber": 920291327733013,
                    "Class": True,
                    "channel": "MIK",
                    "fees": True,
                },
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
            ],
            "Test same sku Scription + buy": [
                {"skuNumber": 10662935, "shipMethod": "STM", "intervalSeconds": 604800},
                {"skuNumber": 10662935, "shipMethod": "STM"},
            ],
            "Pick up the same goods from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                    "storeId": "5062",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                    "storeId": "9985",
                },
            ],
            "Ship to me the same goods from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                    "storeId": "5062",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                    "storeId": "9985",
                },
            ],
            "SSD the same goods from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                    "storeId": "5062",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                    "storeId": "2733",
                },
            ],
            "Pick up and SSD the same sku from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                    "storeId": "5062",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                    "storeId": "2733",
                },
            ],
            "SSD and ship to me the same sku from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                    "storeId": "2733",
                },
            ],
            "Pick up and ship to me the same sku from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                    "storeId": "2733",
                },
            ],
            "Pick up and SSD and ship to me the same sku from different stores": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                    "storeId": "2733",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "SDD",
                    "shipping_method_type": "SAMEDAYDELIVERY",
                    "storeId": "5062",
                },
            ],
            "Test Submit Order For Single Bundle": [
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                }
            ],
            "Test same sku different options": [
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10138836", "10149448", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
            ],
            "Test same sku different options and options sku is error": [
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10522637", "10415686", "105198291"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
            ],
            "Test Weekly Subscription Orders": [
                {"skuNumber": 10633054, "shipMethod": "STM","canSchedule":True, "intervalSeconds": 604800}
            ],
            "Test Monthly Subscription Orders": [
                {"skuNumber": 10662935, "shipMethod": "STM", "intervalSeconds": 2592000}
            ],
            "Test Subscription Pay with a gift card": [
                {"skuNumber": 10662935, "shipMethod": "STM", "intervalSeconds": 604800}
            ],
            "Test payment by credit card": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test using a gift card with an insufficient balance": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by credit card Id": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + gift card enough to pay": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + gift card Not enough to pay": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card(balance 0) + gift card": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card(enough payment) + credit card id": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + gift card +credit card": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + credit card id": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + credit card": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + gift card id": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card + gift card": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card Id": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test payment by gift card": [{"skuNumber": 10662935, "shipMethod": "STM"}],
            "Test user did not bind the gift card payment": [
                {"skuNumber": 10662935, "shipMethod": "STM"}
            ],
            "Test ARR for several different channels": [
                {
                    "skuNumber": 920291327733013,
                    "Class": True,
                    "channel": "MIK",
                    "fees": True,
                },
                {
                    "skuNumber": 819136355251685,
                    "Class": True,
                    "channel": "FGM",
                    "fees": True,
                },
            ],
            "Test the mode of transportation for single THP goods is Expected": [
                {
                    "skuNumber": 6212377070740824064,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_EXPEDITED",
                },
            ],
            "Test the mode of transportation for single THP goods is THP_STANDARD": [
                {
                    "skuNumber": 6212377070740824066,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
            ],
            "Test the mode of transportation for single THP goods is Freight": [
                {
                    "skuNumber": 6147042509270876160,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_LTL_FREIGHT",
                },
            ],
            "Test the mode of transportation for single THP goods is Free": [
                {
                    "skuNumber": 28256763322957824,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
            ],
            "Test the mode of transportation for single FGM goods is FGM_STANDARD": [
                {
                    "skuNumber": 6117878513099513856,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_STANDARD",
                },
            ],
            "Test the mode of transportation for single FGM goods is FGM_SECOND_DAY_AIR": [
                {
                    "skuNumber": 6229949706093740032,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
            ],
            "Test FGM Same store, same mode of delivery FGM_SECOND_DAY_AIR": [
                {
                    "skuNumber": 6035402840230043648,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
                {
                    "skuNumber": 6229949706093740032,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
            ],
            "Test the mode of transportation for single FGM ARR goods is DIGITAL": [
                {
                    "skuNumber": 819136355251685,
                    "Class": True,
                    "channel": "FGM",
                    "fees": True,
                },
            ],
            "Test Same store, different mode of delivery": [
                {
                    "skuNumber": 6274729447439523840,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
                {
                    "skuNumber": 6274711820893741056,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_THREE_DAY_SELECT",
                },
            ],
            "Test Different store,same mode of delivery FGM_THREE_DAY_SELECT": [
                {
                    "skuNumber": 6274844964879917056,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_THREE_DAY_SELECT",
                },
                {
                    "skuNumber": 6274711820893741056,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_THREE_DAY_SELECT",
                },
            ],
            "Test Different store,different mode of delivery": [
                {
                    "skuNumber": 6117878513099513856,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_STANDARD",
                },
                {
                    "skuNumber": 6274711820893741056,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_THREE_DAY_SELECT",
                },
            ],
            "Test Different store,mix mode of delivery": [
                {
                    "skuNumber": 6274844964879917056,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_THREE_DAY_SELECT",
                },
                {
                    "skuNumber": 6035402840230043648,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
                {
                    "skuNumber": 819136355251685,
                    "Class": True,
                    "channel": "FGM",
                    "fees": True,
                },
            ],
            "Test Single FGM ARR": [
                {
                    "skuNumber": 819136355251685,
                    "Class": True,
                    "channel": "FGM",
                    "fees": True,
                }
            ],
            "Test items in different stores For THP": [
                {
                    "skuNumber": 6212377070740824066,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
                {
                    "skuNumber": 6212377070740824064,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_EXPEDITED",
                },
            ],
            "Test items in different stores For FGM": [
                {
                    "skuNumber": 6274711820893741056,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_THREE_DAY_SELECT",
                },
                {
                    "skuNumber": 6117878513099513856,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_STANDARD",
                },
            ],
            "Test Goods With The Same SKU For FGM Arr": [
                {
                    "skuNumber": 819136355251685,
                    "Class": True,
                    "channel": "FGM",
                    "fees": True,
                },
                {
                    "skuNumber": 819136355251685,
                    "Class": True,
                    "channel": "FGM",
                    "fees": True,
                },
            ],
            "Test Goods With The Same SKU For THP": [
                {
                    "skuNumber": 6212377070740824066,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
                {
                    "skuNumber": 6212377070740824066,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
            ],
            "Test Goods With The Same SKU For MIK": [
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
            ],
            "Test Goods With The Same SKU For Bundles": [
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
            ],
            "Test Goods With The Same SKU For FGM": [
                {
                    "skuNumber": 6035402840230043648,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
                {
                    "skuNumber": 6035402840230043648,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_SECOND_DAY_AIR",
                },
            ],
            "Test different modes of transportation for multiple Bundles": [
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": "BN59509S",
                    "bundleSkus": [
                        "10525295",
                        "10159749",
                        "10469883",
                        "10487944",
                        "10103919",
                    ],
                    "bundleSkuCounts": ["1", "1", "1", "1", "1"],
                },
                {
                    "skuNumber": "BN60185S",
                    "bundleSkus": ["10649144", "10182281", "10240757"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
            ],
            "Test Bundle And MIK Goods By Different Shipping Method": [
                {
                    "skuNumber": "BN60185S",
                    "bundleSkus": ["10649144", "10182281", "10240757"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "PickUp",
                    "shipping_method_type": "ISPU",
                },
            ],
            "Test Bundle And FGM Goods": [
                {
                    "skuNumber": "BN60185S",
                    "bundleSkus": ["10649144", "10182281", "10240757"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": 6035402840230043648,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_STANDARD",
                },
            ],
            "Test Bundle And THP Goods": [
                {
                    "skuNumber": "BN60185S",
                    "bundleSkus": ["10649144", "10182281", "10240757"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": 6212377070740824066,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
            ],
            "Test Bundle And Other Goods": [
                {
                    "skuNumber": "BN60185S",
                    "bundleSkus": ["10649144", "10182281", "10240757"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": 6212377070740824066,
                    "shipMethod": "STM",
                    "shipping_method_type": "THP_STANDARD",
                },
                {
                    "skuNumber": 6035402840230043648,
                    "shipMethod": "STM",
                    "shipping_method_type": "FGM_STANDARD",
                },
            ],
            "Test add Multiple MIK items to cart Positive": [
                {
                    "skuNumber": 10666677,
                    "shipMethod": "STM",
                },
                {
                    "skuNumber": 10662935,
                    "shipMethod": "STM",
                },
                {
                    "skuNumber": "BN59517S",
                    "bundleSkus": ["10265456", "10122057", "10063415"],
                    "bundleSkuCounts": ["1", "1", "1"],
                },
                {
                    "skuNumber": "BN59509S",
                    "bundleSkus": [
                        "10525295",
                        "10159749",
                        "10469883",
                        "10487944",
                        "10103919",
                    ],
                    "bundleSkuCounts": ["1", "1", "1", "1", "1"],
                },
            ],
            "Non-existent sku": [
                {
                    "skuNumber": "43289428",
                    "shipMethod": "STM",
                    "shipping_method_type": "GROUND_STANDARD",
                },
            ],
            "The quantity of goods is 0": [{
                "skuNumber": "10662935",
                "shipMethod": "STM",
                "shipping_method_type": "GROUND_STANDARD",
                "quantity": 0,
            }],
        }


if __name__ == "__main__":
    for values in ProductsInfo.get_skus().values():
        for item in values:
            print(item.get("skuNumber"))
