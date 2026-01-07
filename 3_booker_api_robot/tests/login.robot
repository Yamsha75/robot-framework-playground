*** Settings ***
Library     Collections
Library     RequestsLibrary
Resource    ../resources/http_session.resource


*** Test Cases ***
Correct Login
    [Setup]    Initialize Session    log_in=False
    Log In

Incorrect Login
    [Setup]    Initialize Session    log_in=False
    ${response_body} =    Try Log In    ${INCORRECT_AUTH_CREDENTIALS}
    Dictionary Should Contain Item    ${response_body}    key=reason    value=Bad credentials
