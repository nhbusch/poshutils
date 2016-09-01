################################################################################
#
# Add-Path
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Adds path to system path.

.DESCRIPTION
  The Add-Path function appends a path to the system path for the current
  session. The path will be added only if it is not already in the list of
  system paths.

  The path will be added permanently if the Permanent flag is set.

  The path will be appended (default) or prepended depending on the
  Prepend flag.

.PARAMETER Path
  Specifies the path to add.

.PARAMETER Permanent
  Specifies whether to add the path permanently.

.PARAMETER Prepend
  Specifies whether to add the path to the beginning or end of list.

.EXAMPLE
  PS > Add-Path C:\path\to\my\files
  Adds the directory 'C:\path\to\my\files' to the list of system paths for the
  current process.

.EXAMPLE
  PS > Add-Path -Path C:\path\to\my\files -Permanent -Prepend
  Prepends the directory 'C:\path\to\my\files' permanently to the list of system
  paths.

.LINK

#>

function Add-Path
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true,
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $Path,
    [Parameter(ValueFromPipeline=$false,
     ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
    [Switch]
    $Permanent,
    [Parameter(ValueFromPipeline=$false,
     ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
    [Switch]
    $Prepend
  )

  process
  {
    if (!(Test-Path -Path $Path -PathType Container))
    {
      throw New-Object System.IO.DirectoryNotFoundException("Path does not exist. Nothing will be added.")
    }

    # query current search path
    $_current = [System.Environment]::GetEnvironmentVariable("path")

    # add only if not already present, warn otherwise
    if($_current | Select-String -SimpleMatch $Path) {
      Write-Warning "The path `'$Path`' is already part of the system path."
    }
    else {
      # add backslash
      if(!($Path[-1] -match '\\')) {
        $Path = $Path + '\'
      }
      Write-Verbose "Adding path `'$Path`' to system path."

      if($Prepend) {
        $_new = $Path + ';' + $_current
      }
      else {
        $_new = $_current + ';' + $Path
      }

      if($PSCmdlet.ShouldProcess($Path)) {
        if($Permanent) {
          [System.Environment]::SetEnvironmentVariable("path",$_new,'Machine')
        }
        else {
          [System.Environment]::SetEnvironmentVariable("path",$_new)
        }
      }
    }
  }

  end
  {
    return $_new
  }
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUKWu+1A09F74Kw+lavCQ3oU8t
# XEqgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBQPpNPc8yhFflVPmgJATcZNLC8MzDANBgkqhkiG
# 9w0BAQEFAASBgE8GHeVFA2SYDlhnBoVbPV+H5wpLKlje4eAbROtD9Ifp8R+AY10p
# Xm+BcCMOhqdkZcrLKr+qV/XOMP9GuzUVndvPbF9q18VlFUZT+AoElNCRlMoOnV3L
# NdloIed5cTrfwRR/v9ClClEx+gFY95fbfx5oODVEOqXp1YfSZIPYYGLM
# SIG # End signature block
