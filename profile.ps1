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
# Default paths 
$script:ThisPath = Split-Path $MyInvocation.MyCommand.Definition -Parent

# UserScriptPath
$UserScriptPath = Join-Path $script:ThisPath 'Scripts'

# Module path
$ModulePaths = @($env:PSModulePath -split ';')
$ExpectedUserModulePath = Join-Path $script:ThisPath 'Modules'
if(-not ($ModulePaths | Where-Object { $_ -eq $ExpectedUserModulePath })) {
  $env:PSModulePath = $ExpectedUserModulePath + '\;' + $env:PSModulePath
}

################################################################################
# Import modules with special needs

# Posh-Git
if((Get-Command -Name git) -and (Get-Module -Name posh-git -ListAvailable)) {
  Import-Module posh-git
  if(Get-Module -Name posh-git) {
    $WithGitSupport = $true;

    # Configure
    if(Test-Path -Path (Join-Path $script:ThisPath 'PoshGitConfig.Local.ps1') -PathType Leaf) {
      . (Join-Path $script:ThisPath 'PoshGitConfig.Local.ps1')
    }
  }
}

# If not auto-loaded, import PSReadline
if($Host.Name -eq 'ConsoleHost'  -and !(Get-Module -Name PSReadline) -and (Get-Module -Name PsReadline -ListAvailable)) {
  Import-Module -Name PSReadLine

  # Configure
  if(Test-Path -Path (Join-Path $script:ThisPath 'PSReadlineConfig.Local.ps1') -PathType Leaf) {
    . (Join-Path $script:ThisPath 'PSReadlineConfig.Local.ps1')
  }
}

################################################################################
# Configure

# Console host
if($Host.Name -eq 'ConsoleHost') {
  if(Test-Path -Path (Join-Path $script:ThisPath 'ConsoleConfig.Local.ps1') -PathType Leaf) {
     & (Join-Path $script:ThisPath 'ConsoleConfig.Local.ps1') 
  }
}

# Set prompt, adding the git prompt parts when inside git repos
function global:prompt
{
  $realLASTEXITCODE = $LASTEXITCODE

  # Reset color, which can be messed up by Enable-GitColors
  #$Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor see above #  DarkBlue

  # Replace home path with tilde
  $path = $pwd.ProviderPath.Replace("$env:HOMEDRIVE"+"$env:HOMEPATH",'~').Replace("$env:USERPROFILE",'~~')
  Write-Host ("[$env:USERNAME@$env:COMPUTERNAME"+"] ") -ForegroundColor Green -NoNewline # was Cyan
  Write-Host ("$path") -ForegroundColor Yellow -NoNewline 

  if($WithGitSupport) {
    Write-VcsStatus
  }

  $global:LASTEXITCODE = $realLASTEXITCODE
  #Write-Host "$env:USERNAME@$env:COMPUTERNAME$('>' * ($nestedPromptLevel + 1))" -ForegroundColor Blue -NoNewline
  return "$('>' * ($nestedPromptLevel + 1)) "
}

# Fancier output for Git
if($WithGitSupport) {
  Enable-GitColors
}

# FIXME Move to helper function setting user paths
# Adds path to utilities to PATH environment variable
function Add-UtilsPath
{
  $tail = Join-Path 'opt' 'utils'
  $head = (Get-Item "Env:HOMEDRIVE").Value, 'C:'
  foreach ($h in $head) {
    $utils_path = Join-Path $h $tail
    if(Test-Path -Path $utils_path -PathType Container) {
      $env:path += ";" + $utils_path
      break
    }
  }
}
Add-UtilsPath

################################################################################
# Functions

# FIXME Move to utils
# Opens Windows PowerShell Help as a compiled HTML Help file (.chm).
function Get-CHM
{
  (Invoke-Item $env:windir\help\mui\0409\WindowsPowerShellHelp.chm)
}

# Gets the location of a command (equivalent of *nix which)
function which($name)
{
  Get-Command $name | Select-Object -ExpandProperty Definition
}

# Gets the alias for a cmdlet
function Get-CmdletAlias($cmdletname)
{
  Get-Alias | where {$_.definition -like "*$cmdletname*"} | Format-Table `
     Definition, Name -auto
}

################################################################################
# Source scripts
#FIXME hide internal vars like user_cmds, here we could use script block
$user_cmds = 'Add-Signature','Add-Path','Invoke-WalkCommand','VisualStudioUtils'
$user_cmds | %{
  if(Test-Path -Path (Join-Path $UserScriptPath ($_ + '.ps1')) -PathType Leaf) {
    . (Join-Path $UserScriptPath ($_ + '.ps1'))
  }
}



################################################################################
# PS drives
New-PSDrive -Name user -PSProvider filesystem -Root $env:USERPROFILE | Out-Null
New-PSDrive -Name dev -PSProvider filesystem -Root D:\dev | Out-Null
New-PSDrive -Name scripts -PSProvider filesystem -Root $script:ThisPath | Out-Null
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
#FIXME alias ll when colored dir output

# ScriptRoot
# or PSScriptRoot if version < 3

# Change to powershell source directory
if (Test-Path -Path $script:ThisPath -PathType Container) {
  Set-Location $script:ThisPath
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGs7E8vmh+YYr+XEAjU1K8qAC
# AvCgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBTH+NTefbx9kEn11ZSDfkUHHx5C9zANBgkqhkiG
# 9w0BAQEFAASBgFiAvU00zADr/rx+OPuwoB/Q9AJ4RqpgE4rHQ/21x1qtYpbYfEty
# KOFs/nrhPfA+p0HPOlrL6Q4TpqravFnxgMQ2CCf3MgP0BHfvWW8lW3Z68dfAFsAZ
# Vj0972crKGEU1Bwc2xkzTOSQjLFv3rddQ2S11400mNXY6JkiLTLuN89g
# SIG # End signature block
