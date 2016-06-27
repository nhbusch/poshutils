################################################################################
#
# Powershell profile for current user on all hosts
#
# Copyright (c) 2015 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Sets Solarized color scheme.

.DESCRIPTION
  The Set-SolarizedColorScheme adds or changes the PowerShell console color
  table registry values to the colors of the Solarized color scheme 
  (http://ethanschoonover.com/solarized). 

.PARAMETER Variant
  Specifies the color scheme variant.

.SYNTAX

.EXAMPLE
  PS > Set-SolarizedColorScheme(Dark)
  Sets the PowerShell console colors to the dark Solarized color scheme.
  
.LINK

#>

function Set-SolarizedColorScheme
{
  [CmdletBinding()]
  param(
      [Parameter(Position=0, ValueFromPipeline=$false,
       ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
      [String]
      [ValidateSet("Dark", "Light")]
      $variant = "Dark"
  )
  
  process {
    $key = 'HKCU:\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe' 
    $key = 'HKCU:\Console\Windows PowerShell'
    if (Test-Path $key) {
          # Common color table
          Set-ItemProperty -Path $key -Name ColorTable00 -Value 0x00362b00 
          Set-ItemProperty -Path $key -Name ColorTable01 -Value 0x00969483
          Set-ItemProperty -Path $key -Name ColorTable02 -Value 0x00756e58
          Set-ItemProperty -Path $key -Name ColorTable03 -Value 0x00a1a193
          Set-ItemProperty -Path $key -Name ColorTable04 -Value 0x00164bcb
          Set-ItemProperty -Path $key -Name ColorTable05 -Value 0x00c4716c
          Set-ItemProperty -Path $key -Name ColorTable06 -Value 0x00837b65
          Set-ItemProperty -Path $key -Name ColorTable07 -Value 0x00d5e8ee
          Set-ItemProperty -Path $key -Name ColorTable08 -Value 0x00423607
          Set-ItemProperty -Path $key -Name ColorTable09 -Value 0x00d28b26
          Set-ItemProperty -Path $key -Name ColorTable10 -Value 0x00009985
          Set-ItemProperty -Path $key -Name ColorTable11 -Value 0x0098a12a
          Set-ItemProperty -Path $key -Name ColorTable12 -Value 0x002f32dc
          Set-ItemProperty -Path $key -Name ColorTable13 -Value 0x008236d3
          Set-ItemProperty -Path $key -Name ColorTable14 -Value 0x000089b5
          Set-ItemProperty -Path $key -Name ColorTable15 -Value 0x00e3f6fd

      # Schemes vary wrt screen and highlight color
      switch ($variant) {
        "Dark" {
          Set-ItemProperty -Path $key -Name ScreenColors -Value 0x00000001
          Set-ItemProperty -Path $key -Name PopupColors -Value 0x000000f6
        }
        "Light" {
          Set-ItemProperty -Path $key -Name ScreenColors -Value 0x000000f6
          Set-ItemProperty -Path $key -Name PopupColors -Value 0x00000001
        }
      }
    }
  }
}

function Set-ConsoleFont
{
  process {
    $key = 'HKCU:\Console\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe' 
    if (Test-Path $key) {
       Set-ItemProperty -Path $key -Name FaceName -Value "Consolas" 
       Set-ItemProperty -Path $key -Name FontFamily -Value 0x00000036
       Set-ItemProperty -Path $key -Name FontSize -Value 0x000e0000
       Set-ItemProperty -Path $key -Name FontWeight -Value 0x00000190
    } 
  }
}

function Out-ConsoleColors
{
  [enum]::GetValues([ConsoleColor]) | % {
     Write-Host -NoNewLine "$($_.value__) : $_`t"
     Write-Host "COLOR`t" -ForegroundColor $_ -NoNewLine
     Write-Host "`t" -BackgroundColor $_
  }
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUt4AV8Xw670YT3Imq0Stpd+ru
# 8QqgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRSgzzGc9VN3Y3tVST13LxZaGqGlzANBgkqhkiG
# 9w0BAQEFAASBgApBWKVPUKGaIo0izp8a4xIDV/3N6NZX0Be2Norki0PiAEmHs7Go
# KY7YBJ6Rv8XLtQEZwTvWe4YuLCnHoOdrrSrSWxIEOSnHP/bdA2Hjq85p2i3byK6h
# VC3yvunBLIfy4Um0nX4Bndcvzb6ONi+wmZGvOqFeo2/AT/kEgtbc5dNn
# SIG # End signature block
