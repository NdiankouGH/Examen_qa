*** Settings ***
Library    SeleniumLibrary
Variables  ../ressource/variables.py
Variables  ../ressource/locator.py
*** Keywords ***
Open web browser
    [Documentation]    Ouvrez le navigateur Web et accédez à la page d'accueil
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
Click Login Link
    [Documentation]    Cliquez sur le lien de connexion sur la page d'accueil
    Click Element    id=${Login_Link_id}
    Sleep    5s

    Page Should Contain    Login
Type Valid Credentials
    [Documentation]    Saisissez des identifiants valides dans le formulaire de connexion
    Input Text    id=${login_id}    ${LOGIN}
    Input Text    id=${password_id}    ${PWD}
Click Login Button
    [Documentation]    Clickez sur le bouton de connexion
    Click Element    id=${login_button_id}
    
Click New Customer Button
    [Documentation]    Clickez sur le bouton "Nouveau client"
    Click Link    id=${new_customer_link_id}
    Sleep    5s
    Page Should Contain    Add Customer
Click Cancel Button
    [Documentation]    Clickez sur le button Annuler
    Click Link    Cancel
    Page Should Contain    Our Happy Customers
    Sleep    10s
Close Web Browser
    [Documentation]    Fermez le navigateur Web
    Close Browser