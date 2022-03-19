*** Settings ***
Resource  ../../TestData/EnvData.robot

*** Variables ***
&{default_headers}    Content-Type=application/json
...                   accept=*/*
...                   User-Agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.55 Safari/537.36 Edg/96.0.1054.43


# Api of promotion and coupon

${mpe_match_apply}                   api/coupon/matchApply
${mpe_apply_coupon}                  apply/coupon

${mpe_promotion_bundle}              promotion/bundle/add
${mpe_offer_skus}                    api/offer/
${mpe_redeem}                        api/redeem
${mpe_getlongcodekm}                 api/getLongCodeKM
${mpe_lookup_coupon_Ams}             api/lookupCouponAms
${mpe_matchapply}                    api/coupon/matchapply
${mpe_promotion_top}                 api/promotion/top



#promotion
${mpe_promotion_list}                promotion/list
${mpe_promotion_add}                 promotion/add
${mpe_promotion_coupon_list}         promotion/couponList
${mpe_get_group}                     group/get/
${mpe_get_promotion}                 api/promotion/id/


#coupon
${mpe_get_coupon_list}                coupon/ids/


#ppa
${mpe_save_GroupMapping}              ppa/saveGroupMapping
${mpe_promotion_mapping}              ppa/savePromotionMapping