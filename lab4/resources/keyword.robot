*** Settings ***
Library     AppiumLibrary
Variables   ../resources/locator.py



*** Keywords ***
Ouvrir l'application
    [Documentation]    Lance l'application avec Appium
    Open Application    http://127.0.0.1:4723
    ...    automationName=UiAutomator2
    ...    platformName=Android
    ...    deviceName=sdk_gphone64_x86_64
    ...    app=${EXECDIR}/looma.apk
    ...    noReset=true
    ...    strict_ssl=false

Attendre que l'élément soit visible
    [Arguments]    ${locator}    ${timeout}=10s
    Wait Until Page Contains Element    ${locator}    ${timeout}

Vérifier la page de connexion
    [Documentation]    Vérifie que la page de connexion est affichée
    Attendre que l'élément soit visible    ${TITLE}
    Page Should Contain Element    ${USERNAME_FIELD}
    Page Should Contain Element    ${PASSWORD_FIELD}
    Page Should Contain Element    ${LOGIN_BUTTON}
Saisir les identifiants
    [Documentation]    Saisit le nom d'utilisateur et le mot de passe
    [Arguments]    ${username}    ${password}
    Attendre que l'élément soit visible    ${USERNAME_FIELD}
    Click Element    ${USERNAME_FIELD}
    Input Text    ${USERNAME_FIELD}    ${username}
    Click Element    ${PASSWORD_FIELD}
    Input Password    ${PASSWORD_FIELD}    ${password}

Cliquer sur le bouton de connexion
    [Documentation]    Clique sur le bouton de connexion
    Attendre que l'élément soit visible    ${LOGIN_BUTTON}
    Click Element    ${LOGIN_BUTTON}
Vérifier la connexion réussie
    Wait Until Page Contains    Ajouter un produit    10s


  #Creation d'un produit
Saisir le titre du produit
    [Arguments]    ${title}
    Attendre que l'élément soit visible    ${TITLE_FIELD}
    Click Element    ${TITLE_FIELD}
    Input Text    ${TITLE_FIELD}    ${title}
Saisir le prix du produit
    [Arguments]    ${price}
    Attendre que l'élément soit visible    ${PRICE_FIELD}
    Click Element    ${PRICE_FIELD}
    Input Text    ${PRICE_FIELD}    ${price}
Saisir la description du produit
    [Arguments]    ${description}
    Attendre que l'élément soit visible    ${DESCRIPTION_FIELD}
    Click Element    ${DESCRIPTION_FIELD}
    Input Text    ${DESCRIPTION_FIELD}    ${description}
Saisir la catégorie du produit
    [Arguments]    ${category}
    Attendre que l'élément soit visible    ${CATEGORY_FIELD}
    Click Element    ${CATEGORY_FIELD}
    Input Text    ${CATEGORY_FIELD}    ${category}
Saisir l'uRL de l'image du produit
    [Arguments]    ${image_url}
    Attendre que l'élément soit visible    ${IMAGE_FIELD}
    Click Element    ${IMAGE_FIELD}
    Input Text    ${IMAGE_FIELD}    ${image_url}

Cliquer sur le button ajouter
    Attendre que l'élément soit visible    ${ADD_BUTTON}
    Click Element    ${ADD_BUTTON}

Rechercher le produit
    Click Element    ${PRODUCT_SEARCH_FIELD}
    #Click Element    xpath=//android.widget.ImageView[contains(@content-desc, 'Mens Cotton Jacket')]

    Attendre que l'élément soit visible    ${PRODUCT_SEARCH_FIELD}
