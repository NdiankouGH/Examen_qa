*** Settings ***
Library    SeleniumLibrary
Resource    ./keywords1.robot

Suite Setup    Open web browser
Suite Teardown    Close Browser

*** Test Cases ***
Home Page Should Load
    User examines home page contents
    Sleep    5s
    

