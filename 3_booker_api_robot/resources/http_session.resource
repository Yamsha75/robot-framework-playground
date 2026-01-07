*** Settings ***
Library         Collections
Library         RequestsLibrary
Variables       request_payloads.yaml
Variables       credentials.yaml


*** Variables ***
${API_URL}      https://restful-booker.herokuapp.com


*** Keywords ***
Initialize Session
    [Arguments]             ${log_in}=True
    Create Session          main                    url=${API_URL}          disable_warnings=True
    IF    ${log_in}    Log In

Try Log In
    [Arguments]             ${credentials_dict}
    ${response} =           POST On Session
    ...                     main
    ...                     url=auth
    ...                     json=${credentials_dict}
    Request Should Be Successful
    RETURN                  ${response.json()}

Log In
    ${response_body} =      Try Log In              ${CORRECT_AUTH_CREDENTIALS}
    Dictionary Should Contain Key                   ${response_body}        token
    VAR    ${token} =       ${response_body}[token]
    VAR    &{headers} =     Cookie=token\=${token}
    Update Session          main                    headers=&{headers}
