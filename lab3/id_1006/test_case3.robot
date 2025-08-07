*** Settings ***
Library           SeleniumLibrary
Resource          ./keywords3.robot

Suite Setup       Open web browser
Suite Teardown    Close Web Browser

*** Test Cases ***
Add New Customer
    [Documentation]    Test case 1006 – Add a new customer from login to submission
    Click Login Link
    Type Valid Credentials
    Add New Customer
    Type Customer Email
    Type Customer First Name
    Type Customer Last Name
    Type Customer City
    Select Customer State
    Select Gender
    Click Submit Button
    Page Should Contain    Success!
    Close Web Browser