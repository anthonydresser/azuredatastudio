:: Runs Extension tests

setlocal

pushd %~dp0\..

set VSCODEUSERDATADIR=%TMP%\adsuser-%RANDOM%-%TIME:~6,5%
set VSCODEEXTENSIONSDIR=%TMP%\adsext-%RANDOM%-%TIME:~6,5%
echo %VSCODEUSERDATADIR%
echo %VSCODEEXTENSIONSDIR%

:: Figure out which Electron to use for running tests
if "%INTEGRATION_TEST_ELECTRON_PATH%"=="" (
	:: Run out of sources: no need to compile as code.sh takes care of it
	set INTEGRATION_TEST_ELECTRON_PATH=.\scripts\code.bat

	echo "Running integration tests out of sources."
) else (
	:: Run from a built: need to compile all test extensions
	call yarn gulp compile-extension:admin-tool-ext-win
	call yarn gulp compile-extension:agent
	call yarn gulp compile-extension:azurecore
	call yarn gulp compile-extension:cms
	call yarn gulp compile-extension:dacpac
	call yarn gulp compile-extension:schema-compare
	call yarn gulp compile-extension:notebook
	call yarn gulp compile-extension:resource-deployment

	echo "Running integration tests with '%INTEGRATION_TEST_ELECTRON_PATH%' as build."
)

:: Default to only running stable tests if test grep isn't set
if "%ADS_TEST_GREP%" == "" (
	echo Running stable tests only
	set ADS_TEST_GREP=@UNSTABLE@
	SET ADS_TEST_INVERT_GREP=1
)

@echo OFF

echo ***************************************************
echo *** starting admin tool extension windows tests ***
echo ***************************************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\admin-tool-ext-win --extensionTestsPath=%~dp0\..\extensions\admin-tool-ext-win\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --disableExtensions --remote-debugging-port=9222

echo ****************************
echo *** starting agent tests ***
echo ****************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\agent --extensionTestsPath=%~dp0\..\extensions\agent\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo ********************************
echo *** starting azurecore tests ***
echo ********************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\azurecore --extensionTestsPath=%~dp0\..\extensions\azurecore\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo **************************
echo *** starting cms tests ***
echo **************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\cms --extensionTestsPath=%~dp0\..\extensions\cms\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo *****************************
echo *** starting dacpac tests ***
echo *****************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\dacpac --extensionTestsPath=%~dp0\..\extensions\dacpac\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo *************************************
echo *** starting schema compare tests ***
echo *************************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\schema-compare --extensionTestsPath=%~dp0\..\extensions\schema-compare\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo *******************************
echo *** starting notebook tests ***
echo *******************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\notebook --extensionTestsPath=%~dp0\..\extensions\notebook\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo ******************************************
echo *** starting resource deployment tests ***
echo ******************************************
call "%INTEGRATION_TEST_ELECTRON_PATH%" --nogpu --extensionDevelopmentPath=%~dp0\..\extensions\resource-deployment --extensionTestsPath=%~dp0\..\extensions\resource-deployment\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

echo *******************************
echo *** starting machine-learning-services tests ***
echo *******************************
call .\scripts\code.bat --extensionDevelopmentPath=%~dp0\..\extensions\machine-learning-services --extensionTestsPath=%~dp0\..\extensions\machine-learning-services\out\test --user-data-dir=%VSCODEUSERDATADIR% --extensions-dir=%VSCODEEXTENSIONSDIR% --remote-debugging-port=9222

if %errorlevel% neq 0 exit /b %errorlevel%

rmdir /s /q %VSCODEUSERDATADIR%
rmdir /s /q %VSCODEEXTENSIONSDIR%

popd

endlocal
