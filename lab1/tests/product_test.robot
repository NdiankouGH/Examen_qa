*** Settings ***
Library           ../resources/MongoDBKeywords.py
Variables         ../resources/variables.py
Resource          ../resources/variable.robot

Suite Setup     Connect To Mongodb Atlas    ${MONGO_URI}    ${DB_NAME}
Suite Teardown   Run Keywords    Cleanup Test Data    AND    Close MongoDB Connection

*** Variables ***


*** Test Cases ***
Test Connexion MongoDB
    [Documentation]    Vérifie que la connexion MongoDB fonctionne
    Log To Console     Connexion OK

# ==================== TESTS CRUD PRODUITS ====================
Create Product With Valid Data
    [Documentation]    Test d'insertion d'un produit avec des données valides
    [Tags]    products    create    passing
    ${product_id}=    Insert Product    
    ...    ${VALID_PRODUCT_TITLE}
    ...    ${VALID_PRODUCT_PRICE}
    ...    ${VALID_PRODUCT_DESC}
    ...    ${VALID_PRODUCT_CATEGORY}
    ...    ${VALID_PRODUCT_QUANTITY}
    ...    ${VALID_PRODUCT_IMAGE}
    Should Not Be Empty    ${product_id}
    Set Suite Variable    ${CREATED_PRODUCT_ID}    ${product_id}
    Log To Console     Produit créé avec succès: ${product_id}
    Log To Console     Produit créé avec succès: ${CREATED_PRODUCT_ID}

Create Product With Invalid Data
    [Documentation]    Test d'insertion d'un produit avec des données invalides
    [Tags]    products    create    failing    *Le prix doit être un nombre valide*     # message d'erreur attendu (ou une partie)
    Run Keyword And Expect Error     *Le prix doit être un nombre valide*    Insert Product Should Fail
    ...    ${INVALID_PRODUCT_TITLE}
    ...    ${INVALID_PRODUCT_PRICE}
    ...    ${INVALID_PRODUCT_DESC}
    ...    ${INVALID_PRODUCT_CATEGORY}
    ...    ${INVALID_PRODUCT_QUANTITY}
    ...    ${INVALID_PRODUCT_IMAGE}
Create Product With Invalid Data
    [Documentation]    Test d'insertion d'un produit avec des données invalides
    [Tags]    products    create    failing    *La quantité doit être un nombre entier*     # message d'erreur attendu (ou une partie)
    Run Keyword And Expect Error     *La quantité doit être un nombre entier*    Insert Product Should Fail
    ...    ${INVALID_PRODUCT_TITLE}
    ...    ${VALID_PRODUCT_PRICE}
    ...    ${INVALID_PRODUCT_DESC}
    ...    ${INVALID_PRODUCT_CATEGORY}
    ...    ${INVALID_PRODUCT_QUANTITY}
    ...    ${INVALID_PRODUCT_IMAGE}

Get Product By Valid ID
    [Documentation]    Test de récupération d'un produit par ID valide
    [Tags]    products    get    passing
    ${product}=    Get Product By ID    ${CREATED_PRODUCT_ID}
    Should Not Be Empty    ${product}
    Should Be Equal As Strings    ${product['title']}    ${VALID_PRODUCT_TITLE}
    Should Be Equal As Numbers    ${product['price']}    ${VALID_PRODUCT_PRICE}
    Should Be Equal As Strings    ${product['description']}    ${VALID_PRODUCT_DESC}
    Should Be Equal As Strings    ${product['category']}    ${VALID_PRODUCT_CATEGORY}
    Should Be Equal As Numbers    ${product['quantity']}    ${VALID_PRODUCT_QUANTITY}
    Should Be Equal As Strings    ${product['image']}    ${VALID_PRODUCT_IMAGE}

Read Product - Invalid ID (Non-Passing)
    [Documentation]    Test de récupération d'un produit avec un ID invalide
    [Tags]    products    read    non-passing
    
    Run Keyword And Expect Error    *
    ...    Get Product By Id    invalid_id_123
    
    Log To Console     Échec attendu pour ID invalide

Read Product - Non-Existent ID (Non-Passing)
    [Documentation]    Test de récupération d'un produit avec un ID inexistant
    [Tags]    products    read    non-passing
    
    Run Keyword And Expect Error    *
    ...    Get Product By Id    507f1f77bcf86cd799439011
    
    Log To Console     Échec attendu pour ID inexistant

Update Product - Valid Data (Passing)
    [Documentation]    Test de mise à jour d'un produit avec des données valides
    [Tags]    products    update    passing
    ${updated}=    Update Product    ${CREATED_PRODUCT_ID}    ${VALID_PRODUCT_TITLE} Updated
    Should Be Equal As Numbers    ${updated}    1
    Log To Console     Produit mis à jour avec succès: ${VALID_PRODUCT_TITLE} Updated

Update Product - Invalid ID (Non-Passing)
    [Documentation]    Test de mise à jour d'un produit avec un ID invalide
    [Tags]    products    update    non-passing
    Run Keyword And Expect Error    *ID de produit invalide*    Update Product    invalid_id_123
    ...    ${VALID_PRODUCT_TITLE} Updated
    Log To Console     Échec attendu pour ID invalide
Delete Product By Valid ID
    [Documentation]    Test de suppression d'un produit par ID valide
    [Tags]    products    delete    passing
    ${deleted_count}=    Delete Product    ${CREATED_PRODUCT_ID}
    Should Be Equal As Numbers    ${deleted_count}    1
    Log To Console     Produit supprimé avec succès: ${CREATED_PRODUCT_ID}    
Delete Product By Invalid ID
    [Documentation]    Test de suppression d'un produit avec un ID invalide
    [Tags]    products    delete    non-passing
    Run Keyword And Expect Error    *ID de produit invalide*    Delete Product    invalid