*** Settings ***
Documentation     UI Verification Test Suite
...               ==========================
...               Checks for element presence and static content.

Resource          ../Resources/Steps/Steps.robot

Suite Setup       Clear Results Folder
Suite Teardown    Close Browser Safely

Test Teardown     Run Keywords
...               Write Test Result    ${TEST_NAME}    ${TEST_STATUS}
...               AND    Run Keyword If Test Failed    Take Screenshot    failed
...               AND    Close Browser Safely


*** Test Cases ***
TC_05 Verify Page Elements Test
    [Documentation]    Verifies login page UI elements.
    [Tags]    ui    smoke
    
    Load Test Data    TC_05
    Launch Application
    Validate Login Page Elements
    Validate Page Title
