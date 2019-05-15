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
    $Path = (Get-Location)
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
function Install-PoshUtils {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [String]
        [ValidateNotNullOrEmpty()]
        $Path,
        [Parameter(Position = 1, ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false, Mandatory = $true)]
        [String]
        $Link
    )
    process {
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
            else {
                Write-Verbose "The directory $Link already exists. Copying the necessary files."
                # Copy-Item is just ridiculous
                Robocopy.exe $_target $Link *.ps1 /S | Out-Null
            }
        }

        if(Get-Command -Name Install-Module -CommandType Function -ErrorAction Stop) {
            # Update this variable in case of additional dependencies
            $_deps = 'posh-git', 'PsReadline', 'Invoke-MsBuild'

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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUNjrKKyPuLv/eZrRGNWXgYVsJ
# pB6gggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBT7+puYtAJE4Hqbm9cY3042waIpsjANBgkqhkiG
# 9w0BAQEFAASBgAyvI6i8lr/LgNN8tN/DHjZL6ntb50P5RVdzkx/C7+/Ud/OnOiGd
# KLLNlKPGHxXlPmBu+q6bGSpVPI9HYWY/fmrAdVBho7GEupR68rBidNvJZpjGJP0y
# 135zZc9N8PL0WVEG0AcEq6Rid6K6lt6eCGDyikHqTmJm8wpOV22pUNme
# SIG # End signature block
