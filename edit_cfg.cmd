:rem Arguments: perl.dll-dir, perllib-dir[f:/perllib], perl.exe-dir
cd
@echo on
set BEGINLIBPATH=%1
set PERLLIB_PREFIX=i:/perllib/lib;%2
:rem Sanity checks
%3\perl.exe -e 0
if errorlevel 1 goto err1
goto try2
err1
echo .
echo A simplest perl invocation [%3\perl.exe -e 0] failed
:err_common
echo .
echo Do you have a correct version of EMX DLLs installed?  Check by running
echo emxrev
echo You can try to find old misplaced EMX DLLs by running
echo emxrev -p <BOOT_DRIVE>:/config.sys
echo .
echo We set env: BEGINLIBPATH=%1
echo We set env: PERLLIB_PREFIX=i:/perllib/lib;%2
pause
exit
:try2
%3\perl.exe -e "exit 23"
if errorlevel 24 goto err2
if errorlevel 23 goto full
echo .
echo A simple perl invocation [%3\perl.exe -e "exit 23"] returned success?!
goto err_common
err2
echo .
echo Perl invocation [%3\perl.exe -e "exit 23"] returned a wrong error code?!
goto err_common
:err_full
echo .
echo Errors during editing Config.pm detected.
echo Later you may want to rerun %3\perl.exe %2\edit_cfg.pl %2
goto err_common
:full

:rem THIS IS THE ACTUAL WORKHORSE
%3\perl.exe %2\edit_cfg.pl %2

if errorlevel 1 goto err_full
