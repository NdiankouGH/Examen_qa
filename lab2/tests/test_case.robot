*** Settings ***
Resource    ../resources/keyword.robot

*** Test Cases ***

# --- createShippingFulfillment ---

Create Shipping Fulfillment - Success
    ${response}=    Create Shipping Fulfillment    ${ORDER_ID_VALID}    ${LINE_ITEM_ID}    1Z12345E1512345676    UPS
    Should Be Equal As Strings    ${response.status_code}    201

Create Shipping Fulfillment - Invalid Order
    ${response}=    Create Shipping Fulfillment    ${ORDER_ID_INVALID}    invalid_line    BADTRACKING123    UPS
    Should Not Be Equal As Strings    ${response.status_code}    201
    Log To Console    Erreur attendue: ${response.status_code}

# --- getShippingFulfillment ---

Get Shipping Fulfillment - Success
    ${response}=    Get Shipping Fulfillment    ${ORDER_ID_VALID}    ${FULFILLMENT_ID_VALID}
    Should Be Equal As Strings    ${response.status_code}    200

Get Shipping Fulfillment - Not Found
    ${response}=    Get Shipping Fulfillment    ${ORDER_ID_VALID}    ${FULFILLMENT_ID_INVALID}
    Should Not Be Equal As Strings    ${response.status_code}    200

# --- getShippingFulfillments ---

Get Shipping Fulfillments - Success
    ${response}=    Get Shipping Fulfillments    ${ORDER_ID_VALID}
    Should Be Equal As Strings    ${response.status_code}    200

Get Shipping Fulfillments - Invalid Order
    ${response}=    Get Shipping Fulfillments    ${ORDER_ID_INVALID}
    Should Not Be Equal As Strings    ${response.status_code}    200
