*** Settings ***
Library     Collections
Library     ../AutosortListLibrary.py    INT


*** Test Cases ***
Test Adding Two Items
    Append    5
    Append    3
    List Should Equal    3    5

Test Extending
    Extend    5    2    9    4
    List Should Equal    2    4    5    9
    Extend    1    3    8    7
    List Should Equal    1    2    3    4    5    7    8    9

Test Indexing
    Extend    9    3    1    2
    Index Should Be Equal    2    1
    Index Should Be Equal    9    3
    Index Should Be Equal    1    0

Test Counting
    Extend    2    4    3    1    6    4    2    3    2    2    2    3
    Count Should Be Equal    1    1
    Count Should Be Equal    2    5
    Count Should Be Equal    3    3
    Count Should Be Equal    4    2

Test Length
    Length Should Be Equal    0
    Append    9
    Length Should Be Equal    1
    Extend    5    3
    Length Should Be Equal    3


*** Keywords ***
Index Should Be Equal
    [Arguments]             ${value}                ${expected_index}
    ${index} =              Index                   ${value}
    Should Be Equal As Integers                     ${index}                ${expected_index}

Count Should Be Equal
    [Arguments]             ${value}                ${expected_count}
    ${count} =              Count                   ${value}
    Should Be Equal As Integers                     ${count}                ${expected_count}

Length Should Be Equal
    [Arguments]             ${expected_length}
    ${length} =             AutosortListLibrary.Get Length
    Should Be Equal As Integers                     ${length}               ${expected_length}
