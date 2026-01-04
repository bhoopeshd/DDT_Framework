*** Settings ***
Library           SeleniumLibrary
Resource          ../Config/Global_Config.robot

*** Keywords ***
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
