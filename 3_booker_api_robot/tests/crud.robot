*** Settings ***
Library         Collections
Library         RequestsLibrary
Resource        ../resources/http_session.resource

Suite Setup     Initialize Session


*** Variables ***
${OBJECT_NAME}      booking


*** Test Cases ***
Get Many Test
    ${records}    Get Booking Ids
    Should Not Be Empty    ${records}
    ${records_count}    Get Length    ${records}
    Should Not Be Equal As Integers    ${records_count}    0
    VAR    ${first_record}    ${records}[0]
    Dictionary Should Contain Key    ${first_record}    bookingid

Get One Test
    ${record_id}    Get Random Booking Id
    ${record}    Get Booking    ${record_id}
    Lists Should Be Equal    ${record.keys()}    ${INSERT_DATA.keys()}    ignore_order=True

Insert Test
    ${response}    POST On Session    main    /${OBJECT_NAME}    json=${INSERT_DATA}
    VAR    ${response_body}    ${response.json()}
    Log Dictionary    ${response_body}
    Request Should Be Successful
    VAR    ${record_id}    ${response_body}[bookingid]
    VAR    ${record}    ${response_body}[booking]
    # compare POST response with insert data
    Dictionaries Should Be Equal    ${record}    ${INSERT_DATA}    ignore_keys=["bookingid"]    ignore_value_order=True
    # compare GET response with insert data
    ${record}    Get Booking    ${record_id}
    Dictionaries Should Be Equal    ${record}    ${INSERT_DATA}    ignore_value_order=True

Update Test
    ${record_id}    Get Random Booking Id
    ${response}    PUT On Session    main    /${OBJECT_NAME}/${record_id}    json=${UPDATE_DATA}
    VAR    ${record}    ${response.json()}
    Log Dictionary    ${record}
    # compare PUT response with insert data
    Dictionaries Should Be Equal    ${record}    ${UPDATE_DATA}    ignore_keys=["bookingid"]    ignore_value_order=True
    # compare GET response with insert data
    ${record}    Get Booking    ${record_id}
    Dictionaries Should Be Equal    ${record}    ${UPDATE_DATA}    ignore_value_order=True

Partial Update Test
    ${record_id}    Get Random Booking Id
    ${response}    PATCH On Session    main    /${OBJECT_NAME}/${record_id}    json=${PARTIAL_UPDATE_DATA}
    # all key-value pairs from ${PARTIAL_UPDATE_DATA} must be present and equal in the response body
    VAR    ${response_body}    ${response.json()}
    Log Dictionary    ${response_body}
    Dictionary Should Contain Sub Dictionary    ${response_body}    ${PARTIAL_UPDATE_DATA}    ignore_value_order=True


*** Keywords ***
Get Booking Ids
    ${response}             GET On Session          main                    /${OBJECT_NAME}
    Request Should Be Successful
    RETURN                  ${response.json()}

Get Random Booking Id
    ${records}              Get Booking Ids
    RETURN                  ${records}[0][bookingid]

Get Booking
    [Arguments]             ${record_id}
    ${response}             GET On Session          main                    /${OBJECT_NAME}/${record_id}
    Request Should Be Successful
    RETURN                  ${response.json()}
