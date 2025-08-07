*** Settings ***
Library     SeleniumLibrary
Variables  ../ressource/variables.py
Variables  ../ressource/locator.py

*** Keywords ***
Open web browser
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Click Login Link
    Click Link    Sign In
    Page Should Contain    Customer Service

Type Empty Credentials
    Input Text    id=email-id    ${EMPTY_EMAIL}    True    
    Input Text    id=password    ${EMPTY_PASSWORD}    True
    Click Button    id=submit-id
    Wait Until Page Contains    Login

Close Web Browser
    Close Browser
