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
  if(!(Get-Module -Name PSReadline) -and (Get-Module -Name PsReadline -ListAvailable)) {
    Import-Module -Name PSReadLine
  }

  # Configure
  if(Test-Path -Path (Join-Path $UserPath.Root 'PSReadlineConfig.Local.ps1') -PathType Leaf) {
    . (Join-Path $UserPath.Root 'PSReadlineConfig.Local.ps1')
  }
}

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

  # Replace home path with tilde
  $path = $pwd.ProviderPath.Replace("$env:HOMEDRIVE"+"$env:HOMEPATH",'~').Replace("$HOME", '~').Replace("$env:USERPROFILE",'~~')
  Write-Host ("$env:USERNAME@$env:COMPUTERNAME"+":") -ForegroundColor Green -NoNewline # was Cyan
  Write-Host ("$path") -ForegroundColor Yellow -NoNewline 

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
# FIXME place them in a module and dot source from there (put them in Function folder)
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
New-Alias -Name edit -Value vim.bat
New-Alias -Name cmake -Value cmake.bat
New-Alias -Name die -Value Stop-CurrentProcess
New-Alias -Name sdiff -Value 'C:\Program Files\Git\usr\bin\diff.exe'
#FIXME alias ll when colored dir output

# Change to powershell user script directory
if (Test-Path -Path $UserPath.Root -PathType Container) {
  Set-Location $UserPath.Root
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqIVdbJkyZbcbQSMCe61DgA3L
# MzOgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBR5EOkqC4JLEr+fE73lah//kkRk7zANBgkqhkiG
# 9w0BAQEFAASBgEN0qsDP80/PEOMJmYo6eQrrnIpv6L1uoKjq6fzqv9tUqjVBESgi
# +f9j7s/It25oAg/XnY7OeAHF9VbdNnUz3OvJY12vE6R9nGulaypT5yu8zcAgFjLJ
# tpV0FqhkeX/hz3BC0T9Jr5Wvs9EXBUDiSaFIb7WRiqZimtH7lzqxx/8u
# SIG # End signature block
