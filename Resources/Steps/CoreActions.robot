*** Settings ***
Library           SeleniumLibrary
Resource          ../Config/Global_Config.robot

*** Keywords ***
# =============================================================================
# SETUP/TEARDOWN KEYWORDS
# =============================================================================

Clear Results Folder
    [Documentation]    Clears the Results folder before test execution.
    ${results_path}=    Set Variable    ${EXECDIR}${/}Results
    TRY
        ${files}=    List Files In Directory    ${results_path}    absolute=True
        FOR    ${file}    IN    @{files}
            TRY
                Remove File    ${file}
            EXCEPT    AS    ${error}
                Log    Could not remove ${file}    level=DEBUG
            END
        END
        Log    Results folder cleared    level=INFO
    EXCEPT    AS    ${error}
        Log    Results folder not found or empty    level=DEBUG
    END

# =============================================================================
# FLUENT WAIT KEYWORDS (Retry mechanism like Java FluentWait)
# =============================================================================

Fluent Wait For Element
    [Documentation]    Waits for element with retry mechanism (Fluent Wait pattern).
    ...                Retries every ${DELAY} until ${WAIT_TIME} timeout.
    ...                Never fails immediately - keeps trying.
    [Arguments]    ${locator}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Wait Until Element Is Visible    ${locator}    timeout=1s
    Log    Element found: ${locator}    level=INFO

Fluent Wait For Element Enabled
    [Documentation]    Waits until element is enabled with retry.
    [Arguments]    ${locator}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Element Should Be Enabled    ${locator}
    Log    Element enabled: ${locator}    level=INFO

Fluent Wait For Element Not Visible
    [Documentation]    Waits until element disappears with retry.
    [Arguments]    ${locator}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Element Should Not Be Visible    ${locator}
    Log    Element gone: ${locator}    level=INFO

Fluent Click Element
    [Documentation]    Clicks element with retry until successful.
    [Arguments]    ${locator}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Click Element Safely    ${locator}
    Log    Clicked: ${locator}    level=INFO

Click Element Safely
    [Documentation]    Helper for Fluent Click - clicks if visible and enabled.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=2s
    Wait Until Element Is Enabled    ${locator}    timeout=2s
    Click Element    ${locator}

Fluent Input Text
    [Documentation]    Inputs text with retry until successful.
    [Arguments]    ${locator}    ${text}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Input Text Safely    ${locator}    ${text}
    Log    Input: ${text}    level=INFO

Input Text Safely
    [Documentation]    Helper for Fluent Input - clears and inputs text.
    [Arguments]    ${locator}    ${text}
    Wait Until Element Is Visible    ${locator}    timeout=2s
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

Fluent Select From List
    [Documentation]    Selects value from a standard <select> dropdown by label.
    [Arguments]    ${locator}    ${label}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Select From List By Label Safely    ${locator}    ${label}
    Log    Selected '${label}' from: ${locator}    level=INFO

Select From List By Label Safely
    [Documentation]    Helper for Fluent Select.
    [Arguments]    ${locator}    ${label}
    Wait Until Element Is Visible    ${locator}    timeout=2s
    Wait Until Element Is Enabled    ${locator}    timeout=2s
    Select From List By Label    ${locator}    ${label}

Fluent Select Custom
    [Documentation]    Selects value from a custom (div/ul) dropdown.
    ...                1. Clicks the trigger (dropdown opener).
    ...                2. Waits for option to be visible.
    ...                3. Clicks the option.
    [Arguments]    ${trigger_locator}    ${option_locator}    ${timeout}=${WAIT_TIME}    ${retry_interval}=${DELAY}
    Wait Until Keyword Succeeds    ${timeout}    ${retry_interval}
    ...    Select Custom Safely    ${trigger_locator}    ${option_locator}
    Log    Custom Selected: ${option_locator}    level=INFO

Select Custom Safely
    [Documentation]    Helper for Custom Select.
    [Arguments]    ${trigger_locator}    ${option_locator}
    Click Element Safely    ${trigger_locator}
    Wait Until Element Is Visible    ${option_locator}    timeout=2s
    Click Element Safely    ${option_locator}

Write Test Result
    [Documentation]    Writes result to Excel (Common Teardown).
    [Arguments]    ${test_name}    ${status}
    ${test_id}=    Evaluate    "${test_name}".split()[0]
    TRY
        Write Result To Excel    ${test_id}    ${status}
    EXCEPT    AS    ${error}
        Log    Could not write to Excel: ${error}    level=WARN
    END

# =============================================================================
# BROWSER KEYWORDS
# =============================================================================

Close Browser Safely
    [Documentation]    Safely closes all browsers.
    TRY
        Close All Browsers
        Log    Browser closed    level=INFO
    EXCEPT    AS    ${error}
        Log    Warning: ${error}    level=WARN
    END

# =============================================================================
# CONSOLE LOGGING KEYWORDS
# =============================================================================

Log Test Step
    [Documentation]    Logs a major test step to both log file and console.
    [Arguments]    ${step}    ${description}
    Log    ════════════════════════════════════════    level=INFO
    Log    STEP ${step}: ${description}    level=INFO
    Log    ════════════════════════════════════════    level=INFO
    Log To Console    \nSTEP ${step}: ${description}

Console Log
    [Documentation]    Logs a message directly to the terminal.
    [Arguments]    ${message}
    Log To Console    \n${message}

# =============================================================================
# SCREENSHOT KEYWORDS
# =============================================================================

Take Screenshot
    [Documentation]    Takes screenshot with prefix.
    [Arguments]    ${name}=screenshot
    ${ts}=    Evaluate    __import__('datetime').datetime.now().strftime('%Y%m%d_%H%M%S')
    Capture Page Screenshot    ${name}_${ts}.png
