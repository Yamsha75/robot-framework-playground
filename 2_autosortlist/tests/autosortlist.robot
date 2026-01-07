*** Settings ***
Library     Collections
Library     ../AutosortListLibrary.py    INT


*** Test Cases ***
Test Adding Two Items
    Append                  5
    Append                  3
    List Should Equal       3    5

Test Extending
    Extend                  5    2    9    4
    List Should Equal       2    4    5    9
    Extend                  1    3    8    7
    List Should Equal       1    2    3    4    5    7    8    9

Test Indexing
    Extend          9    3    1    2
    ${index} =      Index     2
    Should Be Equal As Integers    ${index}    1
    ${index} =      Index     9
    Should Be Equal As Integers    ${index}    3
    Index Should Be Equal     1    0

Test Counting
    Extend        2    4    3    1    6    4    2    3    2    2    2    3
    ${count} =    Count     1
    Should Be Equal As Integers    ${count}    1
    ${count} =    Count     2
    Should Be Equal As Integers    ${count}    5
    ${count} =    Count     3
    Should Be Equal As Integers    ${count}    3
    ${count} =    Count     4
    Should Be Equal As Integers    ${count}    2

Test Length
    ${len} =    AutosortListLibrary.Get Length
    Should Be Equal As Integers    ${len}    0


*** Keywords ***
Index Should Be Equal
    [Arguments]             ${value}                ${expected_index}
    ${index} =              Index                   ${value}
    Should Be Equal As Integers                     ${index}                ${expected_index}

Length Should Be Equal
    [Arguments]             ${expected_length}
    ${length} =             AutosortListLibrary.Get Length
    Should Be Equal As Integers                     ${length}               ${expected_length}
