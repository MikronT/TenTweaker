# Ten Tweaker

[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-red.svg?style=for-the-badge)](#)
[![Latest Release](https://img.shields.io/badge/Latest-Release-blue.svg?style=for-the-badge)](https://github.com/MikronT/TenTweaker/releases/latest)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-black.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0)

<!--
[![Status: Pre-Alpha](https://img.shields.io/badge/Status-Pre--Alpha-black.svg?style=for-the-badge)](#)
[![Status: Alpha](https://img.shields.io/badge/Status-Alpha-red.svg?style=for-the-badge)](#)
[![Status: Beta](https://img.shields.io/badge/Status-Beta-orange.svg?style=for-the-badge)](#)
[![Status: Pre-Release](https://img.shields.io/badge/Status-Pre--Release-yellow.svg?style=for-the-badge)](#)
-->

### Current version: 3.0 Alpha 1

Console tweaker for Windows 10 with some useful options.

*Developed for Windows 10*



## Features
- Interface configuration
  - Desktop (This PC, Recycle Bin etc.)
  - Task Bar (People band, small icons etc.)
  - Explorer (file extensions, hidden files etc.)
  - Input (key sequences, suggestions and auto completion)
- Programs management
  - System programs
  - Microsoft Office Professional Plus 2016
  - Group Policy Editor (gpedit.msc) for Windows 10 Home
- Services control
  - Windows Update (wuaserv)
  - Software Protection Platform Service (sppsvc)
- Tools
  - Windows Administrative Tools
  - System Resource Checker



## Localization
Available languages:
- English
- Portuguese
- Russian
- Ukrainian

### Translations
You can also help me with localization to your language.
Special thanks to these amazing people:
- Portuguese - Batch Satti (amazing man who also helped with many interface improvements)



## Keys
| Key Name                                | Options         | Description                                                                  |
|-----------------------------------------|-----------------|------------------------------------------------------------------------------|
| main_adminRightsChecking                | false           | skips admin rights checking                                                  |
| main_reboot                             | services_sppsvc | shows reboot dialog, but specifically this option used for restore sppsvc    |
| main_registryMerge                      | false           | skips registry parameters merge (not recommended)                            |
| tools_administrativeTools_hiddenOptions | true            | enables hidden options for administrative tools menu (can kill your Windows) |

### How to run Ten Tweaker with specified keys?
Run Command Prompt as admin and enter the command like this:

```
"[Path]\tenTweaker.cmd" --[KeyName]=[Options] --[KeyName2]=[Options] ...

"C:\Users\Admin\Desktop\TenTweaker\tenTweaker.cmd" --main_eula=false --tools_administrativeTools_hiddenOptions=enabled
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
- I am not responsible for any *lost data*.



## Version History
| Date       | Version      |
|------------|--------------|
| 27.03.2021 | v3.0 Alpha 1 |
| 04.06.2019 | Release v2.2 |
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