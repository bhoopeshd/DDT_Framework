*** Settings ***
Documentation     Data Utilities for robust test data generation.
...               Includes Random generation, Time handling, and Concatenation tools.
Library           String
Library           DateTime
Library           Collections

*** Keywords ***
# =============================================================================
# RANDOM GENERATION
# =============================================================================

Generate Random Number String
    [Documentation]    Generates a string of random digits. 
    ...                Default length is 10.
    [Arguments]    ${length}=10
    ${random_str}=    Generate Random String    ${length}    [NUMBERS]
    Log    Generated Random Numbers: ${random_str}    level=INFO
    RETURN    ${random_str}

Generate Random Name
    [Documentation]    Generates a random alphabetic name.
    ...                Default length is 8.
    [Arguments]    ${length}=8
    ${random_str}=    Generate Random String    ${length}    [LETTERS]
    ${capitalized}=   Convert To Title Case    ${random_str}
    Log    Generated Random Name: ${capitalized}    level=INFO
    RETURN    ${capitalized}

Get Current Date Time String
    [Documentation]    Returns current timestamp for concatenation (e.g. 20240101_120000).
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    RETURN    ${timestamp}

# =============================================================================
# CONCATENATION HELPERS
# =============================================================================

Concat With Random Number
    [Documentation]    Appends a 10-digit random number to the input text.
    ...                Example: Input "User" -> Returns "User8473829102"
    [Arguments]    ${text}
    ${rand}=    Generate Random Number String    10
    ${result}=    Set Variable    ${text}${rand}
    Log    Concatenated Result: ${result}    level=INFO
    RETURN    ${result}

Concat With Timestamp
    [Documentation]    Appends current date-time suffix to input text.
    ...                Example: Input "Report_" -> Returns "Report_20240101_120000"
    [Arguments]    ${text}
    ${timestamp}=    Get Current Date Time String
    ${result}=    Set Variable    ${text}${timestamp}
    Log    Concatenated Result: ${result}    level=INFO
    RETURN    ${result}
