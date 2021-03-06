################################################################################
#
# Powershell profile for current user on all hosts
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################
#Requires -Version 3

################################################################################
# User paths
function Set-UserPaths($Root) {
    # User script path
    $script_path = Join-Path $Root 'Scripts'

    # Module path
    $module_path = @($env:PSModulePath -split ';')
    $expected_user_module_path = Join-Path $Root 'Modules'
    if(-not ($module_path | Where-Object { $_ -eq $expected_user_module_path })) {
        $env:PSModulePath = $expected_user_module_path + '\;' + $env:PSModulePath
    }

    # Adds path to local commands to PATH environment variable
    function Add-LocalCommandPath {
        $tail = Join-Path 'opt' 'cmd'
        $head = (Get-Item "Env:HOMEDRIVE").Value, 'C:' | Get-Unique # don't sort
        foreach ($h in $head) {
            if (Test-Path -LiteralPath $h -ErrorAction SilentlyContinue) { 
                $path = Join-Path $h $tail
                if(($env:path -split ';' -replace '\\+$') -notcontains $path) {
                    if(Test-Path -Path $path -PathType Container) {
                        $env:path += ";" + $path
                        break
                    }
                }
            }
        }
    }
    Add-LocalCommandPath

    @{Root = $Root; Scripts = $script_path }
}

$UserPath = Set-UserPaths(Split-Path $MyInvocation.MyCommand.Definition -Parent)

################################################################################
# Import modules with special needs

# If not auto-loaded, import PSReadline
if(Get-Module -Name PSReadline -ListAvailable) {
    if(!(Get-Module -Name PSReadline)) {
        Import-Module -Name PSReadLine
    }

    # Configure
    if(Test-Path -Path (Join-Path $UserPath.Root 'PSReadlineConfig.Local.ps1') -PathType Leaf) {
        . (Join-Path $UserPath.Root 'PSReadlineConfig.Local.ps1')
    }
}

# Posh-Git
if((Get-Command -Name git -ErrorAction SilentlyContinue) -and (Get-Module -Name posh-git -ListAvailable)) {
    Import-Module posh-git

    # Configure
    if(Test-Path -Path (Join-Path $UserPath.Root 'PoshGitConfig.Local.ps1') -PathType Leaf) {
        . (Join-Path $UserPath.Root 'PoshGitConfig.Local.ps1')
    }
}

# Posh-vcpkg
if(Test-Path -Path 'D:\vcpkg\scripts\posh-vcpkg' -PathType Container) {
    Import-Module -Name 'D:\vcpkg\scripts\posh-vcpkg'
}

################################################################################
# Configure

# Console host
if($Host.Name -eq 'ConsoleHost') {
    if(Test-Path -Path (Join-Path $UserPath.Root  'ConsoleConfig.Local.ps1') -PathType Leaf) {
        & (Join-Path $UserPath.Root 'ConsoleConfig.Local.ps1')
    }
}

################################################################################
# Functions
# Dot sources all function files and scripts in local scripts directory,
# currently set to '$PSScriptRoot\Scripts'.
# Valid function files must end with *.ps1 extension.
# Files beginning with double underscores are excluded from loading.
# FIXME Eventually place them in a module and load this
Get-ChildItem $UserPath.Scripts |
Where-Object { $_.Name -notlike '__*' -and $_.Name -like '*.ps1' } |
ForEach-Object { . $_.FullName }

################################################################################
# Completers
# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}

################################################################################
# PS drives
New-PSDrive -Name user -PSProvider filesystem -Root $env:USERPROFILE | Out-Null
New-PSDrive -Name scripts -PSProvider filesystem -Root $UserPath.Root | Out-Null
if(Test-Path -Path 'D:\build' -PathType Container) {
    New-PSDrive -Name build -PSProvider filesystem -Root D:\build | Out-Null
}
if(Test-Path 'D:\dev' -PathType Container) {
    New-PSDrive -Name dev -PSProvider filesystem -Root D:\dev | Out-Null
    if(Test-Path 'D:\dev\repos' -PathType Container) {
        New-PSDrive -Name repos -PSProvider filesystem -Root D:\dev\repos | Out-Null
    }
    if(Test-Path 'D:\dev\tfvc' -PathType Container) {
        New-PSDrive -Name tfvc -PSProvider filesystem -Root D:\dev\tfvc | Out-Null
    }
}

################################################################################
# Aliases
New-Alias -Name ssa -Value Start-SshAgent
New-Alias -Name gh -Value Get-Help
New-Alias -Name walk -Value Invoke-WalkCommand
New-Alias -Name die -Value Stop-CurrentProcess
New-Alias -Name touch -Value Set-ItemDateTime
if(Get-Command -Name code -ErrorAction SilentlyContinue) {
    New-Alias -Name edit -Value code
}
if(Get-Command -Name 'C:\Program Files\Git\usr\bin\diff.exe' -ErrorAction SilentlyContinue) {
    New-Alias -Name sdiff -Value 'C:\Program Files\Git\usr\bin\diff.exe'
}
if(Get-Command -Name 'C:\opt\npe\NuGetPackageExplorer.exe' -ErrorAction SilentlyContinue) {
    New-Alias -Name npe -Value 'C:\opt\npe\NuGetPackageExplorer.exe'
}

# Change to dev drive or powershell user script directory
if (Test-Path -Path dev: -PathType Container) {
    Set-Location dev:
} elseif (Test-Path -Path $UserPath.Root -PathType Container) {
    Set-Location $UserPath.Root
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUeZvJDCydS1i9S7fHPUyxOjax
# tA+gggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNTA1MjcxNjEzMjVaFw0zOTEyMzEyMzU5NTlaMC0xKzApBgNVBAMTIkJ1c2No
# IE5pbHMgSG9sZ2VyIFdBTkJVIFBvd2VyU2hlbGwwgZ8wDQYJKoZIhvcNAQEBBQAD
# gY0AMIGJAoGBAKkPizbTOsd+uVe3mD7INJ98Yac1CZmp5hzO78G/U9AjHkBEaUWi
# awbbsevIZwLY+lIjhz8iNWUjF/BsHpYHFFbQzpo3Dwl9/nQt38ZVwUYkfvrkD+dG
# zs7adaGO7xvCmT/0PF1Dw9s0NxX/u+dEjgqMKp1c7avenvemT6ywd6iTAgMBAAGj
# djB0MBMGA1UdJQQMMAoGCCsGAQUFBwMDMF0GA1UdAQRWMFSAEKs6i/WOhLGt+nxH
# CCNHiOKhLjAsMSowKAYDVQQDEyFQb3dlclNoZWxsIExvY2FsIENlcnRpZmljYXRl
# IFJvb3SCEMFP9BrKKP6QQWBYTOZuSCowCQYFKw4DAh0FAAOBgQBUraMSyau3Kv82
# nEhiv4SokzuhmrRz+8sxdwycwqfxZYSscmrMPlhbZsMM/5d+npzzinCHiIaUjUIR
# EKKYHFpECfNpI/BLyiVr9asNIb8pqFmACvfRDBC7hIq8biuBuF+syACJiK6F4KPe
# OcMTPNMQhztINw8xzJ9P7D2BQteeaTGCAWAwggFcAgEBMEAwLDEqMCgGA1UEAxMh
# UG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0ZSBSb290AhDLxMG3g6j0lkOl3nNs
# DjekMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqG
# SIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3
# AgEVMCMGCSqGSIb3DQEJBDEWBBRPPQoNpZ5B4PYucGLvePcUm+mBnTANBgkqhkiG
# 9w0BAQEFAASBgKG+EAiCc33sJRB9fXEScVXmcvb0zRdoRMF6kaBz8oDew5NTwicc
# W4O9YVNNoQ0Dq1GB5Y20ZEREcbLNxlbfglLv4DnO1YGIhg6Ad7bmB53Pc/jKEV16
# VABbBDxaxt+7rbx/vtzc1ZaM6fMqM8n2ykEE1Y2lyY+hVfHSxuhSs3sM
# SIG # End signature block
