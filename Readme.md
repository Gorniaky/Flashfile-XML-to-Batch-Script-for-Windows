# Flashfile-XML-to-Batch-Script-for-Windows

This script converts the file flashfile.xml to flashfile.bat with and without MD5 hash checking.
In addition to making a copy of the commands in a text file.

By default this will run MD5 check,
but you can run without MD5 check by running flashfile_no_md5check.bat file after converting to BAT.

This script does not need the USB drivers from your device manufacturer,
but after conversion these drivers will be needed.

| Files | SHA1 | Virustotal |
| --- | --- | --- |
| aapt.exe | e739c80424a973dded8ae7d58ae260c861ab0882 | 0/69 2021-08-04 19:58:29 UTC |
| adb.exe | 6bd017aa930412878327f8ec5b4774f7e04fbb42 | 0/68 2021-08-10 13:11:05 UTC |
| AdbWinApi.exe | fde9c22a2cfcd5e566cec2e987d942b78a4eeae8 | 0/66 2021-09-04 06:18:33 UTC |
| AdbWinUsbApi.exe | 12e14244b1a5d04a261759547c3d930547f52fa3 | 0/65 2021-09-04 06:18:33 UTC |
| linux-fastboot | 4ae92136d5d42bc1d5165b573c66acbc2f3ec145 | 0/60 2021-05-26 07:00:25 UTC |
| mfastboot.exe | 702397514ce29b402b61c2e1c3160c47e4834544 | 1/65 2021-09-06 02:56:54 UTC |
| osx-fastboot | a011777b2f1d27222290d7b41dddd914b1139af8 | 0/60 2018-06-20 01:33:01 UTC |

- File sources:

aapt.exe, adb.exe, AdbWinApi.exe, AdbWinUsbApi.exe, linux-fastboot, mfastboot.exe & osx-fastboot extracted from [mfastboot-v2.zip](https://forum.xda-developers.com/t/using-mfastboot-exe-to-flash-a-motorola-device.3203518)

## Credits

This is a modification of the [Motorola-XML-To-Batch-Script](https://github.com/rootjunky/Motorola-XML-To-Batch-Script) project by Rootjunky
