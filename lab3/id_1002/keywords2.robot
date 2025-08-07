*** Settings ***
Library        SeleniumLibrary
Variables    ../ressource/variables.py


*** Comments ***
    Test case 1002
*** Keywords ***
Open web browser
    [Documentation]    Open the web browser and navigate to the home page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Click Login Link
    [Documentation]    Click the login link on the home page
    Click Link    Sign In
    Page Should Contain    Login
Type Valide Credentials
    [Documentation]    Type valid credentials into the login form
    Input Text    id=email-id    ${LOGIN}
    Input Text    id=password    ${PWD}    
    Click Button    id=submit-id
    Wait Until Page Contains    Sign Out

    



Close Web Browser
    Close Browser