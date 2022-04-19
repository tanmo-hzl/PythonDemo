*** Settings ***
Resource  ../EnvData.robot

*** Variables ***
${ENV}    qa
${Home URL}      https://mik.${ENV}.platform.michaels.com
${BROWSER}       Chrome
${Track Order Suffix}     track-my-order
${Delivery Instruction}   SDD Delivery Instruction - Please put the package under the PO BOX
${Updated ZipCode}        76039

${Short Waiting Time}       6
${Mid Waiting Time}         25
${Long Waiting Time}        50

${Plus Mark}            //div[@role='button' and @aria-label='button to increment counter for number stepper']
${Class Plus Mark}      //p[contains(text(), "Subtotal")]/preceding-sibling::div/child::div/child::div/following-sibling::div
${Store Plus Mark}      //svg[@class='icon icon-tabler icon-tabler-plus' and @width='20' and @height='20']
${Cart Icon Element}    //p[text()="Sign In"]/parent::div/parent::button/following-sibling::button/child::div/child::div/child::p
${Time Initial}         20
${Store Address}        2901 Rio Grande Blvd, Ste 700, Euless, TX, 76039
${Initial Store Name}   Glade Parks

${Order Number}   Not Created
@{options}        --disable-geolocation
&{arguments}      args=${options}
&{Desired_CAP}    firefoxOptions=${arguments}
#2901 Rio Grande Blvd, Euless, TX 76039

&{guestInfo}    firstName=MO
...             lastName=DD
...             addressLine1=2701 Rio Grande Blvd
...             city=Euless
...             state=TX
...             zipCode=76039
...             email=ui_cart_smoke@snapmail.cc
...             phoneNumber=469-779-6009



&{billAddress}    firstName=MO
...               lastName=DD
...               addressLine1=2435 Marfa Ave
...               city=Dallas
...               state=TX
...               zipCode=75216
...               phoneNumber=469-779-6009


&{classInfo}    firstName1=Class1
...          lastName1=Info1
...          email1=class_smoke1@snapmail.cc
...          phoneNumber1=469-779-1111
...          firstName2=Class2
...          lastName2=Info2
...          email2=class_smoke2@snapmail.cc
...          phoneNumber2=469-779-2222
...          firstName3=Class3
...          lastName3=Info3
...          email3=class_smoke3@snapmail.cc
...          phoneNumber3=469-779-3333
...          firstName4=Class4
...          lastName4=Info4
...          email4=class_smoke4@snapmail.cc
...          phoneNumber4=469-779-4444
...          firstName5=Class5
...          lastName5=Info5
...          email5=class_smoke5@snapmail.cc
...          phoneNumber5=469-779-5555
...          firstName6=Class6
...          lastName6=Info6
...          email6=class_smoke6@snapmail.cc
...          phoneNumber6=469-779-6666
...          firstName7=Class7
...          lastName7=Info7
...          email7=class_smoke7@snapmail.cc
...          phoneNumber7=469-779-7777


&{pickupInfo}    firstName=Pickup
...              lastName=Info
...              email=ui_cart_smoke@snapmail.cc
...              phoneNumber=469-779-6009

&{addtionalPickInfo}    firstNameAdditional=AddPick
...                     lastNameAdditional=AddInfo
...                     emailAdditional=additional_person@snapmail.cc

&{creditInfo}   cardHolderName=JOHN BELL
...             cardNumber=5155718238074354
...             expirationDate=10/23
...             cvv=123

&{giftInfo}     giftCard=6006496912999904202
...             pin=8185


&{paypalInfo}   email=sb-upbk56551725@personal.example.com
...             password=Testing@123


&{buyer}     user=lisa@snapmail.cc     password=Aa123456
&{buyer2}    user=july@snapmail.cc     password=Aa123456
&{buyer3}    user=habe@snapmail.cc     password=Aa123456
&{buyer4}    user=alice@snapmail.cc     password=Aa123456

&{account_info}    first_name=Lisa    last_name=Luo    address=2901 Rio Grande Blvd,Euless,TX,76039-1339
...     		   phone=619-876-5675    email=lisa@snapmail.cc

&{signin_CC_info}    credit_card_number=4112344112344113    card_type=Visa     expiration=01/30
&{signin_giftInfo}     giftCard=6006496912999904723    pin=9722


&{store1_info}    store_name=Glade Parks    store_address=2901 Rio Grande Blvd, Ste 700, Euless, 76039, TX     store_phone=682-503-7937     city=DFW-EULESS, TX
&{store2_info}    store_name=MacArthur Park     store_address=7635 N MacArthur Blvd, Irving, 75063, TX     store_phone=972-501-0525    city=DFW-IRVING     zipcode=75063

${pickup_location_in_buy_now}     Glade Parks,2901 Rio Grande Blvd, Ste 700,Euless,76039,682-503-7937
${pickup_location_in_order_detail}    2901 Rio Grande Blvd, Euless, TX 76039-1339


&{pickup_additional}      firstNameAdditional=mo
...                       lastNameAdditional=do
...                       emailAdditional=neivi@snapmail.cc