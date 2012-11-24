@echo off
REM Written by Chris Price (xCP23x), 2010-2012
REM LICENSE: Do what you want with this, as long as you a) Don't make any profit from it, monetary or otherwise (NO adf.ly links or similar) and b) Give credit where credit is due - don't remove or edit this message, and link to https://github.com/xCP23x/MCLauncher/blob/master/Minecraft.cmd, where it is hosted.
REM Just to confirm: You CAN edit and redistribute this, just make sure to stick to the above license.

:start
REM Do some inital checks to ensure everything is where it should be.
if not exist %appdata%\.minecraft\bin goto nobin
cd %appdata%\.minecraft\bin
if not exist minecraft.exe goto noexe
if not exist new\ mkdir %appdata%\.minecraft\bin\new\
if not exist versions\ mkdir %appdata%\.minecraft\bin\versions\
if not exist archive\ mkdir %appdata%\.minecraft\bin\archive\
echo          Welcome to the Minecraft Launcher Launcher!
echo --------------------------------------------------------------
echo.
if exist %appdata%\.minecraft\bin\new\*.jar goto new

:skipchecks
REM Start from after the initial checks, for whatever reason
cd %appdata%\.minecraft\bin\versions
cls
echo          Welcome to the Minecraft Launcher Launcher!
echo --------------------------------------------------------------
echo.
echo The available versions are:
echo.
dir /b
echo.
echo Enter the version of Minecraft you would like to play, or type menu for more options and help.
echo.
echo Press enter to run the previously used version
echo.
set version=current
set /p version=
echo.
if %version%==current goto current
if %version%==exit exit
if %version%==menu goto menu
if exist %version% goto copy
goto versionerror

:menu
REM Show the main menu
cls
echo Main menu - choose an option:
echo.
echo add     - Add the current version of MC to the list
echo archive - Access the archive, used to clean up the main list
echo delete  - Delete a version
echo help    - Get help on adding other versions of MC to the list
echo return  - Return to the version select screen
echo.
set menu=none
set /p menu=
echo.
if %menu%==add goto add
if %menu%==archive goto archive
if %menu%==delete goto delete
if %menu%==help goto help
if %menu%==return goto start
goto cmderror

:archive
REM Prompt the user for options to do with the archive
cls
cd %appdata%\.minecraft\bin\archive
echo The currently archived versions are:
echo.
dir /b
echo.
echo The archive stores versions of minecraft so that the list doesn't get too cluttered.
echo You can move them between the main list and the archive from here.
echo.
echo Choose an option:
echo archive - Move a version to the archive
echo list    - Move an archived version back to the main list
echo delete  - Delete a version from the archive
echo return  - Return to the menu screen
echo.
set archive=none
set /p archive=
echo.
if %archive%==archive goto movetoarchive
if %archive%==list goto movetolist
if %archive%==delete goto deletefromarchive
if %archive%==return goto menu
goto cmderror

:movetoarchive
REM Move the selected version to the archive
cls
cd %appdata%\.minecraft\bin\versions
echo The available versions are:
echo.
dir /b
echo.
echo Enter the version of Minecraft to archive, or type cancel:
echo.
set version=none
set /p version=
echo.
if %version%==cancel goto archive
cd %appdata%\.minecraft\bin\
if not exist versions\%version% goto versionerror
move versions\%version% archive\%version%
goto archive

:movetolist
REM Move the selected version to the list
echo Enter the version of Minecraft to move back to the list, or type cancel:
echo.
set version=none
set /p version=
echo.
if %version%==cancel goto archive
cd %appdata%\.minecraft\bin\
if not exist archive\%version% goto versionerror
move archive\%version% versions\%version%
goto archive

:deletefromarchive
REM Prompts the user to delete a version of Minecraft
cd %appdata%\.minecraft\bin\archive
echo Please type the name of the version you wish to delete from the archive
echo Type cancel to go back
set delete=none
set /p delete=
cls
if %delete%==cancel goto archive
if not exist %delete% goto versionerror
echo.
echo Really delete %delete%? (yes/no)
echo.
set really=no
set /p really=
echo.
If %really%==yes del %delete%
goto archive

:copy
REM Copies the version chosen over minecraft.jar
cd %appdata%\.minecraft\bin\
del minecraft.jar
copy versions\%version% minecraft.jar
if exist minecraft.jar goto play
goto error

:play
REM Launches Minecraft
cls
echo Starting Minecraft Launcher...
minecraft.exe
exit

:add
REM Prompts the user to add the current version to the list
cls
cd %appdata%\.minecraft\bin\
echo Please type a name for the new file (eg 1.7)
echo To go back, type cancel.
echo.
set /p name=
if %name%==cancel goto start
if exist versions\%name% goto nameerror
copy minecraft.jar versions\%name%
goto start

:new
REM Prompts the user to add newly found versions to the list
cd %appdata%\.minecraft\bin\new\
echo New Version(s) Found:
echo.
dir /b
cd %appdata%\.minecraft\bin
echo.
echo Please type the full name of the version you wish to add
echo Type cancel to do this later, or type clear to empty the list.
echo.
set /p new=
if %new%==cancel goto skipchecks
if %new%==clear goto clear
if not exist new\%new% goto nameerror
echo.
echo Please type a name for the new file (eg 1.7)
echo.
set /p name=
if exist versions\%name% goto nameerror
copy new\%new% versions\%name%
del new\%new%
goto start

:clear
REM Clears the "new" folder
cd %appdata%\.minecraft\bin
rd /S /Q new
if exist new goto error
mkdir new
goto start

:delete
REM Prompts the user to delete a version of Minecraft
cls
cd %appdata%\.minecraft\bin\versions
echo Please type the name of the version you wish to delete.
echo Type cancel to go back
echo.
dir /b
echo.
set /p delete=
cls
if %delete%==cancel goto start
if not exist %delete% goto versionerror
echo.
echo Really delete %delete%? (yes/no)
echo.
set /p really=
echo.
If %really%==yes del %delete%
goto start

:current
REM Starts the current version of minecraft
cd %appdata%\.minecraft\bin
cls
echo Starting Minecraft Launcher...
minecraft.exe
exit

:error
REM Generic error
cls
echo An error occurred. Please try again.
echo Ensure you entered the command (if any) correctly.
echo If the error persists, try running as administrator.
pause
goto start

:nameerror
REM error with newly entered name
cls
echo There was a problem with the name you entered.
echo Please try another.
pause
goto start

:versionerror
REM Error with the version chosen
cls
echo The version you entered could not be found.
pause
goto start

:cmderror
REM Error with the command entered
cls
echo The command you entered was invalid.
echo Please try again.
pause
goto start

:help
REM Lists the help
cls
echo To add a version of minecraft not currently in use:
echo.
echo 1. Navigate to %appdata%\.minecraft\bin\new
echo 2. Add any versions of minecraft.jar (name not important)
echo 3. Press any key, you will be prompted to give them names
echo 4. ???
echo 5. Profit
echo.
echo An explorer window has been opened at this location to help you!
echo.
explorer %appdata%\.minecraft\bin\new
pause
goto start

:nobin
REM No .minecraft/bin folder found
cls
echo ERROR: No Minecraft installation folder was found!
echo.
echo Run minecraft once and log in, then run this script again.
echo.
pause
exit

:noexe
echo          Welcome to the Minecraft Launcher Launcher!
echo --------------------------------------------------------------
echo.
echo Before you use this, you need to put a minecraft launcher in:
echo %appdata%\.minecraft\bin\
echo.
echo This folder has been opened in explorer.
echo Put the launcher in there, and make sure it's named Minecraft.exe
echo.
echo You can get the launcher from:
echo https://s3.amazonaws.com/MinecraftDownload/launcher/Minecraft.exe
echo.
explorer %appdata%\.minecraft\bin\
pause
goto start