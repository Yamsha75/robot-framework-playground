*** Settings ***
Library     ../CalculatorLibrary.py


*** Variables ***
${TEST_VAR}     First Line
...             Second Line
...             separator=<->


*** Test Cases ***
Calculate Sum Of Positive Integers
    Push Buttons        2 + 3 \=
    Result Should Be    5

Calculate Sum Of Negative Integers
    Push Buttons        - 1 + - 3 \=
    Result Should Be    -4

Calculate Multiplication
    Push Buttons        - 2 * 4 \=
    Result Should Be    -8

Calculate Multiplication By Zero
    Push Buttons        - 0 * 10 \=
    Result Should Be    0

Calculate Division
    Push Buttons        12 / 3 \=
    Result Should Be    4

Assert Division By Zero Is Invalid
    ${error}           Should Cause Error    12 / 0 \=
    Should Be Equal    ${error}              Division by zero.

Calculate With Order Of Operations
    Push Buttons        1 + 2 * 3 \=
    Result Should Be    7

Test Log With Multiline Variable With Custom Separator
    Log    ${TEST_VAR}, yo
