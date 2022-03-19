*** Settings ***
Library     ../../../Libraries/MPE/GetBodyAndverifyData.py
Resource    ../../../Keywords/MPE/applyVerifyKeyWords.robot
Test Timeout     1 minutes

*** Test Cases ***
Percent50%OffvsPrice5–price5winning  #uc1
    [Tags]   mpe     matchapply     pptcase
    Verify Apply case keyword      Percent50%OffvsPrice5–price5winning(uc1)

50%OffvsPrice3–50%winning   #uc1a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsPrice3–50%winning(uc1a)
50%Offvs$5Off–50%Offwinning(uc2)  #uc2
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%Offvs$5Off–50%Offwinning

PercentOffvs$4Off–$4winning   #uc2a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PercentOffvs$4Off–$4winning

50%OffvsPrice14.99vs$15–AnyoneOfferCouldWin(uc3)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsPrice14.99vs$15–AnyoneOfferCouldWin(uc3)

40%OffvsPrice17.99vs$10–17.99AnyoneOfferCouldwin(uc3a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsPrice17.99vs$10–17.99AnyoneOfferCouldwin(uc3a)

40%vsPrice15.99vs$10–15.99priceWin(uc3b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%vsPrice15.99vs$10–15.99priceWin(uc3b)

60%OffvsBOGOFree(1item)–60%offwin(uc4)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBOGOFree(1item)–60%offwin(uc4)

60%OffvsBOGOFree(2item)–60%offwin(uc4a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBOGOFree(2item)–60%offwin(uc4a)

30%OffvsBOGOFree(1item)–30%offwin(uc5)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    30%OffvsBOGOFree(1item)–30%offwin(uc5)

30%OffvsBOGOFree(2item)–BOGOFreewin(uc5a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    30%OffvsBOGOFree(2item)–BOGOFreewin(uc5a)

40%OffvsBOGO50%(1item)–40%offwin(uc6)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBOGO50%(1item)–40%offwin(uc6)

40%OffvsBOGO50%(2item)–40%offwin(uc6a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBOGO50%(2item)–40%offwin(uc6a)

20%OffvsBOGO50%(1item)–20%offwin(uc7)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    20%OffvsBOGO50%(1item)–20%offwin(uc7)

20%OffvsBOGO50%(2item)–BOGO50%win(uc7a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    20%OffvsBOGO50%(2item)–BOGO50%win(uc7a)

40%OffvsBOGO$10(1item)–40%offwin(uc8)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBOGO$10(1item)–40%offwin(uc8)

40%OffvsBOGO$10(2item)–40%offwin(uc8a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBOGO$10(2item)–40%offwin(uc8a)

20%OffvsBOGO$10(2item)–BOGO$10win(uc9a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    20%OffvsBOGO$10(2item)–BOGO$10win(uc9a)

20%OffvsBOGO$10(1item)–20%offwin(uc9)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    20%OffvsBOGO$10(1item)–20%offwin(uc9)

40%OffvsBOGO$15.99(1item)–40%win(uc17)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBOGO$15.99(1item)–40%win(uc17)

40%OffvsBOGO$15.99(2item)–40%win(uc17a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBOGO$15.99(2item)–40%win(uc17a)

20%OffvsBOGO$15.99Off(1item)–20%offwin(uc17b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    20%OffvsBOGO$15.99Off(1item)–20%offwin(uc17b)

20%OffvsBOGO$15.99Off(2item)–BOGO$15.99win(uc17c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    20%OffvsBOGO$15.99Off(2item)–BOGO$15.99win(uc17c)

AORPI40%Vs50%Off–50%_win(uc18)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI40%Vs50%Off–50%_win(uc18)


AORPI40%Vs$price3_Off–price3_win(uc18a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI40%Vs$price3_Off–price3_win(uc18a)

AORPI40%Vs$4_Off–$4_win(uc18b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI40%Vs$4_Off–$4_win(uc18b)

AORPI60%Vs50%Off–50%_win(uc18c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI60%Vs50%Off–50%_win(uc18c)

AORPI60%Vsprice3–price3_win(uc18d)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI60%Vsprice3–price3_win(uc18d)

AORPI60%Vs$4_Off–$4_win(uc18e)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI60%Vs$4_Off–$4_win(uc18e)

AORPI60%Vs_BOGOFree(1item)–AORPI60%_win(uc19)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI60%Vs_BOGOFree(1item)–AORPI60%_win(uc19)


AORPI50%Vs_BOGOFree(2item)–BOGOFree_win(uc19a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI50%Vs_BOGOFree(2item)–BOGOFree_win(uc19a)

AORPI50%Vs_Buy3andAboveGet50%(2item)–AORPI50%_win(uc19b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI50%Vs_Buy3andAboveGet50%(2item)–AORPI50%_win(uc19b)

AORPI50%Vs_Buy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc19c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI50%Vs_Buy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc19c)

Aorpi50%OffvsBAGB50%(buyA)-Aorpi50%(uc20)        #uc20
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGB50%(buyA)-Aorpi50%
Aorpi50%OffvsBAGB50%(buyB)-Aorpi50%(uc21)         #uc21
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGB50%(buyB)-Aorpi50%
Aorpi50%OffvsBAGB50%(buyA+B)-BAGB50%(uc22)         #uc22
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGB50%(buyA+B)-BAGB50%
Aorpi50%OffvsBAGB$5(buyA)-Aorpi50%(uc20a)            #uc20a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGB$5(buyA)-Aorpi50%
Aorpi50%OffvsBAGB$5(buyB)-Aorpi50%(uc21a)               #uc21a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGB$5(buyB)-Aorpi50%
Aorpi50%OffvsBAGB$5(buyA+B)-BAGB$5(uc22a)              #uc22a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGB$5(buyA+B)-BAGB$5
Aorpi50%OffvsBAGBprice4.99(buyA)-Aorpi50%(uc20b)         #uc20b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGBprice4.99(buyA)-Aorpi50%
Aorpi50%OffvsBAGBprice4.99(buyB)-Aorpi50%(uc21b)             #uc21b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGBprice4.99(buyB)-Aorpi50%
Aorpi50%OffvsBAGBprice4.99(buyA+B)-BAGBprice4.99(uc22b)            #uc22b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Aorpi50%OffvsBAGBprice4.99(buyA+B)-BAGBprice4.99
40%OffvsBAGBfor$4.99(buyB)-40%win(uc23)                #uc23
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGBfor$4.99(buyB)-40%win
40%OffvsBAGBfor$4.99(buyA+B)-BAGBfor$4.99(uc23a)        #uc23a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGBfor$4.99(buyA+B)-BAGBfor$4.99
60%OffvsBAGBfor$4.99(buyB)-60%win          #uc24
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBAGBfor$4.99(buyB)-60%win
60%OffvsBAGBfor$4.99(buyA+B)-60%win       #uc24a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBAGBfor$4.99(buyA+B)-60%win
50%OffvsBAGBfree(stacking)-BAGBfree+50%       #uc25
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBAGBfree(stacking)-BAGBfree+50%  #x

40%OffVsB2G1Free(3item)–40%win(uc28)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffVsB2G1Free(3item)–40%win(uc28)

15%OffVsB2G150%(3item)–B2G150%win(uc28a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    15%OffVsB2G150%(3item)–B2G150%win(uc28a)

40%OffVsB2G1$15(3item)–40%(uc28b):
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffVsB2G1$15(3item)–40%(uc28b)

15%OffVsB2G1for14.99(3item)–B2G1for14.99win(uc28c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    15%OffVsB2G1for14.99(3item)–B2G1for14.99win(uc28c)

17.99VsB2G1Free(3item)–17.99win(uc30)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    17.99VsB2G1Free(3item)–17.99win(uc30)

25.49VsB2G150%(3item)–B2G150%win(uc30a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    25.49VsB2G150%(3item)–B2G150%win(uc30a)

17.99VsB2G1$15(3item)–17.99win(uc31)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    17.99VsB2G1$15(3item)–17.99win(uc31)

25.49VsB2G1for14.99(3item)–B2G1for14.99win(uc31a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    25.49VsB2G1for14.99(3item)–B2G1for14.99win(uc31a)

BOGOFreeVsBOGO40%(2item)–BOGOFreewin(uc34)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    BOGOFreeVsBOGO40%(2item)–BOGOFreewin(uc34)

BOGOFreeVsBOGO$15.99(2item)–BOGOFreewin(uc34a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    BOGOFreeVsBOGO$15.99(2item)–BOGOFreewin(uc34a)

BOGOFreeVsBOGO6$(2item)–BOGOFreewin(uc34b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    BOGOFreeVsBOGO6$(2item)–BOGOFreewin(uc34b)

ERPP40%VSAORPI30%VSEntire50%-Entire50%_a+b+c+d+f(uc62)       #uc62
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP40%VSAORPI30%VSEntire50%-Entire50%_a+b+c+d+f(uc62)
AORPI30%VSERPP40%VSEntire50%-Entire50%_a+b+c+d+f(uc61)       #uc61
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI30%VSERPP40%VSEntire50%-Entire50%_a+b+c+d+f(uc61)
ERPP40%VSAORPI40%VSEntire50%-AORPI40%_c,Entire50%_a+b+d+f       #uc60
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP40%VSAORPI40%VSEntire50%-AORPI40%_c,Entire50%_a+b+d+f
AORPI40%VSERPP40%VSEntire40%-AORPI40%_c,Entire40%_a+b+d+f        #uc59
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    AORPI40%VSERPP40%VSEntire40%-AORPI40%_c,Entire40%_a+b+d+f
ERPP30%vsERPP40%-ERPP40%_c+d+f      #uc58
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP30%vsERPP40%-ERPP40%_c+d+f
ERPP40%vsERPP30%-ERPP40%_c+d+f         #uc57
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP40%vsERPP30%-ERPP40%_c+d+f
AORPI30%vsAORPI40%-AORPI40%_c(uc56)         #uc56
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    AORPI30%vsAORPI40%-AORPI40%_c
AORPI40%vsAORPI30%-AORPI40%_c(uc55)        #uc55
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI40%vsAORPI30%-AORPI40%_c
ERPP30%vsAORPI40%-AORPI40%_c,ERPP30%_d+f(uc54)          #uc54
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP30%vsAORPI40%-AORPI40%_c,ERPP30%_d+f(uc54)

AORPI40%vsERPP30%-AORPI40%_c,ERPP30%_d+f(uc53)         #uc53
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    AORPI40%vsERPP30%-AORPI40%_c,ERPP30%_d+f(uc53)

ERPP40%vsAORPI30%-ERPP40%_c+d+f(uc52)        #uc52
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP40%vsAORPI30%-ERPP40%_c+d+f(uc52)

AORPI30%vsERPP40%-ERPP40%_c+d+f(uc51)         #uc51
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI30%vsERPP40%-ERPP40%_c+d+f(uc51)

AORPI60%vsSpend40/Get10_Spend40/Get10_notApply(uc50)        #uc50
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI60%vsSpend40Get10_Spend40Get10_notApply(uc50)

50%OffvsBOGOFree–stacking         #uc26
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBOGOFree–stacking

50%OffvsBOGOfor$15.99–stacking           #uc26a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBOGOfor$15.99–stacking

50%OffvsBOGO50%–stacking        #uc27
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBOGO50%–stacking
50%OffvsBOGO$10–stacking(uc27a)        #uc27a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBOGO$10–stacking

PCvsPPvsAORPI40%–AORPI40%_e(uc41)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsAORPI40%–AORPI40%_e(uc41)

PCvsPPvsERPP25%–ERPP25%_a+e(uc41a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsERPP25%–ERPP25%_a+e(uc41a)

PCvsPPvsEntire20%–Entire20%_a+b+e+f(uc41b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsEntire20%–Entire20%_a+b+e+f(uc41b)

PCvsPPvsAORPI40%+ERPP25%–ERPP25%_a,AORPI40%_e(uc41c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsAORPI40%+ERPP25%–ERPP25%_a,AORPI40%_e(uc41c)

PCvsPPvsAORPI40%+Entire20%–Entire20%_a+b+f,AORPI40%_e(uc41d)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsAORPI40%+Entire20%–Entire20%_a+b+f,AORPI40%_e(uc41d)

PCvsPPvsAORPI40%+Entire20%+ERPP25%–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc41e)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsAORPI40%+Entire20%+ERPP25%–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc41e)

PCvsPPvsSpend_$25_Get_$5_Spend_$25_Get_$5_a+b+e+f(uc41f)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsPPvsSpend_$25_Get_$5_Spend_$25_Get_$5_a+b+e+f(uc41f)

Tiered_offer_with_3_tiers-buy2item     #uc42
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Tiered_offer_with_3_tiers-buy2item

Tiered_offer_with_3_tiers-buy3item       #uc42a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Tiered_offer_with_3_tiers-buy3item

Tiered_offer_with_3_tiers-buy4item      #uc42b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Tiered_offer_with_3_tiers-buy4item

Buy_More_Save_More-buy4item       #uc43
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Buy_More_Save_More-buy4item

Buy_More_Save_More-buy5item      #uc43a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Buy_More_Save_More-buy5item

Buy_More_Save_More-buy12item(uc43b)     #uc43b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Buy_More_Save_More-buy12item

Tiered_offer_stacked_with_Percent_off-buy3item        #uc44
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Tiered_offer_stacked_with_Percent_off-buy3item
Tiered_offer_stacked_with_Percent_off-buy5item         #uc44a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Tiered_offer_stacked_with_Percent_off-buy5item
Tiered_offer_stacked_with_Percent_off-buy12item(uc44b)           #uc44b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Tiered_offer_stacked_with_Percent_off-buy12item


50%OffvsBAGBFree(buyB)-50%win        #uc10
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBAGBFree(buyB)-50%win
50%OffvsBAGBFree(buyA+B)-BAGBFree         #uc10a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBAGBFree(buyA+B)-BAGBFree  #x
40%OffvsBAGBFree(buyA)-40%win        #uc11
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGBFree(buyA)-40%win
40%OffvsBAGBFree(buyA+B)-BAGBFree         #uc11a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGBFree(buyA+B)-BAGBFree   #x
40%OffvsBAGBFree(buyAorB-A)-40%win         #uc12
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGBFree(buyAorB-A)-40%win
40%OffvsBAGBFree(buyAorB-B)-40%win           #uc12.1
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGBFree(buyAorB-B)-40%win
40%Off(A+B)vsBAGBFree(buyA+B)-40%Off        #uc12a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%Off(A+B)vsBAGBFree(buyA+B)-40%Off  #x
40%Off(A+B)vsBAGBFree(buyA+B)-BAGBFree       #uc12b
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%Off(A+B)vsBAGBFree(buyA+B)-BAGBFree   #x

40%OffvsBAGB50%(buyB)-40%win       #uc13
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGB50%(buyB)-40%win
40%OffvsBAGB50%(buyA+B)-BAGB50%       #uc13a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGB50%(buyA+B)-BAGB50%            # x
60%OffvsBAGB50%(buyB)-60%win         #uc14
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBAGB50%(buyB)-60%win
60%OffvsBAGB50%(buyA+B)-BAGB50%        #uc14a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBAGB50%(buyA+B)-BAGB50%
40%OffvsBAGB$5(buyB)-40%win           #uc15
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGB$5(buyB)-40%win
40%OffvsBAGB$5(buyA+B)-BAGB$5         #uc15a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    40%OffvsBAGB$5(buyA+B)-BAGB$5  #x
60%OffvsBAGB$5(buyB)-60%win           #uc16
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBAGB$5(buyB)-60%win
60%OffvsBAGB$5(buyA+B)-60%Off         #uc16a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    60%OffvsBAGB$5(buyA+B)-60%Off

50%OffvsBAGB50%(stacking)-BAGB50%+50%           #uc29
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsBAGB50%(stacking)-BAGB50%+50%    #x
50%OffvsB2AG1Bfree(stacking)-B2AG1Bfree+50%       #29a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    50%OffvsB2AG1Bfree(stacking)-B2AG1Bfree+50%    #x
price5vsBAGBfor$4.99(buyB)-price5win          #uc32
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    price5vsBAGBfor$4.99(buyB)-price5win
price5vsBAGBfor$4.99(buyA+B)-BAGBfor$4.99win        #uc32a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    price5vsBAGBfor$4.99(buyA+B)-BAGBfor$4.99win   #x
price3vsBAGBfor$4.99(buyB)-price3win            #uc33
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    price3vsBAGBfor$4.99(buyB)-price3win
price3vsBAGBfor$4.99(buyA+B)-price3win          #uc33a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    price3vsBAGBfor$4.99(buyA+B)-price3win

ERPP50%VsBuy3andAboveGet50%(2item)–ERPP50%_win(uc35)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP50%VsBuy3andAboveGet50%(2item)–ERPP50%_win(uc35)

ERPP50%VsBuy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc35a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP50%VsBuy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc35a)

ERPP60%VsBuy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc35b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP60%VsBuy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc35b)

ERPP40%VsBuy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc35c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP40%VsBuy3andAboveGet50%(3item)–Buy3andAboveGet50%_win(uc35c)

CouponvsCoupon(AORPI40%)–AORPI40%_e(uc36)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    CouponvsCoupon(AORPI40%)–AORPI40%_e(uc36)

CouponvsCoupon(ERPP25%)–ERPP25%_a+e(uc36a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    CouponvsCoupon(ERPP25%)–ERPP25%_a+e(uc36a)

CouponvsCoupon(Entire20%)–Entire20%_a+b+e+f(uc36b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    CouponvsCoupon(Entire20%)–Entire20%_a+b+e+f(uc36b)

CouponvsCoupon(AORPI40%+ERPP25%)–ERPP25%_a,AORPI40%_e(uc36c):
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    CouponvsCoupon(AORPI40%+ERPP25%)–ERPP25%_a,AORPI40%_e(uc36c)

CouponvsCoupon(AORPI40%+Entire20%)–Entire20%_a+b+f,AORPI40%_e(uc36d)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    CouponvsCoupon(AORPI40%+Entire20%)–Entire20%_a+b+f,AORPI40%_e(uc36d)

CouponvsCoupon(AORPI40%+Entire20%+ERPP25%)–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc36e)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    CouponvsCoupon(AORPI40%+Entire20%+ERPP25%)–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc36e)

ERpp25%OffvsB2AG1Bfree(buyA)-ERpp25%Off          #uc37
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERpp25%OffvsB2AG1Bfree(buyA)-ERpp25%Off(uc37)
ERpp25%OffvsB2AG1Bfree(buyA+B)-B2AG1Bfree        #uc37a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERpp25%OffvsB2AG1Bfree(buyA+B)-B2AG1Bfree(uc37a)  #x

ERPP40%VsBOGOFree(1item)–ERPP40%_win(uc38)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP40%VsBOGOFree(1item)–ERPP40%_win(uc38)

ERPP40%VsBOGOFree(2item)–BOGOFree_win(uc38a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP40%VsBOGOFree(2item)–BOGOFree_win(uc38a)

ERPP60%VsBOGOFree(1item)–ERPP60%_win(uc38b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP60%VsBOGOFree(1item)–ERPP60%_win(uc38b)

ERPP60%VsBOGOFree(2item)–BOGOFree_win(uc38c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    ERPP60%VsBOGOFree(2item)–BOGOFree_win(uc38c)

AORPI40%VsBOGOFree(2item)–two_offApplied(uc39)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI40%VsBOGOFree(2item)–two_offApplied(uc39)

AORPI30%VsERPP40%–AORPI30%-win(uc39a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    AORPI30%VsERPP40%–AORPI30%-win(uc39a)

ERPP20%,Entire40%vsprice11.99–Price11.99,entire40%_B,entire40%_A(uc39b)
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP20%,Entire40%vsprice11.99–Price11.99,entire40%_B,entire40%_A(uc39b)

ERPP20%,Entire40%vsBoGo50%–BoGo50%,entire40%_B,entire40%_A(uc39c)
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    ERPP20%,Entire40%vsBoGo50%–BoGo50%,entire40%_B,entire40%_A(uc39c)

ERPP30%,Entire40%,AORPI20%vsBoGo50%–BoGo50%,entire40%_B,Entire40%_A,entire40%_c(uc39d)
    [Tags]   mpe     matchapply     pptcase     timieout
    [Template]      Verify Apply case keyword
    ERPP30%,Entire40%,AORPI20%vsBoGo50%–BoGo50%,entire40%_B,Entire40%_A,entire40%_c(uc39d)

Entire40%vsERPP30%vsAORPI20%–Entire40%_A+b+c(uc40)
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    Entire40%vsERPP30%vsAORPI20%–Entire40%_A+b+c(uc40)

Entire40%vsERPP30%vsAORPI30%–Entire40%_A+b+c(uc40a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    Entire40%vsERPP30%vsAORPI30%–Entire40%_A+b+c(uc40a)

Bundle-Pricing(all3items)$100           #uc45
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    Bundle-Pricing(all3items)$100
30%vsBundle-Pricing(all3items)$100-stacking          #uc45a
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    30%vsBundle-Pricing(all3items)$100-stacking  #x

PCvsBOGOvsAORPI40%–AORPI40%_e(uc46)
    [Tags]   mpe     matchapply     pptcase     timeout
    [Template]      Verify Apply case keyword
    PCvsBOGOvsAORPI40%–AORPI40%_e(uc46)  #x

PCvsBOGOvsERPP25%–ERPP25%_a+e(uc46a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGOvsERPP25%–ERPP25%_a+e(uc46a)  #x

PCvsBOGOvsEntire20%–Entire20%_a+b+e+f(uc46b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGOvsEntire20%–Entire20%_a+b+e+f(uc46b)

PCvsBOGOvsAORPI40%+ERPP25%–ERPP25%_a,AORPI40%_e(uc46c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGOvsAORPI40%+ERPP25%–ERPP25%_a,AORPI40%_e(uc46c)

PCvsBOGOvsAORPI40%+Entire20%–Entire20%_a+b+f,AORPI40%_e(uc46d)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGOvsAORPI40%+Entire20%–Entire20%_a+b+f,AORPI40%_e(uc46d)

PCvsBOGOvsAORPI40%+Entire20%+ERPP25%–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc46e)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGOvsAORPI40%+Entire20%+ERPP25%–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc46e)

PCvsBOGOvsSpend_$25_Get_$5_Spend_$25_Get_$5_a+b+e+f(uc46f)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGOvsSpend_$25_Get_$5_Spend_$25_Get_$5_a+b+e+f(uc46f)

bagbfree       #uc47
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    bagbfree    #x
bagb10%      #uc47a
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    bagb10%   #x

PCvsBOGO(2item)vsAORPI40%–AORPI40%_e(uc49):
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsAORPI40%–AORPI40%_e(uc49)

PCvsBOGO(2item)vsERPP25%–ERPP25%_a+e(uc49a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsERPP25%–ERPP25%_a+e(uc49a)

PCvsBOGO(2item)vsEntire20%–Entire20%_a+b+e+f(uc49b)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsEntire20%–Entire20%_a+b+e+f(uc49b)

PCvsBOGO(2item)vsAORPI40%+ERPP25%–ERPP25%_a,AORPI40%_e(uc49c)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsAORPI40%+ERPP25%–ERPP25%_a,AORPI40%_e(uc49c)

PCvsBOGO(2item)vsAORPI40%+Entire20%–Entire20%_a+b+f,AORPI40%_e(uc49d)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsAORPI40%+Entire20%–Entire20%_a+b+f,AORPI40%_e(uc49d)

PCvsBOGO(2item)vsAORPI40%+Entire20%+ERPP25%–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc49e)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsAORPI40%+Entire20%+ERPP25%–Entire20%_b+f,AORPI40%_e,ERPP25%_a(uc49e)

PCvsBOGO(2item)vsSpend_$25_Get_$5_Spend_$25_Get_$5_a+b+e+f(uc49f)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    PCvsBOGO(2item)vsSpend_$25_Get_$5_Spend_$25_Get_$5_a+b+e+f(uc49f)

bagbfreevsbagb10%-bagbfreewin         #uc48
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    bagbfreevsbagb10%-bagbfreewin  #x

BOGOfreevsAORPI60%-AORPI60%win(uc63)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    BOGOfreevsAORPI60%-AORPI60%win(uc63)


BOGOfreevsAORPI60%(2item)-BOGOfreewin(uc63a)
    [Tags]   mpe     matchapply     pptcase
    [Template]      Verify Apply case keyword
    BOGOfreevsAORPI60%(2item)-BOGOfreewin(uc63a)

BOGOfreevsAORPI60%(3item)-BOGOfreewin(uc63b)
    [Tags]   mpe     matchapply     pptcase1
    [Template]      Verify Apply case keyword
    BOGOfreevsAORPI60%(3item)-BOGOfreewin(uc63b)
