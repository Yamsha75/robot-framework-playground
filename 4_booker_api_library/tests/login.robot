*** Settings ***
Library         Collections

Variables       ../resources/credentials.yaml
Library         ../BookerAPILibrary.py    ${API_URL}


*** Test Cases ***
Correct Login
    Log In    ${CORRECT_AUTH_CREDENTIALS}

Incorrect Login
    ${response_body} =    Try Log In    ${INCORRECT_AUTH_CREDENTIALS}
    Dictionary Should Contain Item    ${response_body}    key=reason    value=Bad credentials
