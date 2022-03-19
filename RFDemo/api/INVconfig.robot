*** Variables ***
${env}   dev
#${host}    https://mik.%{TEST_ENV}.platform.michaels.com/api/inv
#${domain}    https://mik.%{TEST_ENV}.platform.michaels.com/api/{}
${host}    https://mik.${env}.platform.michaels.com/api/inv
${domain}    https://mik.${env}.platform.michaels.com/api/{}
&{server}   user=usr    admin=map
&{sign_in_path}    user=user/sign-in    admin=michaels-user/sign-in
&{default_headers}     Content-Type=application/json    user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36 Edg/96.0.1054.41

${omni_sign_in_host}    https://michv2-auth.omni.manh.com
${omni_sign_in_path}    oauth/token
${omni_host}    https://michv2.omni.manh.com

&{omni_inventory}    online_inventory=inventory/api/availability/availabilitydetail
...                  BOPIS_inventory=inventory/api/availability/location/availabilitydetail

&{inventory}    buyer=inventory/buyer
...             list=inventory/buyer/list
...             buy=inventory/buyer/buy
...             return=inventory/buyer/return
...             subscribe=inventory/buyer/subscribe
...             reservation=inventory/buyer/reservation
...             inventorys=inventory/store/inventorys
...             store_list=inventory/store/{storeId}/list

&{inventory_admin}    invs=inventory/store/inventorys
...                   list=inventory/store/{storeId}/list
...                   store_invs=inventory/store/{storeId}/inventorys

&{omni_inventory_admin}    inventory=inventory/omni/store/inventorys

&{price_admin}    single_info=price-admin/{sellerStoreId}/sku-price-info
...               batch_info=price-admin/{sellerStoreId}/batch-sku-price-info
...               inner_batch_info=price-admin/{sellerStoreId}/inner-batch-sku-price-info
...               price_by_store=price-admin/{sellerStoreId}/sku-price
...               info_by_store=price-admin/{sellerStoreId}/product-price-info
...               log_by_store=price-admin/{sellerStoreId}/product-price-log
...               preview_rule=price-admin/preview-sku-price-rule
...               preview_mastersku_rule=price-admin/preview-mastersku-price-rule

&{price_rule_admin}    price_rule=price-rule-admin/{sellerStoreId}/sku-price-rule
...                    batch_price_rule=price-rule-admin/{sellerStoreId}/batch-sku-price-rule
...                    inner_batch_price_rule=price-rule-admin/{sellerStoreId}/inner-batch-sku-price-rule

&{price_rule_management}    sku_price_rule=price-rule-manage/sku-price-rule

&{price}    sku=price/sku
...         mastersku=price/master-sku
...         sku_michaelsstoreid=price/sku-michaelsStoreId

&{price_management}    sku_price_info=price/manage/sku-price-info
...                    price_trends_info=price/manage/price-trends-info

&{inv_price_admin}    inv_price=inv-price/get

&{path}     inv=${inventory}
...         inv_admin=${inventory_admin}
...         price=${price}
...         price_admin=${price_admin}
...         price_rule=${price_rule_admin}

&{buyer_user}
...        email=weihua@michaels.com
...        password=Michaels2021
...        deviceName=Huawei Mate 30
...        deviceUuid=d520c7a8-421b-4563-b955-f5abc56b97ec
...        deviceType=0

&{admin_user}
...        username=jin5@michaels.com
...        password=Michaels2021

&{scheduler}
...        username=shengyuan@michaels.com
...        password=Hello543207a

&{redis}    getredis=redisAdmin/setOrGet
...         host=10.16.13.206
...         port=6379
...         password=SRgYtMnKNk9yQa2h

&{omni_user}    grant_type=password
...             username=cody90-us
...             password=HankeGs7!@!@!@!@!@

