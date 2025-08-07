*** Settings ***
Library           SeleniumLibrary
Resource          ./keywords3.robot

Suite Setup       Open web browser
Suite Teardown    Close Web Browser

*** Test Cases ***
Login should fail with missing credentials
    [Documentation]    Test case 1003 – Login should fail with missing credentials
    Click Login Link
    Type Empty Credentials
    Page Should Contain    Login
