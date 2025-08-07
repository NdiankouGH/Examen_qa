*** Settings ***    
Library    SeleniumLibrary

Variables    ../ressource/variables.py

*** Keywords ***
Open web browser
    [Documentation]    Open the web browser and navigate to the home page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    
User examines home page contents
    [Tags]    Test home page load
    [Documentation]    User examines the contents of the home page
     Page Should Contain     ${HomeTitle}

Close Web Browser
    Close Browser
    
