# Ten Tweaker

[![Status: Release](https://img.shields.io/badge/Status-Release-green.svg?style=for-the-badge)](#)
[![Latest Release](https://img.shields.io/badge/Latest-Release-blue.svg?style=for-the-badge)](https://github.com/MikronT/TenTweaker/releases/latest)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-black.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0)

<!--
[![Status: Beta](https://img.shields.io/badge/Status-Beta-orange.svg?style=for-the-badge)](#)
[![Status: Pre-Release](https://img.shields.io/badge/Status-Pre--Release-yellow.svg?style=for-the-badge)](#)
-->

### Version name: *Release v2.1*

Console tweaker for Windows 10 with some useful options.

*Developed for Windows 10 but, in theory, can work on Windows 7, 8 and 8.1 too.*



## Features
- Interface Config
  - Desktop objects (This PC, Recycle Bin etc.)
  - Language key sequence
  - Input suggestions and auto completion
  - Windows Explorer (file extensions, hidden files etc.)
  - Windows Task Bar
- Programs
  - System programs
  - Microsoft Office Professional Plus 2016
  - Group Policy Editor (gpedit.msc) for Windows 10 Home
- Services Management
  - Windows Update (wuaserv)
  - Software Protection Platform Service (sppsvc)
- Tools
  - Windows Administrative Tools
  - System Resource Checker



## Localization
Available languages:
- English
- Russian
- Ukrainian

### Translations
You can also help me with localization to your language.



## Keys
| Key Name                                | Options         | Description                                                                  |
|-----------------------------------------|-----------------|------------------------------------------------------------------------------|
| main_eula                               | hidden          | hides eula start message                                                     |
| main_adminRightsChecking                | false           | skips admin rights checking                                                  |
| main_reboot                             | services_sppsvc | shows reboot dialog, but specifically this option used for restore sppsvc    |
| tools_administrativeTools_hiddenOptions | enabled         | enables hidden options for administrative tools menu (can kill your Windows) |
| main_registryMerge                      | false           | skips registry parameters merge (not recommended)                            |

### How to run Ten Tweaker with specified keys?
Run Command Prompt as admin and enter the command like this:

```
"[Path]\tenTweaker.cmd" --[KeyName]=[Options] --[KeyName2]=[Options] ...

"C:\Users\Admin\Desktop\TenTweaker\tenTweaker.cmd" --key_main_eula=hidden --key_tools_administrativeTools_hiddenOptions=enabled
```

| Syntax marking | Description                     |
|----------------|---------------------------------|
| Path           | Path to the tenTweaker.cmd file |
| KeyName        | Key name from the first table   |
| Options        | Options from the first table    |
| ...            | Other keys and options          |

Note: you can combine the keys as you wish.



## Disclaimer
- I am not responsible for any *damage to your computer*.
- I am not responsible for any *lost files or data*.



## Version History
| Date       | Version      |
|------------|--------------|
| 27.04.2019 | Release v2.1 |
| 03.04.2019 | Release v2.0 |
| 29.03.2019 | Release v1.2 |
| 28.03.2019 | Release v1.1 |
| 15.03.2019 | Release v1.0 |
| 06.03.2019 | Beta v0.97   |
| 09.02.2019 | Beta v0.96   |
| 09.02.2019 | Beta v0.95   |
| 09.02.2019 | Beta v0.94   |
| 05.02.2019 | Beta v0.92   |
| 03.02.2019 | Beta v0.907  |
| 03.02.2019 | Beta v0.9    |
| 25.05.2019 | Beta         |