################################################################################
#
# PsSSH
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

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
  The Add-SshKey function searches a directory recursively for keys and
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

Export-ModuleMember Add-SshKey

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUc9YLn3BG/PvgHy+4HauAqnEP
# ncegggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRQxGiG+ILb979+eS7u0gW1hec7ZzANBgkqhkiG
# 9w0BAQEFAASBgD9uu6ovYz/AWQktAiOlNLQz/7x5NO4od8/FFjZG5BvCZAYfZVup
# jlBYxrF4NAs5Wn5+JqX4vgcaa2y7vfEF8swOJJIVwh7I4fuD+obfWpoozS1W+H5E
# 2S3kSYT6jP/uYSchFwNTtleiJk5l9cBaee3XkNNTV0jEyiJjR1NcpJ9R
# SIG # End signature block
