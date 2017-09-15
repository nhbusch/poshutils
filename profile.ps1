################################################################################
#
# Powershell profile for current user on all hosts
#
# Copyright (c) 2014-2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

################################################################################
# User paths
function Set-UserPaths($Root)
{
  # User script path
  $script_path= Join-Path $Root 'Scripts'

  # Module path
  $module_path = @($env:PSModulePath -split ';')
  $expected_user_module_path = Join-Path $Root 'Modules'
  if(-not ($module_path | Where-Object { $_ -eq $expected_user_module_path })) {
    $env:PSModulePath = $expected_user_module_path + '\;' + $env:PSModulePath
  }

  # Adds path to local commands to PATH environment variable
  function Add-LocalCommandPath
  {
    $tail = Join-Path 'opt' 'utils'
    $head = (Get-Item "Env:HOMEDRIVE").Value, 'C:' | Get-Unique # don't sort
    foreach ($h in $head) {
      $path = Join-Path $h $tail
      if(Test-Path -Path $path -PathType Container) {
        $env:path += ";" + $path
        break
      }
    }
  }
  Add-LocalCommandPath

  @{Root = $Root; Scripts = $script_path}
}

$UserPath = Set-UserPaths(Split-Path $MyInvocation.MyCommand.Definition -Parent)

################################################################################
# Import modules with special needs

# Posh-Git
if((Get-Command -Name git) -and (Get-Module -Name posh-git -ListAvailable)) {
  Import-Module posh-git
  if(Get-Module -Name posh-git) {
    $WithGitSupport = $true;

    # Configure
    if(Test-Path -Path (Join-Path $UserPath.Root 'PoshGitConfig.Local.ps1') -PathType Leaf) {
      . (Join-Path $UserPath.Root 'PoshGitConfig.Local.ps1')
    }
  }
}

# If not auto-loaded, import PSReadline
if($Host.Name -eq 'ConsoleHost') {
  if((Get-Module -Name PSReadline -ListAvailable) -and !(Get-Module -Name PsReadline)) {
    Import-Module -Name PSReadLine
  }

  # Configure
  if(Test-Path -Path (Join-Path $UserPath.Root 'PSReadlineConfig.Local.ps1') -PathType Leaf) {
    . (Join-Path $UserPath.Root 'PSReadlineConfig.Local.ps1')
  }
}

# FIXME Enable once extraneous blank line issue has been resolved
# If not auto-loaded, import PSColor
#if($Host.Name -eq 'ConsoleHost') {
#  if((Get-Module -Name PSColor -ListAvailable) -and !(Get-Module -Name PSColor)) {
#    Import-Module -Name PSColor
#  }

#  # Configure

#  if(Test-Path -Path (Join-Path $UserPath.Root 'PSColorConfig.Local.ps1') -PathType Leaf) {
#    . (Join-Path $UserPath.Root 'PSColorConfig.Local.ps1')
#  }
#}

################################################################################
# Configure

# Console host
if($Host.Name -eq 'ConsoleHost') {
  if(Test-Path -Path (Join-Path $UserPath.Root  'ConsoleConfig.Local.ps1') -PathType Leaf) {
     & (Join-Path $UserPath.Root 'ConsoleConfig.Local.ps1')
  }
}

# Set prompt, adding the git prompt parts when inside git repos
function global:prompt
{
  $realLASTEXITCODE = $LASTEXITCODE

  $is_nuget_console = $profile.Contains('NuGet_profile')
  $location_color = if ($is_nuget_console) {'DarkGreen'} else {'Green'}
  $path_color = if ($is_nuget_console) {'DarkYellow'} else {'Yellow'}

  # Replace home path with tilde
  $path = $pwd.ProviderPath.Replace("$env:HOMEDRIVE"+"$env:HOMEPATH",'~').Replace("$HOME", '~').Replace("$env:USERPROFILE",'~~')
  Write-Host ("$env:USERNAME@$env:COMPUTERNAME"+":") -ForegroundColor $location_color -NoNewline # was Cyan
  Write-Host ("$path") -ForegroundColor $path_color -NoNewline

  if($WithGitSupport) {
    Write-VcsStatus
  }

  $global:LASTEXITCODE = $realLASTEXITCODE
  return "$('>' * ($nestedPromptLevel + 1)) "
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
# PS drives
New-PSDrive -Name user -PSProvider filesystem -Root $env:USERPROFILE | Out-Null
New-PSDrive -Name dev -PSProvider filesystem -Root D:\dev | Out-Null
New-PSDrive -Name scripts -PSProvider filesystem -Root $UserPath.Root | Out-Null
New-PSDrive -Name build -PSProvider filesystem -Root D:\build | Out-Null
New-PSDrive -Name repos -PSProvider filesystem -Root D:\dev\repos | Out-Null
New-PSDrive -Name tfs -PSProvider filesystem -Root D:\dev\tfs | Out-Null

################################################################################
# Aliases
New-Alias -Name ivv -Value Import-VisualStudioVars
New-Alias -Name ssa -Value Start-SshAgent
New-Alias -Name gh -Value Get-Help
New-Alias -Name walk -Value Invoke-WalkCommand
New-Alias -Name edit -Value code
New-Alias -Name cmake -Value cmake.bat
New-Alias -Name ctest -Value ctest.bat
New-Alias -Name die -Value Stop-CurrentProcess
New-Alias -Name sdiff -Value 'C:\Program Files\Git\usr\bin\diff.exe'
New-Alias -Name build -Value Invoke-MsBuildHere
New-Alias -Name vcpkg -Value vcpkg.bat
New-Alias -Name ninja -Value ninja.bat

# Change to powershell user script directory
if (Test-Path -Path $UserPath.Root -PathType Container) {
  Set-Location $UserPath.Root
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUaDUb34H0uozfoVR/gZY01gkY
# bdCgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBTfrZcb+iAnCoDOZ0vz6onn797dUDANBgkqhkiG
# 9w0BAQEFAASBgBxJpOVOxDGGUgMLl/EkPy4WmsmdnY3H0DJZXicnPw92bgZyAQkg
# phEbDOl6pDNIY5ekrZf+CR/S2IWkItMXXrjvbXQWpXQgjjrff4zShbGBf5uRZvfP
# W4OgtX3Ipiv5DlBvZzfjBZkOE0lejtvnGSMB2969CI2FZu5rGMBMd+mK
# SIG # End signature block
