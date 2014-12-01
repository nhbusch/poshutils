###############################################################################
#
# PsSSH
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
###############################################################################

# For backwards compatibility
if (!(Get-Command Get-SshAgent)) {
  Import-Module -Name posh-git
}

function Add-SshKey()
{
<#
.SYNOPSIS
  Adds one or more keys to the SSH agent.

.DESCRIPTION
  The Add-SshKey function searches recursively a directory for keys and
  adds them to the running SSH instance.
  
  Currently, ssh-add for Unix (including Cygwin or Git-bash) and PuTTy's
  plink are supported.

.PARAMETER Path
  Specifies the path to search. If none is given, default path '.ssh' is 
  searched.

.SYNTAX

.EXAMPLE
  PS > Add-SshKey
  Adds all keys in directory '.ssh' and below.

.LINK
  Start-SshAgent

#>
  [CmdletBinding()]
  param(
      [Parameter(Position=0, ValueFromPipeline=$false,
       ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
      [String]
      [ValidateNotNullOrEmpty()]
      $path = ".ssh"
  )

  process
  {
    if ($env:GIT_SSH -imatch 'plink') {
      $pageant = Get-Command (Join-Path (Split-Path $env:GIT_SSH -Parent) pageant) -ErrorAction SilentlyContinue
      if (!$pageant) {
        Write-Warning "Could not find 'Pageant'."
        return
      }
      if (Test-Path -Path $path -PathType Container) {
        $keypath = $path
      }
      else {
        $keypath = Join-Path $Env:HOME ".ssh"
      }
      $keys = Get-ChildItem -Recurse $keypath/"*.ppk" | Select -ExpandProperty FullName
      $keystring = ""
      # for backward compatibility, otherwise splatting would be more concise
      foreach ($key in $keys) {
        $keystring += "`"$key`" "
      }
      if ( $keystring ) {
        & $pageant "$keystring"
      }
    }
    else {
        $ssh_add = Get-Command ssh-add -TotalCount 1 -ErrorAction SilentlyContinue
        if (!$ssh_add) {
          Write-Warning "Could not find 'ssh-add'."
          return
        }
        # FIXME: consume path argument before? or handled by named param $path only
        if ($args.Count -eq 0) {
            & $ssh_add
        }
        else {
          foreach ($value in $args) {
            & $ssh_add $value
          }
        }
    }
  }
}
