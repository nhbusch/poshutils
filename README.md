poshutils
=========

Collection of PowerShell modules, utilities and config files.

These PowerShell commands include tools for programming in VisualStudio(R),
Git source code management, signing code and various system utilities.

They make use of the following external PowerShell modules:

* [Pester](https://github.com/pester/Pester)
* [PsReadline](https://github.com/lzybkr/PSReadLine) (part of PowerShell 5.0)
* [posh-git](https://github.com/dahlbyk/posh-git)
* [PSColor](https://github.com/Davlind/PSColor)
* [VSSetup](https://github.com/Microsoft/vssetup.powershell)
* [z](https://github.com/vincpa/z)

which may be retrieved from the [PowerShellGallery](https://www.powershellgallery.com/).

Installation
------------

### Prerequisites

* PowerShell 3.0 or later
* [Git for Windows](https://git-scm.com/download/win)

### Automatic installation

To automatically install the content of this repository along with its dependencies,
enter in a PowerShell shell

```powershell
git clone https://github.com/nhbusch/poshutils.git path/to/repo
cd path/to/repo
.\Install
```

which clones this repository, changes to the installation directory, and runs the
install script. The install script will also create a link from the PowerShell
user directory - usually `$env:USERPROFILE\Documents\WindowsPowerShell` - to the
above installation directory.

### Manual installation

Install external modules

Installing external modules requires PowerShellGet, which is part of PowerShell
5.0 or later (distributed with Windows 10 or
[Windows Management Framework 5.0)](http://go.microsoft.com/fwlink/?LinkId=398175).
If you are on PowerShell 4.0 or earlier, you need to install
[PowerShellGet](https://www.microsoft.com/en-us/download/details.aspx?id=49186) instead.

Either clone the repository during first time installation

```
  git clone https://github.com/nhbusch/poshutils.git path/to/repo
```

or update it with

```
  git pull
```

Then, create a link from the PowerShell user directory to the installation directory

```powershell
  cmd /c mklink /j (Split-Path $PROFILE -Parent) path\to\repo\poshutils
```

To install the above dependencies into the user module path, run e.g.,

```powershell
Install-Module -Name PSReadLine -Scope CurrentUser
```

Your are done!
