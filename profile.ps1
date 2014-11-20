###########################################################################
#
# Powershell profile for current user on all hosts
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Licensed under the MIT License (MIT).
#
# You should have received a copy of the MIT License along with this file.
# If not, you may obtain a copy at http://opensource.org/licenses/MIT.
#
###########################################################################

$SourcePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'WindowsPowerShell'

###########################################################################
# Import modules
$UserModulePath = Join-Path -Path ($SourcePath) -ChildPath 'Modules'

Import-Module -Name (Join-Path (Join-Path $UserModulePath 'PsGet') 'PsGet')
Import-Module posh-git

###########################################################################
# Functions

# Sets up a simple prompt, adding the git prompt parts inside git repos
function global:prompt 
{
  $realLASTEXITCODE = $LASTEXITCODE

  # Reset color, which can be messed up by Enable-GitColors
  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

  # Replace home path with tilde
  Write-Host($pwd.ProviderPath.replace("$env:USERPROFILE",'~')) -ForegroundColor DarkYellow

  Write-VcsStatus

  $global:LASTEXITCODE = $realLASTEXITCODE
  Write-Host "$env:USERNAME@$env:COMPUTERNAME$('>' * ($nestedPromptLevel + 1))" -ForegroundColor Blue -NoNewline
  return " "
}

# Fancier output for Git
Enable-GitColors

#if(Test-Path -Path (Join-Path $ExpectedUserModulePath 'PsGet') -PathType Container)
#{
#  Import-Module -Name (Join-Path $ExpectedUserModulePath 'PsGet')
#}

#if(Test-Path -Path (Join-Path $ExpectedUserModulePath 'PoshGit') -PathType Container)
#{
#  Import-Module -Name (Join-Path $ExpectedUserModulePath 'posh-git')
#}

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

###########################################################################
# Source scripts
$user_cmds = 'Add-Signature','Add-Path','Invoke-WalkCommand','VisualStudioUtils'
$user_cmds | %{
  if(Test-Path -Path (Join-Path $SourcePath ($_ + '.ps1')) -PathType Leaf) {
    . (Join-Path $SourcePath ($_ + '.ps1'))
  }
}

## Load posh-git profile
#if(Test-Path -Path (Join-Path $ExpectedUserModulePath 'PoshGit\profile.ps1') -PathType Leaf)
#{
#  . (Join-Path $ExpectedUserModulePath 'PoshGit\profile.ps1')
#}

###########################################################################
# PS drives
New-PSDrive -Name user -PSProvider filesystem -Root $env:USERPROFILE | Out-Null
New-PSDrive -Name dev -PSProvider filesystem -Root $env:USERPROFILE\Dev | Out-Null
New-PSDrive -Name scripts -PSProvider filesystem -Root $SourcePath | Out-Null
New-PSDrive -Name build -PSProvider filesystem -Root C:\build | Out-Null
New-PSDrive -Name repos -PSProvider filesystem -Root $env:USERPROFILE\Dev\repos | Out-Null

###########################################################################
# Aliases
New-Alias -Name ivv -Value Import-VisualStudioVars
New-Alias -Name ass -Value Start-SshAgent 
New-Alias -Name gh -Value Get-Help
New-Alias -Name walk -Value Invoke-WalkCommand

# Change to powershell source directory
if (Test-Path -Path $SourcePath -PathType Container) {
  Set-Location $SourcePath
}
