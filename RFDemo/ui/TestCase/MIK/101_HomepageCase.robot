*** Settings ***
Documentation       This is to check the main screen data
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/HomePage.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data
...      AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers
Test Teardown     Go to   ${URL_MIK}

*** Test Cases ***
Test Click Top Left TAB Verify Title
    [Documentation]   Click Top Left TAB Verify Title
    [Tags]  mik  mik-home  mik-toplefttab
    ${element_dict}  Create Dictionary  Makerplace=Makerplace
    ...  Custom Framing=Michaels Custom Framing
    ...  Business/Enterprise=Michaels Pro
    ...  Business/Education=Michaels Pro
    ...  Michaels Family/Photo Gift=Photo Gifts, Photo Prints
    Click Top Table And Verify Title  ${element_dict}

Test Click Top Right TAB Verify Title
    [Documentation]   Click Top Right TAB Verify Title
    [Tags]  mik  mik-home  mik-toprighttab
    ${element_dict}  Create Dictionary
    ...  Michaels Rewards=Rewards - Enroll Today
    ...  Classes & Events=Online Art Classes for Kids and Adults
    ...  Projects=Crafting Projects
    ...  Weekly Ad=Weekly Ad | Michaels  Coupons=Coupons & Promo Codes
    ...  Gift Cards=Gift Cards
    Click Top Table And Verify Title  ${element_dict}

Test Click On The Bottom TAB For Resources
    [Documentation]   Click On The Bottom TAB For Resources
    [Tags]    mik  mik-home  mik-Resources
    ${Resources_tab}  Create Dictionary  Products Recalls=Product Recalls
    ...  Track My Order=Track Order   Return Policy=Return Policy
    ...  Shipping Policy=Shipping Policy  Tax Exempt=Tax Exempt
    ...  Coupon Policy and Price Guarantee=oupon Policy
    ...  Terms and Conditions=Terms and Conditions
    ...  Your Privacy Rights=Your Privacy Rights
    ...  CA Consumer Privacy Act=Privacy Web Form
    ...  CA Transparency in Supply Chains Act=${null}
    Click Bottom Table And Verify Title  Resources  ${Resources_tab}

Test Click On The Bottom TAB For Quick Links
    [Documentation]   Click On The Bottom TAB For Quick Links
    [Tags]    mik  mik-home  mik-Quick
    ${Quick_tab}  Create Dictionary  Curbside Pickup=Curbside Pickup
    ...  Same Day Delivery=Same Day Delivery
    ...  Download Our App=Download App
    ...  Easy Ways to Shop & Save=Easy Ways to Shop and Save
    ...  Customer Care=Customer Care
    ...  Store Locator=Store Locator
    ...  Accessibility=Accessibility
    ...  Site Map=Site Map  Marketplace=Third Party Marketplace
    ...  Affiliate Program=Affiliate Program
    ...  Michaels Canada=Michaels Stores
    Click Bottom Table And Verify Title  Quick Links  ${Quick_tab}

Test Click On The Bottom TAB For Discounts
    [Documentation]   Click On The bottom TAB For Discounts
    [Tags]    mik  mik-home  mik-Discounts
    ${Discounts_tab}  Create Dictionary  Michaels Rewards=Rewards
    ...  Teacher's Discount=Teacher Discount
    ...  Military Discount=Military Discount
    ...  Senior Discount=Senior Discount
    Click Bottom Table And Verify Title  Discounts  ${Discounts_tab}

Test Click On The Bottom TAB For Corporate
    [Documentation]   Click On The Bottom TAB For Corporate
    [Tags]    mik  mik-home  mik-Corporate
    ${Corporate_tab}  Create Dictionary  Inclusion and Diversity=Inclusion and Diversity
    ...  Work at Michaels=Work at Michaels
    ...  Great Place To Work=Working at Michaels Companies Inc
    ...  Michaels Gives Back=Giving Back
    ...  Investor Relations=The Michaels Companies
    ...  Newsroom=The Michaels Companies
    Click Bottom Table And Verify Title  Corporate  ${Corporate_tab}

Test Verify TRENDING NOW random Products
    [Documentation]   Verify TRENDING NOW
    [Tags]    mik  mik-home  mik-TRENDINGNOW
    FOR  ${v}  IN RANGE   1  5
        Verify Recommended Product Review  TRENDING NOW
    END

Test Verify YOU MAY ALSO LIKE random Products
    [Documentation]   Verify YOU MAY ALSO LIKE
    [Tags]    mik  mik-home  mik-YOUMAYALSOLIKE
    FOR  ${v}  IN RANGE   1  5
        Verify Recommended Product Review  YOU MAY ALSO LIKE
    END

Test Verify SHOP BY CATEGORY
    [Documentation]   Verify SHOP BY CATEGORY
    [Tags]    mik  mik-home  mik-SHOPBYCATEGORY
    Verify SHOP BY CATEGORY