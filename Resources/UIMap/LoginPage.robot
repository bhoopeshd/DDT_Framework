*** Variables ***
# =============================================================================
# LOGIN PAGE LOCATORS
# =============================================================================

${LOGIN_USERNAME_INPUT}             id=username
${LOGIN_PASSWORD_INPUT}             id=password
${LOGIN_SUBMIT_BUTTON}              css=button[type='submit']
${LOGIN_SUCCESS_MESSAGE}            css=div.flash.success
${LOGIN_ERROR_MESSAGE}              css=div.flash.error
${LOGIN_FORM}                       id=login
${SECURE_AREA_HEADER}               css=h2
${SECURE_AREA_MESSAGE}              css=div.flash.success
${LOGOUT_BUTTON}                    css=a[href='/logout']
${DROPDOWN_SELECT}                  id=dropdown
${CHECKBOX_1}                       css=#checkboxes input:nth-child(1)
${CHECKBOX_2}                       css=#checkboxes input:nth-child(3)
${PAGE_HEADER}                      css=h3, h2, h1
${PAGE_CONTENT}                     css=div.example, div#content
${PAGE_FOOTER}                      css=div#page-footer
${LOADING_SPINNER}                  css=div#loading
${MODAL_CONTAINER}                  css=div.modal
${ALERT_MESSAGE}                    css=div.flash, div.alert
