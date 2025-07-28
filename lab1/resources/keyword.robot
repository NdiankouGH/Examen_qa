*** Settings ***
Library               Collections
Library               MongoDBLibrary
Library          pymongo.MongoClient
Variables           ../resources/variables.py

Suite Setup      Connect To MongoDB
Suite Teardown   Close MongoDB Connection

*** Keywords ***
#Connection a la base de donnee mongodb atlas
Connect To MongoDB Atlas
    [Documentation]    Connect to MongoDB Atlas using the provided connection string.
    Create Session    mysession    ${MONGO_URI}
    ${response}=    Get Request    mysession    /test
    Should Be Equal As Strings    ${response.status_code}    200
    Log To Console    Connected to MongoDB Atlas successfully.


# keyword pour les test sur produit
Insert PRODUCT - Valid Data
    [Documentation]   Test d'insertion d'un produit avec des données valides
    [Arguments]    ${title}    ${price}    ${descriprtion}    ${category}   ${quantity}     ${image}
    ${data}=    Create Dictionary    title=${title}    price=${price}   description=${descriprtion}    quantity=${quantity}   category=${category}    image=${image}
    Should Be Equal As Strings    ${response.status_code}    200
    Log To Console    Product inserted successfully: ${response.json()}