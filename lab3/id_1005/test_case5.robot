*** Settings ***
Library           SeleniumLibrary
Resource          ./keywords3.robot

Suite Setup       Open web browser
Suite Teardown    Close Web Browser

*** Test Cases ***
Navigate to Customers Page
    [Documentation]    Test case 1005 – Navigate to the Customers page after login
    Click Login Link
    Type Valid Credentials
    Navigate to Customers Page
