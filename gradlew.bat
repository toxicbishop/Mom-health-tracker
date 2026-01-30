@echo off
setlocal

set DIR=%~dp0

set GRADLE_WRAPPER_PROPERTIES=%DIR%gradle\wrapper\gradle-wrapper.properties

if exist "%GRADLE_WRAPPER_PROPERTIES%" (
    for /f "tokens=2 delims==" %%A in ('findstr distributionUrl "%GRADLE_WRAPPER_PROPERTIES%"') do set GRADLE_URL=%%A
    set GRADLE_URL=%GRADLE_URL:https\://=https://%
    set GRADLE_ZIP=%DIR%gradle-wrapper.zip
    powershell -Command "Invoke-WebRequest -Uri %GRADLE_URL% -OutFile '%GRADLE_ZIP%'"
    powershell -Command "Expand-Archive -Path '%GRADLE_ZIP%' -DestinationPath '%DIR%gradle-wrapper' -Force"
    set GRADLE_EXE=%DIR%gradle-wrapper\gradle-%GRADLE_URL:*-=%\bin\gradle.bat
    if exist "%GRADLE_EXE%" (
        call "%GRADLE_EXE%" %*
    ) else (
        echo Gradle executable not found after extraction.
        exit /b 1
    )
) else (
    echo gradle-wrapper.properties not found.
    exit /b 1
)
