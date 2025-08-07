*** Settings ***
Library           SeleniumLibrary
Resource          ./keywords3.robot

Suite Setup       Open web browser
Suite Teardown    Close Web Browser

*** Test Cases ***
"Remember me" checkbox should persist email address
    [Documentation]    Test case 1004 – "Remember me" checkbox should persist email address
    Click Login Link
    Type Valid Credentials
    Click Remember Me Checkbox
    Click Submit Button
    Click Logout Link
    Click Login Link
