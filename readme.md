# Ten Tweaker

[![Status: Beta](https://img.shields.io/badge/Status-Beta-yellow.svg?style=for-the-badge)](#)

<!--
[![Status: Release](https://img.shields.io/badge/Status-Release-green.svg?style=for-the-badge)](#)
-->

### Version name: *Beta v0.96*

Console tweaker for Windows 10 with some useful options.



## Features
- Interface
  - add or remove desktop objects (This PC, Recycle Bin etc.)
  - configure language key sequence
  - configure input suggestions and auto completion
  - configure Windows Explorer (file extensions, hidden files etc.)
  - configure Windows Task Bar
- Setup
  - setup Microsoft Office Professional Plus 2016
  - setup/restore Group Policy Editor (gpedit.msc) for Windows 10 Home
- Services
  - manage Windows Update (wuaserv)
  - restore Software Protection Platform Service (sppsvc)
- Tools
  - manage Windows Administrative Tools



## Keys
| Key Name                                | Options         | Description                                                                  |
|-----------------------------------------|-----------------|------------------------------------------------------------------------------|
| main_registryMergeCompleted             | true            | to skip registry parameters merge (not recommended)                          |
| main_eula                               | hidden          | hides eula start message                                                     |
| main_reboot                             | services_sppsvc | shows reboot dialog, but specifically this option used for restore sppsvc    |
| tools_administrativeTools_hiddenOptions | enabled         | enables hidden options for administrative tools menu (can kill your Windows) |

### How to run Ten Tweaker with specified keys?
Run Command Prompt as admin and enter the command like this:

```
"[Path]\tenTweaker.cmd" --key_[KeyName]=[Options] --key_[KeyName2]=[Options] ...

"C:\Users\Admin\Desktop\TenTweaker\tenTweaker.cmd" --key_main_eula=hidden --key_tools_administrativeTools_hiddenOptions=enabled
```

| Syntax marking | Description                     |
|----------------|---------------------------------|
| Path           | Path to the tenTweaker.cmd file |
| KeyName        | Key name from the first table   |
| Options        | Options from the first table    |
| ...            | Other keys and options          |

Note: you can combine the keys as you wish.



## Version History
| Date       | Version      |
|------------|--------------|
| 09.02.2019 | Beta v0.96   |
| 09.02.2019 | Beta v0.95   |
| 09.02.2019 | Beta v0.94   |
| 05.02.2019 | Beta v0.92   |
| 03.02.2019 | Beta v0.907  |
| 03.02.2019 | Beta v0.9    |
| 25.05.2019 | Beta         |

<!--
| 08.02.2019 | Release v1.0 |
-->