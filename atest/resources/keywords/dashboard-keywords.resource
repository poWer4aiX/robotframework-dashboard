*** Settings ***
Library    String
Library    json
Library    Browser
Library    DocTest.VisualTest
Resource    ../variables/variables.resource


*** Variables ***
${ROOT_FOLDER}    ${CURDIR}/../../..
${SCREENSHOT_FOLDER}    ${ROOT_FOLDER}/results/browser/screenshot
${REFERENCE_FOLDER}    ${CURDIR}/../dashboard_output


*** Keywords ***
Start Browser
    New Browser    browser=chromium    headless=${True}

Stop Browser
    Close Browser

Open Dashboard
    New Context    colorScheme=dark    viewport={"width": 1920, "height": 1080}
    New Page    url=file:${ROOT_FOLDER}/robotdashboard_${DASHBOARD_INDEX}.html
    Wait For Elements State    selector=id=loading    state=hidden
    Click    selector=id=settings
    Fill Text    selector=id=toggleAnimationDuration    txt=0
    Click    selector=id=closeSettings
    Wait For Elements State    selector=id=loading    state=hidden

Close Dashboard
    Close Page
    Close Context

Open Overview Page
    Click    selector=id=menuOverview
    Wait For Elements State    selector=id=overviewLatestRunsSection
    Wait For Elements State    selector=id=overviewTotalStatsSection

Open Compare Page
    Click    selector=id=menuCompare
    Wait For Elements State    selector=id=compareStatisticsSection

Open Tables Page
    Click    selector=id=menuTables
    Wait For Elements State    selector=id=tablesStatisticsSection

Validate Screenshot
    [Arguments]    ${screenshot}    ${reference}    ${folder}
    VAR    ${reference}    ${REFERENCE_FOLDER}/${folder}/${reference}.png
    VAR    ${screenshot}    ${SCREENSHOT_FOLDER}/${screenshot}.png
    Compare Images    reference_image=${reference}    candidate_image=${screenshot}    threshold=0.02   # 98% accuracy

Validate Component
    [Arguments]    ${id}    ${name}    ${folder}
    Sleep    time_=1s
    Take Screenshot    filename=${SCREENSHOT_FOLDER}/${name}    selector=id=${id}
    Validate Screenshot    screenshot=${name}    reference=${name}    folder=${folder}

Set Run Filter
    [Arguments]    ${value}
    Set Run Filters    ${value}

Set Run Filters
    [Arguments]    @{values}
    Click    selector=id=filters
    FOR    ${value}    IN    @{values}
        Select Options By    id=runs    value    ${value}
    END
    Click    selector=id=closeFilters

Set Date Filter
    [Arguments]    ${fromDate}=${None}    ${fromTime}=${None}    ${toDate}=${None}    ${toTime}=${None}
    Click    selector=id=filters
    Sleep    time_=500ms
    IF    '${fromDate}' != '${None}'    Type Text    selector=id=fromDate    txt=${fromDate}    clear=True
    IF    '${fromTime}' != '${None}'    Type Text    selector=id=fromTime    txt=${fromTime}    clear=True
    IF    '${toDate}' != '${None}'    Type Text    selector=id=toDate    txt=${toDate}    clear=True
    IF    '${toTime}' != '${None}'    Type Text    selector=id=toTime    txt=${toTime}    clear=True
    Click    selector=id=closeFilters

Set Amount Filter
    [Arguments]    ${amount}
    Click    selector=id=filters
    Fill Text    selector=id=amount    txt=${amount}
    Click    selector=id=closeFilters

Change Settings
    Click    selector=id=themeDark
    Click    selector=id=settings
    Click    selector=id=toggleLegends
    Click    selector=id=toggleAxisTitles
    Click    selector=id=toggleLabels
    Select Options By    id=toggleBarRounding    value    0
    Click    selector=id=closeSettings

(Un)select Checkbox
    [Arguments]    ${selector}    ${check}=True
    ${element}    Get Element    selector=${selector}
    ${state}    Get Property    selector=${element}    property=checked
    ${checked}    Evaluate    "${state}" in ['true', 'True']
    Run Keyword If    (${check} and not ${checked}) or (not ${check} and ${checked})   Click  ${element}

Add Filter Profile For
    [Arguments]    @{selected_filters}    ${profile_name}
    Click    selector=id=filters
    Click    selector=id=addFilterProfile
    Fill Text    selector=id=filterProfileName    txt=${profile_name}
    @{filters}    Create List    Runs    RunTags    Versions    FromDate    FromTime    ToDate    ToTime    Amount
    FOR    ${filter}    IN    @{filters}
        ${check}    Evaluate    '${filter}' in @{selected_filters}
        (Un)select Checkbox    selector=id=profileCheck${filter}    check=${check}
    END
    Click    selector=id=saveFilterProfile
    Click    selector=id=closeFilters

Apply Filter Profile
    [Arguments]    ${profile_name}
    Click    selector=id=filters
    Click    selector=id=selectFilterProfile
    Click    selector=xpath=//ul[@id="filterProfileList"]/li/span[contains(text(),'${profile_name}')]
    Click    selector=id=closeFilters

Get Filter Profile Settings
    [Arguments]    ${profile_name}
    ${settings_str}    LocalStorage Get Item    key=settings
    ${settings}    Loads    ${settings_str}
    VAR    ${filter_profile}     ${settings}[filterProfiles][${profile_name}]
    RETURN    ${filter_profile}

Reset Filters
    Click    selector=id=filters
    Click    selector=id=resetFilters
    Click    selector=id=closeFilters
