poshutils
=========

Collection of PowerShell modules and utilities.

These PowerShell commands include tools for programming in VisualStudio(R),
Git source code management, signing code and various system utilities.

They make use of the following external PowerShell modules:

* [Pester](https://github.com/pester/Pester)
* [PsGet](https://github.com/psget/psget)
* [posh-git](https://github.com/dahlbyk/posh-git)

which are incorporated as submodules.

Installation
------------

Clone the repository 


```
  git clone git@github.com:nhbusch/poshutils.git %USERPROFILE%/Documents/WindowsPowerShell
```

Install submodules (first time only)

```
  cd ~/Documents/WindowsPowerShell/Modules
  git submodule init
  git submodule update
```

To upgrade a specific module, go to the submodule directory and pull the latest changes by

```
  git pull origin master
```

Upgrading all modules can be achieved by 

```
  git submodule foreach git pull origin master
```

