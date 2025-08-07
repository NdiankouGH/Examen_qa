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

Click Remember Me Checkbox
    Click Element    id=remember

Click Submit Button
    Click Button    id=submit-id
    Wait Until Page Contains    Customers

Click Logout Link
    Click Link    Sign Out
    Wait Until Page Contains    Signed Out

Check Email Prepopulated
    Page Should Contain Element    id=email-id
    Element Attribute Value Should Be    id=email-id    value    ${LOGIN}

Close Web Browser
    Close Browser
