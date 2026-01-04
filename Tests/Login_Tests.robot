*** Settings ***
Documentation     Login Functionality Test Suite
...               ==============================
...               Covers positive, negative, and workflow scenarios.

Resource          ../Resources/Steps/Steps.robot

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
    
    Load Test Data    TC_01
    Launch Application
    Enter User Credentials
    Click Login Button
    Validate Login Success
    Update Execution Timestamp    TC_01
    Capture Screenshot Evidence    Login_Success

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
