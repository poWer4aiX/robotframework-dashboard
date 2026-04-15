*** Settings ***
Documentation    This testsuite covers the generated HTML dashboard of robotdashboard
...              And specifically the overview page

Resource    ../resources/keywords/dashboard-keywords.resource
Resource    ../resources/keywords/general-keywords.resource

Suite Setup    Start Browser
Suite Teardown    Stop Browser
Test Setup    Run Keywords    Generate Dashboard    Open Dashboard
Test Teardown    Run Keywords    Close Dashboard    Remove Database And Dashboard With Index


*** Test Cases ***
Validate Latest Runs
    Open Overview Page
    Validate Component    id=overviewLatestRunsSection    name=baseView    folder=overview

Validate Latest Runs Use Run Tags
    Open Overview Page
    Click    selector=id=settings
    Click    selector=id=overview-tab
    Click    selector=id=switchRunTags
    Click    selector=id=closeSettings
    Validate Component    id=overviewLatestRunsSection    name=runTags    folder=overview

Validate Total Statistics
    Open Overview Page
    Click    selector=id=collapsegridOverviewTotal
    Validate Component    id=overviewTotalStatsSection    name=totalStatistics    folder=overview

Validate Total Statistics Use Run Tags
    Open Overview Page
    Click    selector=id=settings
    Click    selector=id=overview-tab
    Click    selector=id=switchRunTags
    Click    selector=id=closeSettings
    Click    selector=id=collapsegridOverviewTotal
    Validate Component    id=overviewTotalStatsSection    name=totalStatisticsRunTags    folder=overview

Validate Tests
    Open Overview Page
    Click    selector=id=collapseTestsBody
    Validate Component    id=TestsSection    name=tests    folder=overview

Validate Tests With Version Filter
    Open Overview Page
    Click    selector=id=collapseTestsBody
    Fill Text    selector=id=TestsVersionFilterSearch    txt=1.1
    Validate Component    id=TestsSection    name=testsVersion1_1    folder=overview

Validate Testsuites
    Open Overview Page
    Click    selector=id=collapseTestsuitesBody
    Validate Component    id=TestsuitesSection    name=testsuites    folder=overview

Validate Testsuites With Version Filter
    Open Overview Page
    Click    selector=id=collapseTestsuitesBody
    Fill Text    selector=id=TestsuitesVersionFilterSearch    txt=1.1
    Validate Component    id=TestsuitesSection    name=testsuitesVersion1_1    folder=overview
