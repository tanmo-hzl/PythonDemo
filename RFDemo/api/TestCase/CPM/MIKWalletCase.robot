*** Settings ***
Resource         ../../TestData/EnvData.robot
Resource         ../../Keywords/CPM/UserKeywords.robot
Resource         ../../Keywords/CPM/WalletKeywords.robot
Suite Setup      Run Keywords    Set Initial Data - MIK - User
Suite Teardown   Delete All Sessions

*** Test Cases ***
Test GET Bank Card List
    [Tags]    MIK_Bank_Card
    ${user_id}    get json value    ${User_Inof}    user    id
    Mik Get Wallet Bank Card - GET    ${user_id}
