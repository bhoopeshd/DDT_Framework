*** Settings ***
Documentation     Data Manager - Excel Data Retrieval
...               =====================================
...               Native Robot Framework Excel handling.

Library           ExcelLibrary
Library           Collections
Library           String
Resource          ../Config/Global_Config.robot


*** Keywords ***
Load Data For Test Case
    [Documentation]    Loads test data for a TestID from Excel.
    [Arguments]    ${TestID}
    Log    Loading data for: ${TestID}    level=INFO
    
    Open Excel Document    ${DATA_FILE_PATH}    doc_id=testdata
    ${headers}=    Read Excel Row    row_num=1    max_num=20    sheet_name=${DATA_SHEET_NAME}
    
    ${found}=    Set Variable    ${FALSE}
    ${result}=    Create Dictionary
    
    FOR    ${row}    IN RANGE    2    100
        ${row_data}=    Read Excel Row    row_num=${row}    max_num=20    sheet_name=${DATA_SHEET_NAME}
        ${first_cell}=    Set Variable    ${row_data}[0]
        
        IF    '${first_cell}' == '${EMPTY}' or '${first_cell}' == 'None'
            BREAK
        END
        
        IF    '${first_cell}' == '${TestID}'
            ${result}=    Build Dictionary From Row    ${headers}    ${row_data}
            ${found}=    Set Variable    ${TRUE}
            BREAK
        END
    END
    
    Close Current Excel Document
    
    IF    ${found} == ${FALSE}
        Fail    TestID '${TestID}' not found in Excel
    END
    
    Log    Loaded data: ${result}    level=INFO
    RETURN    ${result}

Build Dictionary From Row
    [Documentation]    Builds dictionary from headers and row data.
    [Arguments]    ${headers}    ${row_data}
    ${dict}=    Create Dictionary
    ${len}=    Get Length    ${headers}
    
    FOR    ${i}    IN RANGE    ${len}
        ${key}=    Set Variable    ${headers}[${i}]
        ${val}=    Set Variable    ${row_data}[${i}]
        IF    '${key}' != '${EMPTY}' and '${key}' != 'None'
            Set To Dictionary    ${dict}    ${key}=${val}
        END
    END
    
    RETURN    ${dict}

Get Column Index By Name
    [Documentation]    Finds the column index for a given header name.
    [Arguments]    ${header_name}
    Open Excel Document    ${DATA_FILE_PATH}    doc_id=headercheck
    ${headers}=    Read Excel Row    row_num=1    max_num=20    sheet_name=${DATA_SHEET_NAME}
    Close Current Excel Document
    
    ${index}=    Set Variable    1
    ${search_header}=    Convert To Lower Case    ${header_name}
    FOR    ${header}    IN    @{headers}
        ${current_header}=    Convert To Lower Case    ${header}
        IF    '${current_header}' == '${search_header}'
            RETURN    ${index}
        END
        ${index}=    Evaluate    ${index} + 1
    END
    Fail    Column header '${header_name}' not found in Excel

Write Result To Excel
    [Documentation]    Writes test result back to Excel file based on column name.
    [Arguments]    ${TestID}    ${result}    ${column_name}=Result
    ${col_index}=    Get Column Index By Name    ${column_name}
    Log    Writing result '${result}' for ${TestID} to column '${column_name}' (Index: ${col_index})    level=INFO
    
    Open Excel Document    ${DATA_FILE_PATH}    doc_id=writedata
    
    FOR    ${row}    IN RANGE    2    100
        ${row_data}=    Read Excel Row    row_num=${row}    max_num=1    sheet_name=${DATA_SHEET_NAME}
        ${first_cell}=    Set Variable    ${row_data}[0]
        
        IF    '${first_cell}' == '${EMPTY}' or '${first_cell}' == 'None'
            BREAK
        END
        
        IF    '${first_cell}' == '${TestID}'
            Write Excel Cell    row_num=${row}    col_num=${col_index}    value=${result}    sheet_name=${DATA_SHEET_NAME}
            Save Excel Document    ${DATA_FILE_PATH}
            Log    Wrote '${result}' to row ${row}, column ${col_index}    level=INFO
            BREAK
        END
    END
    
    Close Current Excel Document

Write Data To Excel
    [Documentation]    Writes any data to Excel during test execution based on column name.
    ...                Use this to save auto-generated values, timestamps, etc.
    ...                
    ...                Arguments:
    ...                - ${TestID}: Test case ID to find the row
    ...                - ${column_name}: Column name to write to
    ...                - ${value}: Value to write
    ...                
    ...                Example:
    ...                | ${username}= | Generate Random Username |
    ...                | Write Data To Excel | TC_01 | Execution_Time | ${username} |
    [Arguments]    ${TestID}    ${column_name}    ${value}
    ${col_index}=    Get Column Index By Name    ${column_name}
    Log    Writing '${value}' for ${TestID} to column '${column_name}' (Index: ${col_index})    level=INFO
    
    Open Excel Document    ${DATA_FILE_PATH}    doc_id=writeruntime
    
    FOR    ${row}    IN RANGE    2    100
        ${row_data}=    Read Excel Row    row_num=${row}    max_num=1    sheet_name=${DATA_SHEET_NAME}
        ${first_cell}=    Set Variable    ${row_data}[0]
        
        IF    '${first_cell}' == '${EMPTY}' or '${first_cell}' == 'None'
            Fail    TestID '${TestID}' not found in Excel
            BREAK
        END
        
        IF    '${first_cell}' == '${TestID}'
            Write Excel Cell    row_num=${row}    col_num=${col_index}    value=${value}    sheet_name=${DATA_SHEET_NAME}
            Save Excel Document    ${DATA_FILE_PATH}
            Log    Successfully wrote '${value}' to row ${row}, column ${col_index}    level=INFO
            BREAK
        END
    END
    
    Close Current Excel Document

Write Cell Value To Excel
    [Documentation]    Writes a value to a specific cell in Excel.
    [Arguments]    ${row}    ${col}    ${value}
    Log    Writing '${value}' to cell (${row}, ${col})    level=INFO
    
    Open Excel Document    ${DATA_FILE_PATH}    doc_id=writecell
    Write Excel Cell    row_num=${row}    col_num=${col}    value=${value}    sheet_name=${DATA_SHEET_NAME}
    Save Excel Document    ${DATA_FILE_PATH}
    Close Current Excel Document
    
    Log    Successfully wrote to cell (${row}, ${col})    level=INFO
