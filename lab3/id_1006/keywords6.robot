*** Settings ***
Library    SeleniumLibrary
Variables  ../ressource/variables.py
Variables  ../ressource/locator.py

*** Keywords ***
Open web browser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Click Login Link
    Click Link    Sign In
    Page Should Contain    Customer Service

Type Valid Credentials
    Input Text    id=email-id    ${LOGIN}
    Input Text    id=password    ${PWD}
    Click Button    id=submit-id
    Wait Until Page Contains    Customers

Add New Customer
    Click Link    id=${AddCustomerBtnId}
    Page Should Contain    ${AddCustomerTitle}

Type Customer Email
    Input Text    id=${Email_Input}    ${EmailAddress}

Type Customer First Name
    Input Text    id=${First_Name_Input}    ${FirstName}

Type Customer Last Name
    Input Text    id=${Last_Name_Input}    ${LastName}

Type Customer City
    Input Text    id=${City_Input}    ${City}

Select Customer State
    Select From List By Label    id=${State_Input}    ${State}

Select Gender
    Select Radio Button   ${Gender_Input}    ${Gender}

Optionally Check Promotion Checkbox
    Select Checkbox    name=${Promotion_Checkbox}

Click Submit Button
    Click Button    ${Submit_Button}

Close Web Browser
    Close Browser
