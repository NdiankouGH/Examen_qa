*** Settings ***
Library    SeleniumLibrary
Resource    ./keywords2.robot

Suite Setup    Open web browser
Suite Teardown    Close web Browser

*** Test Cases ***
Click Login Link
      Click Login Link
      Sleep    2s
    Type Valide Credentials
    Page Should Contain    Sign Out
    Sleep    4s