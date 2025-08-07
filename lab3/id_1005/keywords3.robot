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

Navigate to Customers Page
    Page Should Contain Element    locator=customers

Close Web Browser
    Close Browser
