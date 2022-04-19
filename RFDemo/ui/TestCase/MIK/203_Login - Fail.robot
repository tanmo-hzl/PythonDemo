*** Settings ***
Documentation       This is the scenario where the login fails to authenticate
Resource       ../../TestData/EnvData.robot
Resource       ../../Keywords/MIK/LoginFailKeywords.robot
Resource       ../../Keywords/Common/CommonKeywords.robot
Suite Setup         Run Keywords     Initial Env Data  mik_config.ini
...         AND   Open Browser With URL   ${URL_MIK_SIGNIN}   mikLandingUrl
Suite Teardown      Close All Browsers
Test Teardown       Go To  ${URL_MIK_SIGNIN}

*** Test Cases ***
Test Sign up - A registered email address
    [Documentation]   Verify Sign in - A registered email address
    [Tags]  mik  mik-LoginFail  mik-registeredemail
    Sign up  ${BUYER_EMAIL}
    Wait Until Page Contains  Email address has already been associated with an account.

Test Sign in - password is incorrect ten times
    [Documentation]   Verify Sign in - password is incorrect ten times
    [Tags]  mik  mik-LoginFail  mik-TentimesFail
    FOR  ${num}  IN RANGE  1  11
        Sign in - Fail  summerfail@snapmail.cc  Password1234
        Wait Until Page Contains  The email or password you entered did not match our record
    END
    Sign in - Fail  summerfail@snapmail.cc  Password1234
    Wait Until Page Contains  Your account has been locked for 15 min

Test Sign in - not validate mailbox
    [Documentation]   Verify Sign up - not validate mailbox
    [Tags]  mik  mik-LoginFail  mik-SigninFail
    Sign in - Fail  summerNoVerify@snapmail.cc  Password123
    Wait Until Page Contains  The given email address has not been confirmed

Test Sign in - forget password
    [Documentation]   Verify Sign up - forget password
    [Tags]  mik  mik-LoginFail  mik-forgetpassword
    Sign In - Forget Password - change password  summerForgetPassword@snapmail.cc

Test Verify passwords in ciphertext and plain text
    [Documentation]   Verify passwords in ciphertext and plain text
    [Tags]  mik  mik-LoginFail  mik-ciphertextplain
    Verify passwords in ciphertext and plain text  Password123