*** Settings ***
Documentation     Login Test Suite - BDD Style
...               ================================
...               Readable test steps with smart data handling.

Resource          ../Resources/Keywords/Step_Definitions.robot

Suite Setup       Clear Results Folder
Suite Teardown    Close Browser Safely

Test Teardown     Run Keywords
...               Write Test Result    ${TEST_NAME}    ${TEST_STATUS}
...               AND    Run Keyword If Test Failed    Take Screenshot    failed
...               AND    Close Browser Safely


*** Test Cases ***
TC_01 Valid Login Test
    [Documentation]    Tests successful login with valid credentials.
    [Tags]    login    smoke    positive
    
    Log Test Step    1    Loading data from Excel
    Load Test Data    TC_01
    Log Test Step    2    Launching Application
    Launch Application
    Log Test Step    3    Entering User Credentials
    Enter User Credentials
    Log Test Step    4    Clicking Login Button
    Click Login Button
    Log Test Step    5    Validating Login Success
    Validate Login Success
    Log Test Step    6    Updating Runtime Data in Excel
    Update Execution Timestamp    TC_01
    Capture Screenshot Evidence

TC_02 Invalid Login Test
    [Documentation]    Tests login failure with invalid credentials.
    [Tags]    login    regression    negative
    
    Load Test Data    TC_02
    Launch Application
    Enter User Credentials
    Click Login Button
    Validate Login Error Message

TC_03 Empty Username Login Test
    [Documentation]    Tests login with empty username.
    [Tags]    login    regression    negative
    
    Load Test Data    TC_03
    Launch Application
    Enter User Credentials
    Click Login Button
    Validate Login Error Message

TC_04 Login And Logout Test
    [Documentation]    Tests complete login and logout flow.
    [Tags]    login    logout    smoke
    
    Load Test Data    TC_04
    Launch Application
    Enter User Credentials
    Click Login Button
    Validate Login Success
    Click Logout Button
    Validate Logout Success

TC_05 Verify Page Elements Test
    [Documentation]    Verifies login page UI elements.
    [Tags]    ui    smoke
    
    Load Test Data    TC_05
    Launch Application
    Validate Login Page Elements
    Validate Page Title


*** Keywords ***
Write Test Result
    [Documentation]    Writes result to Excel.
    [Arguments]    ${test_name}    ${status}
    ${test_id}=    Evaluate    "${test_name}".split()[0]
    TRY
        Write Result To Excel    ${test_id}    ${status}
    EXCEPT    AS    ${error}
        Log    Could not write to Excel: ${error}    level=WARN
    END
