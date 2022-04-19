*** Settings ***



*** Keywords ***
Close popup Cannot Transaction
    Wait Until Page Contains Elements Ignore Ad  //*[contains(text(),"Sorry, we cannot process your transaction.")]
    Click Element   //*[contains(text(),"Sorry, we cannot process your transaction.")]/../following-sibling::button


Page 404 Message
    Wait Until Page Contains Elements Ignore Ad   //div[text()="It seems the feature is currently unavailable"]


