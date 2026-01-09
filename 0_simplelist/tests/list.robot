*** Settings ***
Library         Collections
Variables       ../resources/variables.py


*** Variables ***
@{LIST1}        ${1}    ${2}
@{LIST2}        ${3}    ${4}
${TEST_VAR}     First Line
...             Second Line
...             separator=<->


*** Test Cases ***
Test Log With Multiline Variable With Custom Separator
    Log    ${TEST_VAR}, yo

Test List Concat
    ${combined_list}    Combine Lists    ${LIST1}    ${LIST2}
    Should Be Equal    ${combined_list}[0]    ${1}
    Should Be Equal    ${combined_list}[1]    ${2}
    Should Be Equal    ${combined_list}[2]    ${3}
    Should Be Equal    ${combined_list}[3]    ${4}

Test Lists Values
    FOR    ${index}    ${item}    IN ENUMERATE    @{LIST1}
        Should Be Equal    ${item + 2}    ${LIST2}[${index}]
    END

Test List Length
    ${len}    Get Length    ${LIST3}
    Should Be Equal    ${len}    ${10}
