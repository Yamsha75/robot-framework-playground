*** Settings ***
Library             ../CalculatorLibrary.py

Test Template       Calculate


*** Test Cases ***          Expression          Expected
Check Operation Order       1 + 10 * 2          21
                            1 + ( 10 * 2 )      21
                            ( 1 + 10 ) * 2      22
                            ( 2 + 3 ) * 3       15
                            2 * ( 3 + - 1 )     4


*** Keywords ***
Calculate
    [Arguments]             ${expression}           ${expected}
    ${result}               Calculate Expression    C${expression}\=
    Log                     ${result}
    Should Be Equal         ${result}               ${expected}
