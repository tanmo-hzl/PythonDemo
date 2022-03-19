*** Settings ***
Documentation       This is to Login Register Verify Setting
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/LoginRegisterSetting.robot
Resource       ../../Keywords/MIK/LoginFailKeywords.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...         AND   Open Browser With URL   ${URL_MIK_SIGNIN}   mikLandingUrl
Suite Teardown      Close All Browsers

*** Test Cases ***
Test Sign in - Ten times Fail
    [Documentation]   Verify Sign in - Ten times Fail
    [Tags]  mik  mik-LoginFail  mik-TentimesFail
    FOR  ${num}  IN RANGE  1  10
        Sign in  ${Ordinary_account}  ${Ordinary_account_pwd}
        Wait Until Page Contains  The email or password you entered did not match our record
    END
    Sign in Fail  ${Ordinary_account}  ${Ordinary_account_pwd}
    Wait Until Page Contains  Your account has been locked for 15 min

Test Sign up - Fail
    [Documentation]   Verify Sign up - Fail
    [Tags]  mik  mik-LoginFail  mik-SignupFail
    Sign up  summerNoVerify@snapmail.cc  Password123
    Go To  ${URL_MIK_SIGNIN}
    Sign in Fail ${email}  ${password}
    Wait Until Page Contains  The given email address has not been confirmed