*** Settings ***
Library    SeleniumLibrary
Resource    ./keyword.robot

Suite Setup    Open web browser
Suite Teardown    Close Web Browser

*** Test Cases ***
Should be able to cancel adding new customer
    Click Login Link
    Type Valid Credentials
    Click Login Button
    Click New Customer Button
    Click Cancel Button

