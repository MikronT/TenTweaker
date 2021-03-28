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
  - Desktop (This PC object, logon background blur etc.)
  - Taskbar (People band, small icons etc.)
  - Explorer (file extensions, navbar entries etc.)
  - Input (key sequences, suggestions, and auto completion)
- Programs management
  - System programs (AppX packages)
  - Microsoft Office Professional+ 2016
  - Group Policy Editor (gpedit.msc) for Windows 10 Home
- Services control
  - Windows Update (disable until you desire to enable it again)
  - Software Protection Platform Service (service restoring after some activators work)
- Tools
  - Windows Administrative Tools (Registry tools, Desktop icons)
  - System Resource Checker (can help fix some problems without full system restore)



## Localization
Available languages:
- English
- Portuguese
- Russian
- Ukrainian

### Translations
You can also help me with localizing program to your language.
Special thanks to these amazing people:
- Portuguese - Batch Satti (amazing man who also helped with many interface improvements)



## Keys
| Key Name      | Options | Description                                                                |
|---------------|---------|----------------------------------------------------------------------------|
| admin         |         | skips admin rights checking (can cause problems)                           |
| hiddenOptions |         | enables hidden options for administrative tools menu (at your own risk)    |
| reboot        | sppsvc  | shows reboot dialog, used for sppsvc service restoring (inner program key) |
| skipRegMerge  |         | skips registry parameters merge (not recommended)                          |

### How to run Ten Tweaker with specified keys?
Run Command Prompt as admin and enter the command like this:

```
"[path\]tenTweaker.cmd" /key [option]...

Example: "C:\Users\Admin\Desktop\TenTweaker\tenTweaker.cmd" /admin /hiddenOptions
```

| Syntax mark | Description                                          |
|-------------|------------------------------------------------------|
| path        | Path to the tenTweaker.cmd file (optional)           |
| key         | Key name from the first table                        |
| option      | Option from the first table (optional, key depended) |

Note: You can combine the keys as you wish.



## Disclaimer
- I am not responsible for any *damage you can make to your computer*.



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