@echo off&goto:start

============================================================
 Readme
============================================================

 This script converts the file flashfile.xml to flashfile.bat with and without MD5 hash checking.
 In addition to making a copy of the commands in a text file.

 By default this will run MD5 check,
 but you can run without MD5 check by running flashfile_no_md5check.bat file after converting to BAT.

 This script does not need the USB drivers from your device manufacturer,
 but after conversion these drivers will be needed.

============================================================

 - File details:

 aapt.exe         SHA1 e739c80424a973dded8ae7d58ae260c861ab0882 Virustotal 0/69 2021-08-04 19:58:29 UTC
 adb.exe          SHA1 6bd017aa930412878327f8ec5b4774f7e04fbb42 Virustotal 0/68 2021-08-10 13:11:05 UTC
 AdbWinApi.exe    SHA1 fde9c22a2cfcd5e566cec2e987d942b78a4eeae8 Virustotal 0/66 2021-09-04 06:18:33 UTC
 AdbWinUsbApi.exe SHA1 12e14244b1a5d04a261759547c3d930547f52fa3 Virustotal 0/65 2021-09-04 06:18:33 UTC
 linux-fastboot   SHA1 4ae92136d5d42bc1d5165b573c66acbc2f3ec145 Virustotal 0/60 2021-05-26 07:00:25 UTC
 mfastboot.exe    SHA1 702397514ce29b402b61c2e1c3160c47e4834544 Virustotal 1/65 2021-09-06 02:56:54 UTC
 osx-fastboot     SHA1 a011777b2f1d27222290d7b41dddd914b1139af8 Virustotal 0/60 2018-06-20 01:33:01 UTC

 - File sources:

 aapt.exe, adb.exe, AdbWinApi.exe, AdbWinUsbApi.exe, linux-fastboot, mfastboot.exe & osx-fastboot
 extracted from mfastboot-v2.zip
 https://forum.xda-developers.com/t/using-mfastboot-exe-to-flash-a-motorola-device.3203518/

============================================================
 Credits
============================================================

 This is a modification of the Motorola-XML-To-Batch-Script project by Rootjunky
 https://github.com/rootjunky/Motorola-XML-To-Batch-Script

============================================================

:start
set "nul=>nul 2>nul"
if exist "%1" (call:xmlcheck "%1")
if not defined flashfilexml (for %%a in (*.xml) do call:xmlcheck %%a)
if exist "%flashfilexml%" (call:startconvert) else (find "" flashfile.xml&goto:halt)
pause
flashfile.bat

:halt
%nul% timeout 5
exit

:xmlcheck
set xmlcheck=
%nul% findstr "step" "%1"&&set /a xmlcheck+=1
%nul% findstr "operation" "%1"&&set /a xmlcheck+=1
%nul% findstr "partition" "%1"&&set /a xmlcheck+=1
%nul% findstr "filename" "%1"&&set /a xmlcheck+=1
%nul% findstr "MD5" "%1"&&set /a xmlcheck+=1
if %xmlcheck%==5 (set flashfilexml=%1) else (echo This file is not an flashfile xml.&&goto:halt)
exit/b

:forflash
for /f delims^=^"^ tokens^=%1 %%a in (flash.txt) do call:findvar %%a %2&exit/b

:findvar
echo %1|%nul% findstr operation&&set op=%2
echo %1|%nul% findstr partition&&set pa=%2
echo %1|%nul% findstr filename&&set fi=%2
echo %1|%nul% findstr MD5&&set md5=%2
exit/b

:startconvert
for /f delims^=^"^ tokens^=^2 %%a in ('findstr "\<software_version\>" "%flashfilexml%"') do set title=%%a
title %title%

(echo @title %title%)>"flashfile.bat"

(echo @title %title%)>"flashfile_no_md5check.bat"

findstr "\<flash\>" "%flashfilexml%">flash.txt

call:forflash 1 2
call:forflash 3 4
call:forflash 5 6
call:forflash 7 8

if %fi% LSS %md5% (set "fa1=%%a"&set "fa2=%%b") else (set "fa1=%%b"&set "fa2=%%a")
for /f delims^=^"^ tokens^=%fi%^,%md5% %%a in (flash.txt) do echo @if exist %fa1% ^(set ^/a ef+=^1^&call:md5check %fa1% %fa2%^) else ^(set ^/a nef+=^1^&find ^"^" %fa1%^)>>flashfile.bat
for /f delims^=^"^ tokens^=%fi%^,%md5% %%a in (flash.txt) do echo @if exist %fa1% ^(set ^/a ef+=^1^) else ^(set ^/a nef+=^1^&find ^"^" %fa1%^)>>flashfile_no_md5check.bat

(echo @set /a tf=%%nef%%+%%ef%%
echo @if defined nef echo %%nef%% files out of %%tf%% are missing.^&pause)>>flashfile.bat

(echo @if not exist mfastboot.exe ^(find "" mfastboot.exe^&^>nul timeout 5^&exit^)
echo @echo off)>>flashfile.bat

%nul% findstr "operation..getvar" %flashfilexml%&&echo mfastboot getvar max-sparse-size^|^|set ^/a flasherrors+=^1>>flashfile.bat
%nul% findstr "operation..oem" %flashfilexml%&&echo mfastboot oem fb_mode_set^|^|set ^/a flasherrors+=^1>>flashfile.bat

if %op% LSS %fi% (set "fa3=%%a"&set "fa4=%%b"&set "fa5=%%c") else (set "fa3=%%b"&set "fa4=%%c"&set "fa5=%%a")
for /f delims^=^"^ tokens^=%op%^,%pa%^,%fi% %%a in (flash.txt) do echo mfastboot %fa3% %fa4% %fa5%^|^|set ^/a flasherrors+=^1>>flashfile.bat
del flash.txt

for /f delims^=^"^ tokens^=2^,4 %%a in ('findstr "\<erase\>" "%flashfilexml%"^|findstr /v "modem"') do echo mfastboot %%a %%b^|^|set ^/a flasherrors+=^1>>flashfile.bat

%nul% findstr "operation..oem" %flashfilexml%&&echo mfastboot oem fb_mode_clear^|^|set ^/a flasherrors+=^1>>flashfile.bat

(echo mfastboot reboot
echo @if defined flasherrors ^(@echo Done with %%flasherrors%% errors^) else ^(@echo Done without errors.^)
echo @cmd)>>flashfile.bat

findstr /v /c:"@if exist" flashfile.bat|findstr /v /c:"@title">>"flashfile_no_md5check.bat"

(echo @:md5check
echo @certutil -hashfile %%1 MD5^|findstr %%2^>nul^&^&echo MD5 %%1 %%2^|^|echo MD5 from %%1 file does not match
echo @exit^/b)>>flashfile.bat

if exist "FLASHFILE COMMANDS %title%.txt" del "FLASHFILE COMMANDS %title%.txt"
for /f delims^=^|^ tokens^=1 %%a in ('findstr /v "@" "flashfile.bat"') do echo %%a>>"FLASHFILE COMMANDS %title%.txt"
exit/b