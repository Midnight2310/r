*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime

*** Variables ***
${BROWSER}    chrome
${URL}    http://localhost:5173/
${DELAY}    0
${SCREENSHOT_DIR}    screenshots
*** Keywords ***
Capture Step Screenshot
    [Arguments]    ${step_name}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${step_name}_${timestamp}.png
Signup
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Wait Until Element Is Visible    id=role-btn-trader
    Click Element    id=role-btn-trader

    Wait Until Element Is Visible    id=signup-btn
    Click Element    id=signup-btn
    Input Text    id=name-input    Phattarapong Uknowme
    Input Text    id=company-input    Uknowme Asset
    Input Text    id=citizen-id-input    1429900959405
    Input Text    id=email-input    phattarapong@gmail.com
    Input Text    id=phone-input    0966566414
    Wait Until Element Is Visible    id=submit-signup-btn
    Click Element    id=submit-signup-btn
    
    # Confirm Registration Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สมัครสมาชิกสำเร็จ!
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    [Teardown]    Close Browser

LogIn
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    ${DELAY}
    Maximize Browser Window
    Capture Step Screenshot    user_login_start
    
    # Select User Role
    Wait Until Element Is Visible    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Click Element    xpath=//button[contains(@class, 'role-button') and .//span[text()='ผู้ค้าตราสารหนี้']]
    Capture Step Screenshot    user_role_selected
    
    # Input Login Credentials
    Wait Until Element Is Visible    id=email-input
    Input Text    id=email-input    phattarapong@gmail.com
    Input Password    id=password-input    12345
    Capture Step Screenshot    user_credentials_entered
    
    # Click Login Button
    Click Element    id=login-submit-btn
    
    # Verify Login Success
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เข้าสู่ระบบสำเร็จ!
    Capture Step Screenshot    user_login_success
    

Homepage
    Go To    http://localhost:5173/UserHomepage
    Sleep    5s 

Profile
    Wait Until Element Is Visible    xpath=//*[@id="user-menu-btn"]
    Click Element    xpath=//*[@id="user-menu-btn"]

*** Test Cases ***
TCI001-การสมัครสมาชิก
    Signup

TCI002-เข้าสู่ระบบผู้ค้าตราสารหนี้
    LogIn

TCI003-โปรไฟล์
    LogIn
    Homepage
    Profile
    [Teardown]    Close Browser

TCI004-แก้ไขข้อมูลโปรไฟล์
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    xpath=//*[@id="profile-btn"]
    Click Element    xpath=//*[@id="profile-btn"]

    # Edit Profile Information
    Wait Until Element Is Visible    id=edit-profile-btn
    Click Element    id=edit-profile-btn

    Choose File    id=profile-picture-input    ${CURDIR}/image/download.jpg

    Wait Until Element Is Visible    id=save-profile-btn
    Click Element    id=save-profile-btn
    [Teardown]    Close Browser

TCI005-เปลี่ยนรหัสผ่าน
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    id=change-password-btn
    Click Element    id=change-password-btn
    Input Password    id=swal-old-password    1429900959405
    Input Password    id=swal-new-password    12345

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    เปลี่ยนรหัสผ่าน
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Sleep    3s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    สำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

TCI006-หลักสูตรของฉัน
    LogIn
    Homepage
    Profile
    Wait Until Element Is Visible    xpath=//*[@id="profile-btn"]
    Click Element    xpath=//*[@id="profile-btn"]

    Wait Until Element Is Visible    id=my-courses-link
    Click Element    id=my-courses-link

TCI007-ลงทะเบียนคอร์ส
    LogIn
    Homepage

    Wait Until Element Is Visible    xpath=//*[@id="course-card-6709c570c628150b54faeab8"]
    Click Element    xpath=//*[@id="course-card-6709c570c628150b54faeab8"]
    Wait Until Element Is Visible    id=register-course-btn
    Click Element    id=register-course-btn

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ลงทะเบียนสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]

TCI-008-เริ่มเรียน
    LogIn
    Homepage

    Wait Until Element Is Visible    xpath=//*[@id="course-card-6709c570c628150b54faeab8"]
    Click Element    xpath=//*[@id="course-card-6709c570c628150b54faeab8"]
    Wait Until Element Is Visible    id=start-learning-btn
    Click Element    id=start-learning-btn
    [Teardown]    Close Browser

TCI_009-ยกเลิกการลงทะเบียน
    LogIn
    Homepage

    Wait Until Element Is Visible    xpath=//*[@id="course-card-6709c570c628150b54faeab8"]
    Click Element    xpath=//*[@id="course-card-6709c570c628150b54faeab8"]
    Wait Until Element Is Visible    xpath=//*[@id="cancel-enrollment-btn"]
    Click Element    xpath=//*[@id="cancel-enrollment-btn"]

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยืนยันการยกเลิกการลงทะเบียน
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    Sleep    5s
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยกเลิกการลงทะเบียนสำเร็จ
    Click Element    xpath=//button[contains(@class, 'swal2-confirm')]
    [Teardown]    Close Browser

TCI010-ตารางอบรม
    LogIn
    Homepage
    Click Element    id=user-nav-link-schedule

TCI011-ดาว์นโหลดใบรับรอง
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    xpath=//*[@id="profile-btn"]
    Click Element    xpath=//*[@id="profile-btn"]

    Wait Until Element Is Visible   id=my-courses-link
    Click Element   id=my-courses-link

    Wait Until Element Is Visible    id=download-certificate-btn-0
    Click Element    id=download-certificate-btn-0
    [Teardown]    Close Browser

TCI012-ออกจากระบบ
    LogIn
    Homepage
    Profile

    Wait Until Element Is Visible    id=logout-btn
    Click Element    id=logout-btn

    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-popup')]
    Element Should Contain    xpath=//h2[contains(@class, 'swal2-title')]    ยืนยันการออกจากระบบ