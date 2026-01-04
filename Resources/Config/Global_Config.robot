*** Settings ***
Documentation     Global Configuration
...               ======================
...               Environment properties - URL, Browser, Timing
...               Override via: robot --variable BROWSER:firefox Tests/


*** Variables ***
# =============================================================================
# ENVIRONMENT CONFIGURATION (Not in Excel)
# =============================================================================

# Application URL
${URL}                      https://the-internet.herokuapp.com/login

# Browser Configuration
${BROWSER}                  edge
${HEADLESS}                 ${FALSE}
${INCOGNITO}                ${FALSE}

# Suppress browser noise logs (ERROR:chrome...)
${BROWSER_LOG_LEVEL}        3

# Timing Configuration
${WAIT_TIME}                10s
${DELAY}                    500ms
${IMPLICIT_WAIT}            5s
${PAGE_LOAD_TIMEOUT}        30s

# =============================================================================
# DATA CONFIGURATION
# =============================================================================

# Path to test data Excel
${DATA_FILE_PATH}           ${CURDIR}${/}..${/}..${/}Data${/}TestData.xlsx
${DATA_SHEET_NAME}          Sheet1
