*** Settings ***
Documentation    Tests CRUD pour MongoDB Atlas avec objets Fake Store
Library          Collections
Library          DateTime
Library          String
Library          pymongo.MongoClient    WITH NAME    MongoClient
Library          bson.objectid.ObjectId    WITH NAME    ObjectId
Suite Setup      Connect To MongoDB
Suite Teardown   Close MongoDB Connection
Test Setup       Setup Test Data
Test Teardown    Cleanup Test Data

*** Variables ***
${MONGODB_URI}        mongodb+srv://username:password@cluster.mongodb.net/
${DB_NAME}           fakestore_db
${PRODUCTS_COLLECTION}    products
${USERS_COLLECTION}       users
${CARTS_COLLECTION}       carts

# Documents de test
&{VALID_PRODUCT}     title=Test Product    price=${29.99}    description=Test description    category=electronics    image=https://test.com/image.jpg    rating=&{rate=${4.5}    count=${100}}
&{VALID_USER}        email=test@test.com    username=testuser    password=testpass123    name=&{firstname=Test    lastname=User}    address=&{city=TestCity    street=Test Street    number=${123}    zipcode=12345    geolocation=&{lat=0    long=0}}    phone=123-456-7890
&{VALID_CART}        userId=${EMPTY}    date=${EMPTY}    products=@{EMPTY}

*** Test Cases ***

# ===== TESTS CRUD - PRODUCTS =====

# CREATE TESTS
Insert Product - Valid Data (Passing)
    [Documentation]    Test d'insertion d'un produit avec des données valides
    [Tags]    products    create    passing
    ${result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    Should Be True    ${result.acknowledged}
    Should Not Be Empty    ${result.inserted_id}
    Set Test Variable    ${CREATED_PRODUCT_ID}    ${result.inserted_id}

Insert Product - Missing Title (Non-passing)
    [Documentation]    Test d'insertion d'un produit sans titre
    [Tags]    products    create    non-passing
    ${invalid_product}=    Copy Dictionary    ${VALID_PRODUCT}
    Remove From Dictionary    ${invalid_product}    title
    ${result}=    Run Keyword And Return Status    Insert One Document    ${PRODUCTS_COLLECTION}    ${invalid_product}
    Should Be Equal    ${result}    ${False}

Insert Product - Negative Price (Non-passing)
    [Documentation]    Test d'insertion d'un produit avec prix négatif
    [Tags]    products    create    non-passing
    ${invalid_product}=    Copy Dictionary    ${VALID_PRODUCT}
    Set To Dictionary    ${invalid_product}    price=${-10.99}
    ${result}=    Run Keyword And Return Status    Insert One Document    ${PRODUCTS_COLLECTION}    ${invalid_product}
    Should Be Equal    ${result}    ${False}

# READ TESTS
Find Product - Existing ID (Passing)
    [Documentation]    Test de recherche d'un produit existant
    [Tags]    products    read    passing
    ${insert_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    ${document}=    Find One Document    ${PRODUCTS_COLLECTION}    _id    ${insert_result.inserted_id}
    Should Not Be Empty    ${document}
    Should Be Equal    ${document['title']}    ${VALID_PRODUCT['title']}
    Should Be Equal As Numbers    ${document['price']}    ${VALID_PRODUCT['price']}

Find Product - Non-existing ID (Non-passing)
    [Documentation]    Test de recherche d'un produit inexistant
    [Tags]    products    read    non-passing
    ${fake_id}=    Create ObjectId
    ${document}=    Find One Document    ${PRODUCTS_COLLECTION}    _id    ${fake_id}
    Should Be Empty    ${document}

Find Product - Invalid ID Format (Non-passing)
    [Documentation]    Test de recherche avec ID invalide
    [Tags]    products    read    non-passing
    ${result}=    Run Keyword And Return Status    Find One Document    ${PRODUCTS_COLLECTION}    _id    invalid_id
    Should Be Equal    ${result}    ${False}

# UPDATE TESTS
Update Product - Existing ID (Passing)
    [Documentation]    Test de mise à jour d'un produit existant
    [Tags]    products    update    passing
    ${insert_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    ${update_data}=    Create Dictionary    title=Updated Product    price=${39.99}
    ${result}=    Update One Document    ${PRODUCTS_COLLECTION}    _id    ${insert_result.inserted_id}    ${update_data}
    Should Be Equal As Numbers    ${result.matched_count}    1
    Should Be Equal As Numbers    ${result.modified_count}    1

Update Product - Non-existing ID (Non-passing)
    [Documentation]    Test de mise à jour d'un produit inexistant
    [Tags]    products    update    non-passing
    ${fake_id}=    Create ObjectId
    ${update_data}=    Create Dictionary    title=Updated Product
    ${result}=    Update One Document    ${PRODUCTS_COLLECTION}    _id    ${fake_id}    ${update_data}
    Should Be Equal As Numbers    ${result.matched_count}    0
    Should Be Equal As Numbers    ${result.modified_count}    0

Update Product - Invalid Price Format (Non-passing)
    [Documentation]    Test de mise à jour avec prix invalide
    [Tags]    products    update    non-passing
    ${insert_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    ${update_data}=    Create Dictionary    price=invalid_price
    ${result}=    Run Keyword And Return Status    Update One Document    ${PRODUCTS_COLLECTION}    _id    ${insert_result.inserted_id}    ${update_data}
    Should Be Equal    ${result}    ${False}

# DELETE TESTS
Delete Product - Existing ID (Passing)
    [Documentation]    Test de suppression d'un produit existant
    [Tags]    products    delete    passing
    ${insert_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    ${result}=    Delete One Document    ${PRODUCTS_COLLECTION}    _id    ${insert_result.inserted_id}
    Should Be Equal As Numbers    ${result.deleted_count}    1

Delete Product - Non-existing ID (Non-passing)
    [Documentation]    Test de suppression d'un produit inexistant
    [Tags]    products    delete    non-passing
    ${fake_id}=    Create ObjectId
    ${result}=    Delete One Document    ${PRODUCTS_COLLECTION}    _id    ${fake_id}
    Should Be Equal As Numbers    ${result.deleted_count}    0

Delete Product - Invalid ID Format (Non-passing)
    [Documentation]    Test de suppression avec ID invalide
    [Tags]    products    delete    non-passing
    ${result}=    Run Keyword And Return Status    Delete One Document    ${PRODUCTS_COLLECTION}    _id    invalid_id
    Should Be Equal    ${result}    ${False}

# ===== TESTS CRUD - USERS =====

# CREATE TESTS
Insert User - Valid Data (Passing)
    [Documentation]    Test d'insertion d'un utilisateur avec des données valides
    [Tags]    users    create    passing
    ${result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    Should Be True    ${result.acknowledged}
    Should Not Be Empty    ${result.inserted_id}

Insert User - Duplicate Email (Non-passing)
    [Documentation]    Test d'insertion d'un utilisateur avec email dupliqué
    [Tags]    users    create    non-passing
    ${result1}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    Should Be True    ${result1.acknowledged}
    ${result2}=    Run Keyword And Return Status    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    Should Be Equal    ${result2}    ${False}

Insert User - Invalid Email Format (Non-passing)
    [Documentation]    Test d'insertion d'un utilisateur avec email invalide
    [Tags]    users    create    non-passing
    ${invalid_user}=    Copy Dictionary    ${VALID_USER}
    Set To Dictionary    ${invalid_user}    email=invalid-email-format
    ${result}=    Run Keyword And Return Status    Insert One Document    ${USERS_COLLECTION}    ${invalid_user}
    Should Be Equal    ${result}    ${False}

# READ TESTS
Find User - Existing ID (Passing)
    [Documentation]    Test de recherche d'un utilisateur existant
    [Tags]    users    read    passing
    ${insert_result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    ${document}=    Find One Document    ${USERS_COLLECTION}    _id    ${insert_result.inserted_id}
    Should Not Be Empty    ${document}
    Should Be Equal    ${document['email']}    ${VALID_USER['email']}
    Should Be Equal    ${document['username']}    ${VALID_USER['username']}

Find User - Non-existing ID (Non-passing)
    [Documentation]    Test de recherche d'un utilisateur inexistant
    [Tags]    users    read    non-passing
    ${fake_id}=    Create ObjectId
    ${document}=    Find One Document    ${USERS_COLLECTION}    _id    ${fake_id}
    Should Be Empty    ${document}

Find User - Non-existing Email (Non-passing)
    [Documentation]    Test de recherche avec email inexistant
    [Tags]    users    read    non-passing
    ${document}=    Find One Document    ${USERS_COLLECTION}    email    nonexistent@test.com
    Should Be Empty    ${document}

# UPDATE TESTS
Update User - Existing ID (Passing)
    [Documentation]    Test de mise à jour d'un utilisateur existant
    [Tags]    users    update    passing
    ${insert_result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    ${update_data}=    Create Dictionary    email=updated@test.com    username=updateduser
    ${result}=    Update One Document    ${USERS_COLLECTION}    _id    ${insert_result.inserted_id}    ${update_data}
    Should Be Equal As Numbers    ${result.matched_count}    1
    Should Be Equal As Numbers    ${result.modified_count}    1

Update User - Duplicate Email (Non-passing)
    [Documentation]    Test de mise à jour avec email dupliqué
    [Tags]    users    update    non-passing
    ${user1}=    Copy Dictionary    ${VALID_USER}
    ${user2}=    Copy Dictionary    ${VALID_USER}
    Set To Dictionary    ${user2}    email=user2@test.com    username=user2
    ${result1}=    Insert One Document    ${USERS_COLLECTION}    ${user1}
    ${result2}=    Insert One Document    ${USERS_COLLECTION}    ${user2}
    ${update_data}=    Create Dictionary    email=${user1['email']}
    ${result}=    Run Keyword And Return Status    Update One Document    ${USERS_COLLECTION}    _id    ${result2.inserted_id}    ${update_data}
    Should Be Equal    ${result}    ${False}

Update User - Non-existing ID (Non-passing)
    [Documentation]    Test de mise à jour d'un utilisateur inexistant
    [Tags]    users    update    non-passing
    ${fake_id}=    Create ObjectId
    ${update_data}=    Create Dictionary    email=updated@test.com
    ${result}=    Update One Document    ${USERS_COLLECTION}    _id    ${fake_id}    ${update_data}
    Should Be Equal As Numbers    ${result.matched_count}    0

# DELETE TESTS
Delete User - Existing ID (Passing)
    [Documentation]    Test de suppression d'un utilisateur existant
    [Tags]    users    delete    passing
    ${insert_result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    ${result}=    Delete One Document    ${USERS_COLLECTION}    _id    ${insert_result.inserted_id}
    Should Be Equal As Numbers    ${result.deleted_count}    1

Delete User - Non-existing ID (Non-passing)
    [Documentation]    Test de suppression d'un utilisateur inexistant
    [Tags]    users    delete    non-passing
    ${fake_id}=    Create ObjectId
    ${result}=    Delete One Document    ${USERS_COLLECTION}    _id    ${fake_id}
    Should Be Equal As Numbers    ${result.deleted_count}    0

Delete User - Invalid ID Format (Non-passing)
    [Documentation]    Test de suppression avec ID invalide
    [Tags]    users    delete    non-passing
    ${result}=    Run Keyword And Return Status    Delete One Document    ${USERS_COLLECTION}    _id    invalid_id
    Should Be Equal    ${result}    ${False}

# ===== TESTS CRUD - CARTS =====

# CREATE TESTS
Insert Cart - Valid Data (Passing)
    [Documentation]    Test d'insertion d'un panier avec des données valides
    [Tags]    carts    create    passing
    # Créer utilisateur et produit de référence
    ${user_result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    ${product_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    # Créer panier
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${cart_products}=    Create List    &{productId=${product_result.inserted_id}    quantity=${2}}
    ${cart_data}=    Create Dictionary    userId=${user_result.inserted_id}    date=${current_date}    products=${cart_products}
    ${result}=    Insert One Document    ${CARTS_COLLECTION}    ${cart_data}
    Should Be True    ${result.acknowledged}
    Should Not Be Empty    ${result.inserted_id}

Insert Cart - Non-existing User ID (Non-passing)
    [Documentation]    Test d'insertion d'un panier avec utilisateur inexistant
    [Tags]    carts    create    non-passing
    ${fake_user_id}=    Create ObjectId
    ${product_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${cart_products}=    Create List    &{productId=${product_result.inserted_id}    quantity=${2}}
    ${cart_data}=    Create Dictionary    userId=${fake_user_id}    date=${current_date}    products=${cart_products}
    ${result}=    Run Keyword And Return Status    Insert One Document    ${CARTS_COLLECTION}    ${cart_data}
    Should Be Equal    ${result}    ${False}

Insert Cart - Non-existing Product ID (Non-passing)
    [Documentation]    Test d'insertion d'un panier avec produit inexistant
    [Tags]    carts    create    non-passing
    ${user_result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    ${fake_product_id}=    Create ObjectId
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${cart_products}=    Create List    &{productId=${fake_product_id}    quantity=${2}}
    ${cart_data}=    Create Dictionary    userId=${user_result.inserted_id}    date=${current_date}    products=${cart_products}
    ${result}=    Run Keyword And Return Status    Insert One Document    ${CARTS_COLLECTION}    ${cart_data}
    Should Be Equal    ${result}    ${False}

# READ TESTS
Find Cart - Existing ID (Passing)
    [Documentation]    Test de recherche d'un panier existant
    [Tags]    carts    read    passing
    ${user_result}=    Insert One Document    ${USERS_COLLECTION}    ${VALID_USER}
    ${product_result}=    Insert One Document    ${PRODUCTS_COLLECTION}    ${VALID_PRODUCT}
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${cart_products}=    Create List    &{productId=${product_result.inserted_id}    quantity=${2}}
    ${cart_data}=    Create Dictionary    userId=${user_result.inserted_id}    date=${current_date}    products=${cart_products}
    ${insert_result}=    Insert One Document    ${CARTS_COLLECTION}    ${cart_data}
    ${document}=    Find One Document    ${CARTS_COLLECTION}    _id    ${insert_result.inserted_id}
    Should Not Be Empty    ${document}
    Should Be Equal    ${document['userId']}    ${user_result.inserted_id}

Find Cart - Non-existing ID (