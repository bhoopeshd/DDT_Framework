*** Settings ***
Documentation     Keywords - BDD Style with Smart Data Handling
...               ===============================================
...               - Fluent wait pattern for robust element handling
...               - JavaScript executor methods
...               - Uses all timing configs from Global_Config

Library           SeleniumLibrary
Library           Collections
Library           String
Library           OperatingSystem
Resource          ../Config/Global_Config.robot
Resource          ../Locators/Locators.robot
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
    Log To Console    \n🚀 Launching application (${BROWSER})...
    
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
    Log To Console    ✅ Browser launched successfully.

Enter User Credentials
    [Documentation]    Enters username and password from loaded test data.
    Log To Console    👤 Entering credentials for: ${TEST_DATA}[username]
    Fluent Wait For Element    ${LOGIN_USERNAME_INPUT}
    JS Clear And Input    ${LOGIN_USERNAME_INPUT}    ${TEST_DATA}[username]
    JS Clear And Input    ${LOGIN_PASSWORD_INPUT}    ${TEST_DATA}[password]

Click Login Button
    [Documentation]    Clicks the login submit button.
    Log To Console    🖱️ Clicking login button...
    Fluent Click Element    ${LOGIN_SUBMIT_BUTTON}
    Sleep    ${DELAY}

Validate Login Success
    [Documentation]    Validates successful login.
    Log To Console    🏆 Validating login success...
    Fluent Wait For Element    ${SECURE_AREA_HEADER}
    Page Should Contain    Secure Area
    Log To Console    ✅ Login validated!

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
    Write Data To Excel    ${TestID}    8    ${ts}
    Log    Updated runtime timestamp for ${TestID}: ${ts}    level=INFO


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


# =============================================================================
# JAVASCRIPT EXECUTOR KEYWORDS
# =============================================================================

JS Click Element
    [Documentation]    Clicks element using JavaScript (bypasses visibility issues).
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].click();    ARGUMENTS    ${element}
    Log    JS clicked: ${locator}    level=INFO

JS Input Text
    [Documentation]    Inputs text using JavaScript.
    [Arguments]    ${locator}    ${text}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].value='${text}';    ARGUMENTS    ${element}
    Log    JS input: ${text}    level=INFO

JS Clear And Input
    [Documentation]    Clears and inputs text using JavaScript.
    [Arguments]    ${locator}    ${text}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].value='';    ARGUMENTS    ${element}
    Execute Javascript    arguments[0].value='${text}';    ARGUMENTS    ${element}
    # Trigger input event for frameworks like React/Angular
    Execute Javascript    arguments[0].dispatchEvent(new Event('input', {bubbles: true}));    ARGUMENTS    ${element}
    Log    JS clear+input: ${text}    level=INFO

JS Get Text
    [Documentation]    Gets text from element using JavaScript.
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    ${text}=    Execute Javascript    return arguments[0].textContent || arguments[0].innerText;    ARGUMENTS    ${element}
    Log    JS got text: ${text}    level=INFO
    RETURN    ${text}

JS Get Value
    [Documentation]    Gets value from input using JavaScript.
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    ${value}=    Execute Javascript    return arguments[0].value;    ARGUMENTS    ${element}
    Log    JS got value: ${value}    level=INFO
    RETURN    ${value}

JS Scroll To Element
    [Documentation]    Scrolls to element using JavaScript.
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].scrollIntoView({behavior: 'smooth', block: 'center'});    ARGUMENTS    ${element}
    Sleep    ${DELAY}
    Log    JS scrolled to: ${locator}    level=INFO

JS Scroll To Top
    [Documentation]    Scrolls to page top using JavaScript.
    Execute Javascript    window.scrollTo({top: 0, behavior: 'smooth'});
    Log    JS scrolled to top    level=INFO

JS Scroll To Bottom
    [Documentation]    Scrolls to page bottom using JavaScript.
    Execute Javascript    window.scrollTo({top: document.body.scrollHeight, behavior: 'smooth'});
    Log    JS scrolled to bottom    level=INFO

JS Scroll By
    [Documentation]    Scrolls by pixels using JavaScript.
    [Arguments]    ${x}=0    ${y}=300
    Execute Javascript    window.scrollBy({top: ${y}, left: ${x}, behavior: 'smooth'});
    Log    JS scrolled by (${x}, ${y})    level=INFO

JS Highlight Element
    [Documentation]    Highlights element for debugging (adds border).
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].style.border='3px solid red';    ARGUMENTS    ${element}
    Log    Highlighted: ${locator}    level=INFO

JS Remove Attribute
    [Documentation]    Removes attribute from element using JavaScript.
    [Arguments]    ${locator}    ${attribute}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].removeAttribute('${attribute}');    ARGUMENTS    ${element}
    Log    Removed ${attribute} from ${locator}    level=INFO

JS Set Attribute
    [Documentation]    Sets attribute on element using JavaScript.
    [Arguments]    ${locator}    ${attribute}    ${value}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript    arguments[0].setAttribute('${attribute}', '${value}');    ARGUMENTS    ${element}
    Log    Set ${attribute}=${value} on ${locator}    level=INFO

JS Is Element Visible
    [Documentation]    Checks if element is visible using JavaScript.
    [Arguments]    ${locator}
    ${element}=    Get WebElement    ${locator}
    ${visible}=    Execute Javascript
    ...    var elem = arguments[0];
    ...    var style = window.getComputedStyle(elem);
    ...    return style.display !== 'none' && style.visibility !== 'hidden' && elem.offsetParent !== null;
    ...    ARGUMENTS    ${element}
    RETURN    ${visible}

JS Wait For Page Load
    [Documentation]    Waits for page to fully load using JavaScript.
    Wait Until Keyword Succeeds    ${PAGE_LOAD_TIMEOUT}    1s
    ...    Execute Javascript    return document.readyState === 'complete';
    Log    Page fully loaded    level=INFO

JS Wait For Ajax
    [Documentation]    Waits for AJAX requests to complete (jQuery).
    TRY
        Wait Until Keyword Succeeds    ${WAIT_TIME}    ${DELAY}
        ...    Execute Javascript    return jQuery.active === 0;
        Log    AJAX complete    level=INFO
    EXCEPT
        Log    No jQuery or no AJAX to wait for    level=DEBUG
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
# STANDARD ELEMENT KEYWORDS (with timeout)
# =============================================================================

Wait For Element
    [Documentation]    Waits for element to be visible.
    [Arguments]    ${locator}    ${timeout}=${WAIT_TIME}
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}

Click On Element
    [Documentation]    Waits and clicks element.
    [Arguments]    ${locator}
    Fluent Wait For Element    ${locator}
    Fluent Wait For Element Enabled    ${locator}
    Click Element    ${locator}

Enter Text In Field
    [Documentation]    Clears and enters text.
    [Arguments]    ${locator}    ${text}
    Fluent Wait For Element    ${locator}
    Clear Element Text    ${locator}
    Input Text    ${locator}    ${text}

Enter Password In Field
    [Documentation]    Enters password securely.
    [Arguments]    ${locator}    ${password}
    Fluent Wait For Element    ${locator}
    Clear Element Text    ${locator}
    Input Password    ${locator}    ${password}

Get Text From Element
    [Documentation]    Gets text from element.
    [Arguments]    ${locator}
    Fluent Wait For Element    ${locator}
    ${text}=    Get Text    ${locator}
    RETURN    ${text}


# =============================================================================
# VERIFICATION KEYWORDS
# =============================================================================

Verify Element Is Visible
    [Documentation]    Verifies element visible with fluent wait.
    [Arguments]    ${locator}
    Fluent Wait For Element    ${locator}

Verify Text Contains
    [Documentation]    Verifies element text contains expected.
    [Arguments]    ${locator}    ${expected}
    ${actual}=    Get Text From Element    ${locator}
    Should Contain    ${actual}    ${expected}

Verify Page Contains Text
    [Documentation]    Verifies page contains text.
    [Arguments]    ${text}
    Page Should Contain    ${text}


# =============================================================================
# SCREENSHOT KEYWORDS
# =============================================================================

Take Screenshot
    [Documentation]    Takes screenshot with prefix.
    [Arguments]    ${prefix}=screenshot
    ${ts}=    Evaluate    __import__('datetime').datetime.now().strftime('%Y%m%d_%H%M%S')
    Capture Page Screenshot    ${prefix}_${ts}.png


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
# CONSOLE LOGGING KEYWORDS
# =============================================================================

Log Test Step
    [Documentation]    Logs a major test step to both log file and console.
    [Arguments]    ${step}    ${description}
    Log    ════════════════════════════════════════    level=INFO
    Log    STEP ${step}: ${description}    level=INFO
    Log    ════════════════════════════════════════    level=INFO
    Log To Console    \n📍 STEP ${step}: ${description}

Console Log
    [Documentation]    Logs a message directly to the terminal.
    [Arguments]    ${message}
    Log To Console    \n📢 ${message}

