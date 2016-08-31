################################################################################
#
# General utility functions
#
# Copyright (c) 2014-2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Opens Windows PowerShell HTML help.

.DESCRIPTION
  The Get-CHM function opens the Windows Powershell as a compiled HTML file (.chm).

.LINK
  Get-Help
#>
function Get-CHM
{
  Invoke-Item $env:windir\help\mui\0409\WindowsPowerShellHelp.chm
}

<#
.SYNOPSIS
  Gets the command binding.

.DESCRIPTION
  The which function returns the cmdlet or executable a command is bound to.
  It is the equivalent of the *nix which command.

  Returns error if command is unknown.

.EXAMPLE
  PS > which dir
  This command returns the command the alias dir refers to.

.EXAMPLE
  PS > which explorer
  This command returns the location of the executable explorer.

.LINK
  Get-Command
#>
function which
{
  param (
   # [Parameter(Position=0, ValueFromPipeline=$true,
   #  ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
   # [String]
	  #[ValidateNotNullOrEmpty()]
	  $Name
  )

  Get-Command $Name | Select-Object -ExpandProperty Definition
}

<#
.SYNOPSIS
  Kills current process.

.DESCRIPTION
  The function Stop-CurrentProcess kills the current process.
  If emitted from a PowerShell console, it exits the console.

.LINK
  Stop-Process
#>
function Stop-CurrentProcess
{
  Stop-Process -Id $PID
}

<#
.SYNOPSIS
  Make link.

.DESCRIPTION
  The function mklink is a wrapper aound the mklink command built into cmd.exe.
  All arguments are forwarded to the builtin command.

.LINK

#>
function mklink
{
  cmd /c mklink $args
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4H0KUAOmJLMmCg/juFTVBXYm
# 0vigggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBTfrunm2DOxW4pQOe0H3A+Bh/ZVlzANBgkqhkiG
# 9w0BAQEFAASBgCndpdZv+2YLcp+EO1l5HHBQ+cMaDBKPAJvfrPYeAWXxqsEdKkmh
# IzOaxRAm9KJ7ZG1AveYFG74PxfJVw7/fdC0IQDhi9IogGW91eRslHZK+UpV7N/7o
# KhKXC7iwUIjtYeElYbXNWGaxCAEzA1O6QRAXWIHcQmvJLX6caFEU8qZe
# SIG # End signature block
