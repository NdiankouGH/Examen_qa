*** Settings ***
Library    ../resources/MongoDBKeywords.py
Resource   ../resources/variable.robot
Variables  ../resources/variables.py

Suite Setup       Connect To MongoDB Atlas    ${MONGO_URI}    ${DB_NAME}
Suite Teardown    Close MongoDB Connection
*** Variables ***
${INVALID_EMAIL}              invalid_email_format    

*** Test Cases ***

Insert User Test - Scénario Passant
    [Documentation]    Test d'insertion d'un utilisateur avec des données valides
    [Tags]    users    insert    valid
    ${user_id}=    Insert User
    ...    ${VALID_USER_FIRSTNAME}
    ...    ${VALID_USER_LASTNAME}
    ...    ${VALID_USER_EMAIL}
    ...    ${VALID_USER_USERNAME}
    ...    ${VALID_USER_PASSWORD}
    ...    ${VALID_USER_PHONE}
    Should Not Be Empty    ${user_id}
    Set Suite Variable    ${TEST_USER_ID}    ${user_id}
    Log To Console    Utilisateur inséré avec succès: ${user_id}

Get User By ID Test - Scénario Passant
    [Documentation]    Test de récupération d'un utilisateur par ID
    [Tags]    users    get    valid
    ${user}=    Get User By ID    ${TEST_USER_ID}
    Should Not Be Empty    ${user}
    Should Be Equal As Strings    ${user['username']}    ${VALID_USER_USERNAME}

Update User Test - Scénario Passant
    [Documentation]    Test de mise à jour d'un utilisateur
    [Tags]    users    update    valid
    ${updated_username}=    Set Variable    ${VALID_USER_USERNAME}_updated
    ${result}=    Update User    ${TEST_USER_ID}    username=${updated_username}
    Should Be Equal As Integers    ${result}    1
    ${user}=    Get User By ID    ${TEST_USER_ID}
    Should Be Equal As Strings    ${user['username']}    ${updated_username}

Update User With Invalid ID - Scénario Non Passant
    [Documentation]    Test de mise à jour d'un utilisateur avec un ID invalide
    [Tags]    users    update    invalid
    Run Keyword And Expect Error    *Échec mise à jour utilisateur: ID d'utilisateur invalide : 123*    Update User 
    ...    123
    ...    username=nouveau_nom_utilisateur

Update User With Nonexistent ID Test - Scénario Non Passant
    [Documentation]    Test de mise à jour d'un utilisateur avec un ID inexistant
    [Tags]    users    update    invalid
    Run Keyword And Expect Error    *Échec mise à jour utilisateur: ID d'utilisateur invalide : nonexistent_id*    Update User 
    ...    nonexistent_id
    ...    username=nouveau_nom_utilisateur
Delete User Test - Scénario Passant
    [Documentation]    Test de suppression d'un utilisateur
    [Tags]    users    delete    valid
    ${user_id}=    Insert User    Delete    Test    delete.test@example.com    deletetest    password123    +221771234567
    ${result}=    Delete User    ${user_id}
    Should Be Equal As Integers    ${result}    1
    Run Keyword And Expect Error    *non trouvé*    Get User By ID    ${user_id}

Insert User With Invalid Data Test - Scénario Non Passant
    [Documentation]    Test d'insertion d'un utilisateur avec des données invalides (ex : email dupliqué)
    [Tags]    users    insert    invalid
    Run Keyword And Expect Error    *L'email est requis et doit être une chaîne de caractères*    Insert User Should Fail
    ...    ${INVALID_USER_DATA_DUPLICATE_EMAIL['firstname']}
    ...    ${INVALID_USER_DATA_DUPLICATE_EMAIL['lastname']}
    ...    ${INVALID_USER_DATA_DUPLICATE_EMAIL['email']}
    ...    ${INVALID_USER_DATA_DUPLICATE_EMAIL['username']}
    ...    ${INVALID_USER_DATA_DUPLICATE_EMAIL['password']}
    ...    ${INVALID_USER_DATA_DUPLICATE_EMAIL['phone']}

Insert User With Empty Email Test - Scénario Non Passant
    [Documentation]    Vérifie qu'un utilisateur sans email est rejeté
    [Tags]    users    insert    invalid

    Run Keyword And Expect Error    *email est requis*    Insert User Should Fail
    ...    Test
    ...    User
    ...         
    ...    testuser
    ...    password123
    ...    +221771234567

Get User By Invalid ID Test - Scénario Non Passant
    [Documentation]    Test de récupération d'un utilisateur avec un ID invalide
    [Tags]    users    get    invalid
    ${result}=    Get User By Invalid ID    invalidid123
    #Should Be Equal    ${result}    Échec attendu
        Log To Console        ${result}    


Get User By Nonexistent ID Test - Scénario Non Passant
    [Documentation]    Test de récupération d'un utilisateur inexistant
    [Tags]    users    get    invalid
    ${result}=    Get User By Invalid ID    507f1f77bcf86cd799439011
    #Should Be Equal    ${result}     Test de ...  Aucun utilisateur trouvé comme attendu
    Log To Console        ${result}


Authenticate User Test - Scenario Passant
    [Documentation]    Test de l'authentification d'un utilisateur avec des données valides
    [Tags]    users    authenticate    valid
    ${token}=    Authenticate User    ${VALID_USER_USERNAME}    ${VALID_USER_PASSWORD}
    Should Not Be Empty    ${token}
    Log To Console    Authentification réussie pour l'utilisateur: ${VALID_USER_USERNAME}

Authenticate User With Invalid Credentials Test - Scénario Non Passant
    [Documentation]    Test de l'authentification d'un utilisateur avec des identifiants invalides
    [Tags]    users    authenticate    invalid
    Run Keyword And Expect Error    *Échec de l'authentification*    Authenticate User  ${INVALID_USER_USERNAME}    ${INVALID_PASSWORD}
    Log To Console    Échec d'authentification attendu pour l'utilisateur

Authenticate User With Nonexistent User Test - Scénario Non Passant
    [Documentation]    Test de l'authentification d'un utilisateur inexistant
    [Tags]    users    authenticate    invalid
    Run Keyword And Expect Error    *Échec de l'authentification*    Authenticate User  nonexistent_user    ${VALID_USER_PASSWORD}
    Log To Console    Échec d'authentification attendu pour un utilisateur inexistant