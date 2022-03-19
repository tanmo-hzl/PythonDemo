*** Settings ***
#Library     ../../Libraries/CommonLibrary.py
#Resource    ../../Keywords/Mpe/applyVerifyKeywords.robot
Resource  ../../../Keywords/MPE/applyVerifyKeyWords.robot

*** Test Cases ***

promotion add
    [Tags]   applyaddpromotiondata      test66
    [Template]   Add promotion Case keyword
#    priority_160_AORPI_60%
#    priority_200_AORPI_40%
#    priority_180_AORPI_50%
#    priority_220_AORPI_30%
#    priority_240_AORPI_20%
#    priority_230_ERPP_25%
#    priority_220_ERPP_30%
#    priority_180_ERPP_50%
#    priority_200_ERPP_40%
#    priority_160_ERPP_60%
#    priority_240_ERPP_20%
#    priority_245_Entire_20%
#    priority_205_Entire_40%
#    priority_185_Entire_50%
#    priority95_buy&get discount_0.5,1_-1_1
#    buy&get discount_0.5,1_-1_1
#    priority95_buy&get price_15.99,1_-1_1
#    buy&get price_15.99,1_-1_1
#    priority95_buy&get discount_0,1_-1_1
#    buy&get discount_0,1_-1_1

#    discount_0.8_-1_1
#    Non-Coupon_Spend_$25_Get_$5       #?
#    price_7.99_-1_1
#    Non-Coupon_Entire_priority95_50%
#    Non-Coupon_Entire_priority95_20%
#    Non-Coupon_Entire_priority95_40%
#    Non-Coupon_ERPP_priority120_40%
#    Non-Coupon_ERPP_40%
#    Non-Coupon_ERPP_30%
#    Non-Coupon_ERPP_25%
#    Non-Coupon_Entire_50%
#    Non-Coupon_Entire_40%
#    Non-Coupon_Entire_20%
#    Non-Coupon_Spend_$40_Get_$10
#    Non_Disc
#    Non-Coupon_ERPP_20%
#    buy&get discount_0,1_-1_2
#    buy&get discount_0.5,1_-1_2
#    buy&get fixed-amount_15,1_-1_2
#    buy&get price_14.99,1_-1_2
#    discount_0.5_-1_3
#    discount_0.85_-1_1
#    price_17.99_-1_1
#    price_25.49_-1_1
#    price_5_-1_1   #3
#    price_3_-1_1      #3
#    price_11.99_-1_1
#    price_15.99_-1_1
#    price_14.99_-1_1
#    fixed-amount_4_-1_1
#    fixed-amount_10_-1_1
#    fixed-amount_15_-1_1
#    discount_0.4_-1_1   #3
#    discount_0.5_-1_1
#    discount_0.6_-1_1   #3
#    priority70_discount_0.5_-1_1  #3
#    fixed-amount_10_50_-1_fixed-amount_20_70_-1_fixed-amount_30_100_-1
#    discount_0.9_100_-1_discount_0.8_150_-1_discount_0.7_200_-1
#    discount_0.95_-1_3_discount_0.9_-1_5_discount_0.85_-1_10
#    priority95_discount_0.7_-1_1
#    discount_0.7_-1_1
#
#    buy&get discount_0.6,1_-1_1
#    buy&get fixed-amount_6,1_-1_1
#    AORPI_20%
##     test
#    priority_95_buy&get fixed-amount_10,1_-1_1
#    buy&get fixed-amount_10,1_-1_1


bundle promotion add
    [Tags]   applyaddpromotiondata
    [Template]   Add bundle promotion Case keyword
#    bundle_price_3item_100
#    priority95_Ba1Gb1_free
#    Ba1Gb1_free
    priority95_Ba2Gb1_free
    Ba2Gb1_free
#    Ba1Gb1_price4.99
#    Ba1Gb1_fixed-amount5
#    Ba1Gb1_50%
#    priority95_Ba1Gb1_50%
#    Ba1Gb1_10%