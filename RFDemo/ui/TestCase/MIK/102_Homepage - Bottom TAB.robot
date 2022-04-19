*** Settings ***
Documentation       This is the menu bar at the bottom of the verification home page
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/HomePage.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...      AND   Open Browser With URL   ${URL_MIK}   mikLandingUrl
Suite Teardown      Close All Browsers
Test Teardown     Go to   ${URL_MIK}

*** Test Cases ***
Test Click On The Bottom TAB For Resources
    [Documentation]   Click On The Bottom TAB For Resources
    [Tags]    mik  mik-home  mik-BottomTAB  mik-Resources  mik-dev
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
    [Tags]    mik  mik-home  mik-BottomTAB  mik-Quick  mik-dev
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

Test Click On The Bottom TAB For Special Discounts
    [Documentation]   Click On The bottom TAB For Special Discounts
    [Tags]    mik  mik-home  mik-BottomTAB  mik-Discounts  mik-dev
    ${Discounts_tab}  Create Dictionary  Michaels Rewards=Rewards
    ...  Teacher's Discount=Teacher Discount
    ...  Military Discount=Military Discount
    ...  Senior Discount=Senior Discount
    Click Bottom Table And Verify Title  Special Discounts  ${Discounts_tab}

Test Click On The Bottom TAB For Corporate
    [Documentation]   Click On The Bottom TAB For Corporate
    [Tags]    mik  mik-home  mik-BottomTAB  mik-Corporate  mik-dev
    ${Corporate_tab}  Create Dictionary  Inclusion and Diversity=Inclusion and Diversity
    ...  Work at Michaels=Work at Michaels
    ...  Great Place To Work=Working at Michaels Companies Inc
    ...  Michaels Gives Back=Giving Back
    ...  Investor Relations=The Michaels Companies
    ...  Newsroom=The Michaels Companies
    Click Bottom Table And Verify Title  Corporate  ${Corporate_tab}