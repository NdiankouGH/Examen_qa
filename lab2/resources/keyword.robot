*** Settings ***
Library     RequestsLibrary
Library     JSONLibrary
Variables   ../resources/variables.py

*** Keywords ***

Create Shipping Fulfillment
    [Arguments]    ${order_id}    ${line_item_id}    ${tracking}    ${carrier}
    Create Session    ebay    ${BASE_URL}    headers=Authorization=${TOKEN},Content-Type=application/json
    ${payload}=    Set Variable
    ...    {
    ...      "lineItems": [{"lineItemId": "${line_item_id}"}],
    ...      "shippedDate": "2025-08-06T12:00:00Z",
    ...      "shippingCarrierCode": "${carrier}",
    ...      "trackingNumber": "${tracking}"
    ...    }
    ${response}=    Post Request    ebay    /order/${order_id}/shipping_fulfillment    data=${payload}
    [Return]    ${response}

Get Shipping Fulfillment
    [Arguments]    ${order_id}    ${fulfillment_id}
    Create Session    ebay    ${BASE_URL}    headers=Authorization=${TOKEN}
    ${response}=    Get Request    ebay    /order/${order_id}/shipping_fulfillment/${fulfillment_id}
    [Return]    ${response}

Get Shipping Fulfillments
    [Arguments]    ${order_id}
    Create Session    ebay    ${BASE_URL}    headers=Authorization=${TOKEN}
    ${response}=    Get Request    ebay    /order/${order_id}/shipping_fulfillment
    [Return]    ${response}
