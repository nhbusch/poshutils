################################################################################
#
# Set-ItemDateTime
#
# Copyright (c) 2020 Nils H Busch. All rights reserved.
#
# Borrowed from https://stackoverflow.com/questions/51841259/touch-function-in-powershell.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Sets date and time for item.

.DESCRIPTION
  The Set-ItemDateTime function updates the item's modification time.
  If no date/time is specified, the current time will be used.

.PARAMETER Path
  Specifies the item(s) to set date and time for.

.PARAMETER Value
  Specifies the new date and time. Default is current date and time

.PARAMETER Force
  Force update of items that cannot be modified otherwise, e.g. hidden items.

.EXAMPLE
  PS > Set-ItemDateTime C:\path\to\my\file.txt
  Updates modification time of 'C:\path\to\my\file.txt' to current time.

.EXAMPLE
  PS > Set-ItemDateTime -Path C:\path -Value (Get-Date).AddHours(1)
  Updates modification time of folder to one hour ahead.

.LINK

#>

function Set-ItemDateTime {
  [CmdletBinding(SupportsShouldProcess = $true)]
  param(
    [Parameter(Position = 0, ValueFromPipeline = $true,
      ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
    [String]
    [ValidateNotNullOrEmpty()]
    $Path,
    [Parameter(Position = 1, ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false, Mandatory = $false)]
    [datetime]
    $Value = (Get-Date),
    [Parameter(ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false, Mandatory = $false)]
    [Switch]
    $Force
  )

  process {
    if($PSCmdlet.ShouldProcess($Path)) {
      Get-Item $Path -Force:$Force | ForEach-Object { 
        $_.LastWriteTime = $Value }
    }
  }
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWIa9XIChtp0luUq0kGviYVzX
# HRigggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRaV9MFs1ykOUS6Rqn5juhhNRh1xzANBgkqhkiG
# 9w0BAQEFAASBgDNsnp5XLGClm6+BzjAtMLLjrluYcwFC8oUd3BY2B4TWg5gAMZ3e
# uPjxOcVKZ01Necq5Re1QBTXaotBpOpXYfHTHssE2MkAnuFP2P+78zNZtmYPM0iIv
# 7QIHjFvFbGPojxGk6AbDVi0HeH0c5K82Lf9HGLhoTNJKLWKHbl5atJ1h
# SIG # End signature block
