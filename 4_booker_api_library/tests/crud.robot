*** Settings ***
Library         Collections

Variables       ../resources/credentials.yaml
Variables       ../resources/request_payloads.yaml
Library         ../BookerAPILibrary.py    ${API_URL}    ${CORRECT_AUTH_CREDENTIALS}


*** Variables ***
${OBJECT_NAME}      booking


*** Test Cases ***
Get Many

Get Many Test
    ${response_body}    Send Get Request    ${OBJECT_NAME}
    Should Not Be Empty    ${response_body}
    ${bookings_count}    Get Length    ${response_body}
    Should Not Be Equal As Integers    ${bookings_count}    0

Get One Test
    Requs
    ${response_body}    Send Get Request    ${OBJECT_NAME}
    ${object_id}    Get From List    ${response_body}    0
    ${response_body}    Send Get Request    ${OBJECT_NAME}    ${object_id}

Insert Test
    Log In
    ${response}    POST    ${ENDPOINT_URL}    json=${insert_data}
    Log Dictionary    ${response.json()}
    Request Should Be Successful
    VAR    ${booking_id}    ${response.json()}[bookingid]
    ${response}    GET    ${ENDPOINT_URL}/${booking_id}
    Dictionaries Should Be Equal    ${response.json()}    ${insert_data}    ignore_keys=["bookingid"]

Update Test
    ${token}    Get Token
    ${headers}    Prepare Headers    ${token}

Partial Update Test
    ${token}    Get Token
    ${headers}    Prepare Headers    ${token}
    ${response}    POST    ${ENDPOINT_URL}    json=${insert_data}
    Request Should Be Successful
    VAR    ${booking_id}    ${response.json()}[bookingid]
    ${response}    PATCH    ${ENDPOINT_URL}/${booking_id}    json=${partial_update_date}    headers=${headers}
    # all key-value pairs from ${partial_update_date} must be present and equal in the response body
    Dictionary Should Contain Sub Dictionary    ${response.json()}    ${partial_update_date}    ignore_value_order=True


*** Keywords ***
Get Record Ids
    ${records}              Send Get Request        /${OBJECT_NAME}
    RETURN                  ${records}

Get First Record Id
    ${records}              Get Record Ids
    RETURN                  ${records}[0][bookingid]

Get Record By Id
    [Arguments]             ${record_id}
    ${record}               Send Get Request        /${OBJECT_NAME}/${record_id}
    RETURN                  ${record}
