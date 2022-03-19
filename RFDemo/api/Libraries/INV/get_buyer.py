import json
import random
import string
def sku_generator():
    rand_four_letters = ""
    for _ in range(4):
        rand_four_letters = rand_four_letters + random.choice(string.ascii_letters)
    rand_three_number = str(int(random.random() * 1000))
    return rand_four_letters + rand_three_number

def edit_inventory(sku, avai, max):
    ed_inv = {
        "masterSkuNumber": "10621948",

        "addInventoryItemRos": [
            {
                "skuNumber": sku,
                "availableQuantity": avai,
                "minSaleQuantity": "1",
                "maxSaleQuantity": max,
                "alertQuantityThrehold": "101"
            }
        ],
        "editInventoryItemRos": [
            {
                "inventoryId": "5479105791150153728",
                "adjustAvailableQuantity": "9960",
                "adjustType": 1
            }
        ]
    }
    return json.dumps(ed_inv)



