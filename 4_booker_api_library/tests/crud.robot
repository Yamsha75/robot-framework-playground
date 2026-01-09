*** Settings ***
Library         Collections
Variables       ../resources/credentials.yaml
Variables       ../resources/request_payloads.yaml
Library         ../BookerAPILibrary.py    ${API_URL}    ${CORRECT_AUTH_CREDENTIALS}


*** Test Cases ***
Get Many Test
    ${records}    Get Booking Ids
    Response Should Not Be Empty
    VAR    ${first_record}    ${records}[0]
    Dictionary Should Contain Key    ${first_record}    bookingid

Get One Test
    ${record_id}    Get Random Booking Id
    ${record}    Get Booking    ${record_id}
    Response Should Not Be Empty
    Lists Should Be Equal    ${record.keys()}    ${INSERT_DATA.keys()}    ignore_order=True

Insert Test
    ${response_body}    Create Booking    ${INSERT_DATA}
    Log Dictionary    ${response_body}
    Response Should Not Be Empty
    VAR    ${record_id}    ${response_body}[bookingid]
    VAR    ${record}    ${response_body}[booking]
    # compare POST response with insert data
    Dictionaries Should Be Equal    ${record}    ${INSERT_DATA}    ignore_keys=["bookingid"]    ignore_value_order=True
    # compare GET response with insert data
    ${record}    Get Booking    ${record_id}
    Dictionaries Should Be Equal    ${record}    ${INSERT_DATA}    ignore_value_order=True

Update Test
    ${record_id}    Get Random Booking Id
    ${record}    Update Booking    ${record_id}    ${UPDATE_DATA}
    Log Dictionary    ${record}
    # compare PUT response with insert data
    Dictionaries Should Be Equal    ${record}    ${UPDATE_DATA}    ignore_keys=["bookingid"]    ignore_value_order=True
    # compare GET response with insert data
    ${record}    Get Booking    ${record_id}
    Dictionaries Should Be Equal    ${record}    ${UPDATE_DATA}    ignore_value_order=True

Partial Update Test
    ${record_id}    Get Random Booking Id
    ${record}    Partial Update Booking    ${record_id}    ${PARTIAL_UPDATE_DATA}
    # all key-value pairs from ${PARTIAL_UPDATE_DATA} must be present and equal in the response body
    Log Dictionary    ${record}
    Dictionary Should Contain Sub Dictionary    ${record}    ${PARTIAL_UPDATE_DATA}    ignore_value_order=True


*** Keywords ***
Get Random Booking Id
    ${records}              Get Booking Ids
    RETURN                  ${records}[0][bookingid]
