###########################################################################
#
# Powershell profile for current user on all hosts
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###########################################################################

# Add paths
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

$SourcePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'WindowsPowerShell'

# Import modules
$ExpectedUserModulePath = Join-Path -Path ($SourcePath) -ChildPath 'Modules'
if(Test-Path -Path (Join-Path $ExpectedUserModulePath 'PsGet') -PathType Container)
{
  Import-Module -Name (Join-Path $ExpectedUserModulePath 'PsGet')
}

# Source scripts
$user_cmds = 'Add-Signature','Add-Path','Invoke-WalkCommand','VisualStudioUtils'
$user_cmds | %{ 
  if(Test-Path -Path (Join-Path $SourcePath ($_ + '.ps1')) -PathType Leaf)
  {
	  . (Join-Path $SourcePath ($_ + '.ps1'))
  }
}

# Load posh-git profile
if(Test-Path -Path (Join-Path $ExpectedUserModulePath 'PoshGit\profile.ps1') -PathType Leaf)
{
  . (Join-Path $ExpectedUserModulePath 'PoshGit\profile.ps1')
}

# PS drives
New-PSDrive -Name user -PSProvider filesystem -Root $env:USERPROFILE | Out-Null
New-PSDrive -Name dev -PSProvider filesystem -Root $env:USERPROFILE\Dev | Out-Null
New-PSDrive -Name scripts -PSProvider filesystem -Root $SourcePath | Out-Null
New-PSDrive -Name build -PSProvider filesystem -Root C:\build | Out-Null
New-PSDrive -Name repos -PSProvider filesystem -Root $env:USERPROFILE\Dev\repos | Out-Null

# Aliases
New-Alias -Name ivv -Value Import-VisualStudioVars
New-Alias -Name ass -Value Start-SshAgent 
New-Alias -Name gh -Value Get-Help
New-Alias -Name walk -Value Invoke-WalkCommand

# Change to powershell source directory
if (Test-Path -Path $SourcePath -PathType Container) {
  Set-Location $SourcePath 
}
