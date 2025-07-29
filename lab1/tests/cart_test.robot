***Settings***
Library           ../resources/MongoDBKeywords.py
Variables         ../resources/variables.py
Resource          ../resources/variable.robot

Suite Setup     Connect To MongoDB Atlas    ${MONGO_URI}    ${DB_NAME}
Suite Teardown   Run Keywords    Cleanup Test Data    AND    Close MongoDB Connection

***Variables***
# Variables pour les tests de panier
${VALID_CART_PRODUCT_QUANTITY}    5
${INVALID_CART_PRODUCT_QUANTITY}   -1
@{VALID_PRODUCTS_LIST}    {"product_id": "", "quantity": ${VALID_CART_PRODUCT_QUANTITY}}
@{INVALID_PRODUCTS_LIST}   {"product_id": "", "quantity": ${INVALID_CART_PRODUCT_QUANTITY}}
${INVALID_CART_ID}        invalid_cart_id
${NON_EXISTENT_CART_ID}   507f1f77bcf86cd799439011

***Test Cases***
Test Connexion MongoDB
    [Documentation]    Vérifie que la connexion MongoDB fonctionne
    Log To Console     Connexion OK

# ==================== TESTS CRUD PANIER ====================

# ==================== CREATE TESTS ====================
Create Cart With Valid Data
    [Documentation]    Test de création d'un panier avec des données valides
    [Tags]    carts    create    passing
    
    # D'abord créer un utilisateur pour le test
    ${user_id}=    Insert User
    ...    ${VALID_USER_FIRSTNAME}
    ...    ${VALID_USER_LASTNAME}
    ...    ${VALID_USER_EMAIL}
    ...    ${VALID_USER_USERNAME}
    ...    ${VALID_USER_PASSWORD}
    ...    ${VALID_USER_PHONE}
    Should Not Be Empty    ${user_id}
    Set Suite Variable    ${TEST_USER_ID}    ${user_id}
    
    # Ensuite créer un produit pour le test
    ${product_id}=    Insert Product    
    ...    ${VALID_PRODUCT_TITLE}
    ...    ${VALID_PRODUCT_PRICE}
    ...    ${VALID_PRODUCT_DESC}
    ...    ${VALID_PRODUCT_CATEGORY}
    ...    ${VALID_PRODUCT_QUANTITY}
    ...    ${VALID_PRODUCT_IMAGE}
    Should Not Be Empty    ${product_id}
    Set Suite Variable    ${TEST_PRODUCT_ID}    ${product_id}
    
    # Préparer les données du panier
    ${products_list}=    Evaluate    [{"product_id": "${TEST_PRODUCT_ID}", "quantity": ${VALID_CART_PRODUCT_QUANTITY}}]
    
    # Créer le panier
    ${cart_id}=    Create Cart    ${TEST_USER_ID}    ${products_list}
    Should Not Be Empty    ${cart_id}
    Set Suite Variable    ${TEST_CART_ID}    ${cart_id}
    Log To Console    Panier créé avec succès: ${cart_id}

Create Cart With Invalid Data - Negative Quantity
    [Documentation]    Test de création d'un panier avec une quantité négative
    [Tags]    carts    create    failing
    
    # Préparer les données du panier avec quantité négative
    ${invalid_products_list}=    Evaluate    [{"product_id": "${TEST_PRODUCT_ID}", "quantity": ${INVALID_CART_PRODUCT_QUANTITY}}]
    
    # La création devrait échouer
    Run Keyword And Expect Error    *La quantité doit être supérieure à 0*    Create Cart Should Fail
    ...    ${TEST_USER_ID}
    ...    ${invalid_products_list}

Create Cart With Invalid Data - Invalid Product ID
    [Documentation]    Test de création d'un panier avec un ID de produit invalide
    [Tags]    carts    create    failing
    
    # Préparer les données du panier avec ID de produit invalide
    ${invalid_products_list}=    Evaluate    [{"product_id": "invalid_product_id", "quantity": ${VALID_CART_PRODUCT_QUANTITY}}]
    
    # La création devrait échouer
    Run Keyword And Expect Error    *ID de produit invalide*    Create Cart Should Fail
    ...    ${TEST_USER_ID}
    ...    ${invalid_products_list}

# ==================== READ TESTS ====================
Get Cart By Valid ID
    [Documentation]    Test de récupération d'un panier par ID valide
    [Tags]    carts    read    passing
    
    ${cart}=    Get Cart By ID    ${TEST_CART_ID}
    Should Not Be Empty    ${cart}
    Log To Console    Panier récupéré avec succès pour l'utilisateur: ${cart['user_id']}

Get Cart By Invalid ID
    [Documentation]    Test de récupération d'un panier avec un ID invalide
    [Tags]    carts    read    failing
    
    ${result}=    Get Cart By Invalid ID    ${INVALID_CART_ID}
    Should Be Equal As Strings   ${result}    NOT_FOUND
    Log To Console    Échec attendu pour ID invalide    ${result}

Get Cart By Non-existent ID
    [Documentation]    Test de récupération d'un panier avec un ID inexistant
    [Tags]    carts    read    failing
    
    Run Keyword And Expect Error    *Panier non trouvé*    Get Cart By ID    ${NON_EXISTENT_CART_ID}
    Log To Console    Échec attendu pour ID inexistant

# ==================== UPDATE TESTS ====================
Update Cart With Valid Data
    [Documentation]    Test de mise à jour d'un panier avec des données valides
    [Tags]    carts    update    passing
    
    # Mettre à jour la quantité dans le panier
    ${updated_products_list}=    Evaluate    [{"product_id": "${TEST_PRODUCT_ID}", "quantity": 10}]
    ${updated}=    Update Cart    ${TEST_CART_ID}    ${updated_products_list}
    Should Be Equal As Numbers    ${updated}    1
    
    # Vérifier la mise à jour
    ${cart}=    Get Cart By ID    ${TEST_CART_ID}
    ${product}=    Set Variable    ${cart['products'][0]}
    Should Be Equal As Numbers    ${product['quantity']}    10
    Log To Console    Panier mis à jour avec succès

Update Cart With Invalid Data - Negative Quantity
    [Documentation]    Test de mise à jour d'un panier avec une quantité négative
    [Tags]    carts    update    failing
    
    # Préparer les données du panier avec quantité négative
    ${invalid_products_list}=    Evaluate    [{"product_id": "${TEST_PRODUCT_ID}", "quantity": ${INVALID_CART_PRODUCT_QUANTITY}}]
    
    # La mise à jour devrait échouer
    Run Keyword And Expect Error    *La quantité doit être supérieure à 0*    Update Cart Should Fail
    ...    ${TEST_CART_ID}
    ...    ${invalid_products_list}

Update Cart With Invalid ID
    [Documentation]    Test de mise à jour d'un panier avec un ID invalide
    [Tags]    carts    update    failing
    
    Run Keyword And Expect Error    *ID de panier invalide*    Update Cart
    ...    ${INVALID_CART_ID}
    ...    ${VALID_PRODUCTS_LIST}
    Log To Console    Échec attendu pour ID invalide

# ==================== DELETE TESTS ====================
Delete Cart By Valid ID
    [Documentation]    Test de suppression d'un panier par ID valide
    [Tags]    carts    delete    passing
    
    # Créer un nouveau panier pour le supprimer
    ${products_list}=    Evaluate    [{"product_id": "${TEST_PRODUCT_ID}", "quantity": ${VALID_CART_PRODUCT_QUANTITY}}]
    ${cart_id_to_delete}=    Create Cart    ${TEST_USER_ID}    ${products_list}
    Should Not Be Empty    ${cart_id_to_delete}
    
    # Supprimer le panier
    ${deleted_count}=    Delete Cart    ${cart_id_to_delete}
    Should Be Equal As Numbers    ${deleted_count}    1
    Log To Console    Panier supprimé avec succès: ${cart_id_to_delete}
    
    # Vérifier que le panier a été supprimé
    Run Keyword And Expect Error    *Panier non trouvé*    Get Cart By ID    ${cart_id_to_delete}

Delete Cart By Invalid ID
    [Documentation]    Test de suppression d'un panier avec un ID invalide
    [Tags]    carts    delete    failing
    
    Run Keyword And Expect Error    *ID de panier invalide*    Delete Cart    ${INVALID_CART_ID}
    Log To Console    Échec attendu pour ID invalide

Delete Cart With Active Status - Should Fail
    [Documentation]    Test de suppression d'un panier actif - devrait échouer
    [Tags]    carts    delete    failing
    
    # Mettre le panier en statut actif
    ${result}=    Update Cart    ${TEST_CART_ID}    status=active
    
    # La suppression devrait échouer car le panier est actif
    Run Keyword And Expect Error    *Impossible de supprimer un panier actif*    Delete Cart Should Fail
    ...    ${TEST_CART_ID}

# ==================== CLEANUP TESTS ====================
Cleanup Test Data
    [Documentation]    Nettoyer les données de test
    [Tags]    cleanup
    
    # Supprimer les données créées pendant les tests
    Run Keyword And Ignore Error    Delete Cart    ${TEST_CART_ID}
    Run Keyword And Ignore Error    Delete Product    ${TEST_PRODUCT_ID}
    Run Keyword And Ignore Error    Delete User    ${TEST_USER_ID}