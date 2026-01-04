*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           String
Library           OperatingSystem
Resource          ../Config/Global_Config.robot
Resource          ../UIMap/UIMap.robot
Resource          ../DataManager/DataManager.robot

*** Variables ***
${TEST_DATA}      ${EMPTY}

*** Keywords ***
# =============================================================================
# BDD STEP KEYWORDS (Use stored ${TEST_DATA})
# =============================================================================

Load Test Data
    [Documentation]    Loads test data from Excel and stores for use by other keywords.
    [Arguments]    ${TestID}
    ${data}=    Load Data For Test Case    ${TestID}
    Set Test Variable    ${TEST_DATA}    ${data}
    Log    Loaded data for ${TestID}: ${TEST_DATA}    level=INFO

Launch Application
    [Documentation]    Opens browser and navigates to application URL.
    ...                Consolidates browser options for headless and incognito.
    Log To Console    \nLaunching application (${BROWSER})...
    
    ${options}=    Set Variable    add_argument("--log-level=${BROWSER_LOG_LEVEL}"); add_argument("--disable-logging"); add_argument("--silent")
    
    IF    ${HEADLESS}
        ${options}=    Set Variable    ${options}; add_argument("--headless")
    END
    
    IF    ${INCOGNITO}
        IF    "${BROWSER}" == "chrome" or "${BROWSER}" == "headlesschrome"
            ${options}=    Set Variable    ${options}; add_argument("--incognito")
        ELSE IF    "${BROWSER}" == "edge" or "${BROWSER}" == "headlessedge"
            ${options}=    Set Variable    ${options}; add_argument("--inprivate")
        ELSE IF    "${BROWSER}" == "firefox" or "${BROWSER}" == "headlessfirefox"
            ${options}=    Set Variable    ${options}; add_argument("-private")
        END
    END

    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Timeout    ${WAIT_TIME}
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Fluent Wait For Element    ${LOGIN_USERNAME_INPUT}
    Log To Console    Browser launched successfully.

Enter User Credentials
    [Documentation]    Enters username and password from loaded test data.
    Log To Console    Entering credentials for: ${TEST_DATA}[username]
    Fluent Wait For Element    ${LOGIN_USERNAME_INPUT}
    JS Clear And Input    ${LOGIN_USERNAME_INPUT}    ${TEST_DATA}[username]
    JS Clear And Input    ${LOGIN_PASSWORD_INPUT}    ${TEST_DATA}[password]

Click Login Button
    [Documentation]    Clicks the login submit button.
    Log To Console    Clicking login button...
    Fluent Click Element    ${LOGIN_SUBMIT_BUTTON}
    Sleep    ${DELAY}

Validate Login Success
    [Documentation]    Validates successful login.
    Log To Console    Validating login success...
    Fluent Wait For Element    ${SECURE_AREA_HEADER}
    Page Should Contain    Secure Area
    Log To Console    Login validated!

Validate Login Error Message
    [Documentation]    Validates login error message from test data.
    Log    Validating error message    level=INFO
    Fluent Wait For Element    ${LOGIN_ERROR_MESSAGE}
    ${error_text}=    JS Get Text    ${LOGIN_ERROR_MESSAGE}
    Should Contain    ${error_text}    ${TEST_DATA}[expected_error]

Click Logout Button
    [Documentation]    Clicks the logout button.
    Log    Clicking logout button    level=INFO
    Fluent Click Element    ${LOGOUT_BUTTON}
    Sleep    ${DELAY}

Validate Logout Success
    [Documentation]    Validates successful logout.
    Log    Validating logout success    level=INFO
    Fluent Wait For Element    ${LOGIN_USERNAME_INPUT}
    Page Should Contain    Login

Validate Login Page Elements
    [Documentation]    Validates all login page elements are visible.
    Log    Validating login page elements    level=INFO
    Fluent Wait For Element    ${LOGIN_USERNAME_INPUT}
    Fluent Wait For Element    ${LOGIN_PASSWORD_INPUT}
    Fluent Wait For Element    ${LOGIN_SUBMIT_BUTTON}

Validate Page Title
    [Documentation]    Validates page title from test data.
    ${title}=    Get Title
    Should Contain    ${title}    ${TEST_DATA}[expected_title]

Capture Screenshot Evidence
    [Documentation]    Captures screenshot as test evidence.
    ${ts}=    Evaluate    __import__('datetime').datetime.now().strftime('%Y%m%d_%H%M%S')
    Capture Page Screenshot    evidence_${ts}.png

Update Execution Timestamp
    [Documentation]    Demonstrates writing runtime data (e.g., current timestamp) to Excel.
    ...                Writes to column 8 (Execution_Time).
    [Arguments]    ${TestID}
    ${ts}=    Evaluate    __import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    Write Data To Excel    ${TestID}    Execution_Time    ${ts}
    Log    Updated runtime timestamp for ${TestID}: ${ts}    level=INFO
