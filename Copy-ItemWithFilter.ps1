###############################################################################
#
# Copy-ItemWithFilter
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
###############################################################################

<#
.SYNOPSIS
  Copies directories excluding certain files and directories. 

.DESCRIPTION
  The Copy-ItemWithFilter function copies directories and its subdirectories
  optionally excluding a set of directories and/or files.

.PARAMETER Path
  Specifies the source path.

.PARAMETER Destination
  Specifies the destination.

.PARAMETER Exclude
  Specifies the files to exclude.

.PARAMETER ExcludePath
  Specifies the paths to exclude.

.SYNTAX

.EXAMPLE
  PS > Copy-ItemWithFilter C:\path\to\my\files -Destination D:\dest`
	-Exclude @("*.exe","*.dll") -ExcludePath bin
  Copies directory structure below 'C:\path\to\my\files' to destination
  path 'D:\dest' ignoring the 'bin' folder and all executables and dlls.
  
.LINK
  Copy-Item

#>

# FIXME: WIP
function Copy-ItemWithFilter 
{
  [CmdletBinding()]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true, 
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [String]
	[ValidateNotNullOrEmpty]
	$Path,
	[Parameter(Position=1, ValueFromPipeline=$true, 
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [String] 
	[ValidateNotNullOrEmpty]
	$Destination,
	[Parameter(Position=2, ValueFromPipeline=$false, 
     ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
    [String[]] $Exclude="",
	[Parameter(Position=3, ValueFromPipeline=$false, 
     ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
    [String[]] $ExcludePath=""
  )

  process 
  {
	if (!Test-Path -Path $Destination -PathType Container) {
      throw New-Object System.IO.DirectoryNotFoundException("Destination directory does not exist.")
	}
	[regex] $_exclude_path_regex = '(?i)' + (($ExcludePath | foreach {[regex]::escape($_)}) –join '`|') + ''
	Get-ChildItem -Path $Path -Recurse -Exclude $Exclude | where 
		{ $ExcludePath -eq $null -or $_.FullName.Replace($Path, "") -notmatch $_exclude_path_regex } |  
		Copy-Item -Destination { 
			if ($_.PSIsContainer) { 
			  Join-Path $Destination $_.Parent.FullName.Substring($Path.length)
	        } else {    
	          Join-Path $Destination $_.FullName.Substring($Path.length)   
	        }  
	    } -Force -Exclude $exclude
  }
}


