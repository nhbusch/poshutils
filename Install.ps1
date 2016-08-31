################################################################################
#
# PowerShell install script
#
# Copyright (c) 2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

[CmdletBinding()]
param(
  [String]
  [ValidateNotNullOrEmpty()]
  $Path
  #[String]
  #[ValidateNotNullOrEmpty()]
  #$Link = (Join-Path -Path $home Documents\WindowsPowerShell)
)

<#
.SYNOPSIS
  Installs poshutils and its dependencies.

.DESCRIPTION
  The Install-PoshUtils function creates a link from the default PowerShell user
  directory - $HOME/Documents/WindowsPowerShell - to Path.
  It then installs the required modules.

.PARAMETER Path
  Specifies the installation path.

 .PARAMETER Link
  Specifies the link path.

.EXAMPLE
  PS > Install-PoshUtils -Path C:\path\to\poshutils
  Installs dependencies for poshutils and creates a symbolic link from
  'C:\path\to\poshutils' to the default PowerShell user directory
  $HOME/Documents/WindowsPowerShell.

.LINK
  Install-Module

#>
function Install-PoshUtils
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true,
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $Path,
    [Parameter(Position=1, ValueFromPipeline=$false,
     ValueFromPipelineByPropertyName=$false, Mandatory=$true)]
    [String]
    $Link
  )
  process
  {
    # Installs required modules and creates a hardlink from the default user script
    # directory to the poshutils installation directory

    # Requires PowerShell 3.0 or later
    if($PSVersionTable.PSVersion.Major -lt 3) {
      Write-Error -Message ("ERROR: Requires PowerShell 3.0 or later. Found version $($PSVersionTable.PSVersion).")
      return
    }

    # Create link
    if(Test-Path -Path $Path -PathType Container) {
      $_target = Convert-Path -Path $Path
      if(!(Test-Path $Link)) {
        Write-Verbose "Creating link from $Link to $_target"
        # For backwards compatibility to PowerShell 4 and earlier
        # PowerShell 5 provides New-Item instead
        cmd.exe /c mklink /J $Link $_target 2>&1 | Out-Null
      }
    }

    if(Get-Command -Name Install-Module -CommandType Function -ErrorAction Stop) {
      # Update this variable in case of additional dependencies
      $_deps = 'Pester', 'posh-git', 'PsReadline', 'PSColor', 'Invoke-MsBuild'

      # Install script
      $_install = {
        param (
          [String]$Name
        )
        if(!(Get-Module -Name $Name -ListAvailable)) {
          Write-Verbose "Installing dependency $Name"
          # Install to user module directory
          Install-Module -Name $Name -Scope CurrentUser
        }
      }

      foreach ($dep in $_deps) {
        Invoke-Command -ScriptBlock $_install -ArgumentList $dep
      }
    }

    Write-Output "Installed poshutils."
  }
}

Install-PoshUtils -Path $Path -Link (Join-Path -Path $home Documents\WindowsPowerShell)
 
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIVQIRGbabKF+MIrUgNn+NwlE
# t4CgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBTF85Las2hLUPaGhhymtaMA8m3YOTANBgkqhkiG
# 9w0BAQEFAASBgCwDj0XOK75Y+ta4ChGxkbpljTkCHVxn2EW6LtqlVqid9Qq7qnIk
# YrNRGx9UIb3nxP1okK0O8LW/H/NlZBAQaI5XtDqntX8j/bDSAadFs4JoSN+gmRvT
# tlA9UIqL6KEAyzmerOsW0o46EaSpelzf4OavilsmljEEJTbAORa+ZZN3
# SIG # End signature block
