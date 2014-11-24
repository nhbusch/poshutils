###############################################################################
#
# Utilites for VisualStudio(R).
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
###############################################################################

<#
.SYNOPSIS
  Invokes the specified batch file and retains any environment variable 
  changes it makes.

.DESCRIPTION
  Invoke the specified batch file (and parameters), but also propagate any  
  environment variable changes back to the PowerShell environment that  
  called it.

.PARAMETER Path
  Path to a .bat or .cmd file.

.PARAMETER Parameters
  Parameters to pass to the batch file.

.EXAMPLE
  C:\PS> Invoke-BatchFile "$env:ProgramFiles\Microsoft Visual Studio 9.0\VC\vcvarsall.bat"
  Invokes the vcvarsall.bat file.  All environment variable changes it makes will be
  propagated to the current PowerShell session.

.NOTES
  Author: Lee Holmes    
#>
function Invoke-BatchFile
{
  param([string]$Path, [string]$Parameters)  

  $tempFile = [IO.Path]::GetTempFileName()  

  # Store the output of cmd.exe.  We also ask cmd.exe to output   
  # the environment table after the batch file completes  
  cmd.exe /c " `"$Path`" $Parameters && set > `"$tempFile`" " 

  # Go through the environment variables in the temp file.  
  # For each of them, set the variable in our local environment.  
  Get-Content $tempFile | Foreach-Object {   
      if ($_ -match "^(.*?)=(.*)$") { 
        Set-Content "env:\$($matches[1])" $matches[2]  
      } 
  }  

  Remove-Item $tempFile
}

<#
.SYNOPSIS
  Imports environment variables for the specified version of Visual Studio.

.DESCRIPTION
  Imports environment variables for the specified version of Visual Studio. 
  This function selects the appropriate set of environment variables
  depending on the target architecture and the architecture of the hosting 
  PowerShell process (either 32bit or 64bit).

.PARAMETER Version
  The version of Visual Studio to import environment variables for. Valid 
  values are 2008, 2010, 2012 and 2013.

.PARAMETER Architecure
  Selects the desired architecture to configure the environment for. 
  Defaults to x86 if running in 32-bit PowerShell, otherwise defaults to 
  amd64. Other valid values are: arm, x86_arm, x86_amd64

.EXAMPLE
  C:\PS> Import-VisualStudioVars 2010

  Sets up the environment variables to use the VS 2010 compilers. Defaults 
  to x86 if running in 32-bit PowerShell, otherwise defaults to amd64.

.EXAMPLE
  C:\PS> Import-VisualStudioVars 2012 arm

  Sets up the environment variables for the VS 2012 arm compiler.

.LINK 
  Invoke-BatchFile
  
#>
function Import-VisualStudioVars 
{
  param([Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('90', '2008', '100', '2010', '110', '2012', '120', '2013', '140')]
        [string]
        $Version,
        [Parameter(Position = 1)]
		    [string]
        $Architecture = $(if( [intptr]::size -eq 8) {'amd64'} else {'x86'})
  )
 
  End {
    switch -regex ($Version) {
      '90|2008' {
        Invoke-BatchFile "${env:VS90COMNTOOLS}..\..\VC\vcvarsall.bat" $Architecture
        Write-Host "Imported VS 2008 $Architecture environment variables." -ForegroundColor Green
      }
      
      '100|2010' {
        Invoke-BatchFile "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat" $Architecture
        Write-Host "Imported VS 2010 $Architecture environment variables." -ForegroundColor Green
      }
 
      '110|2012' {
        Invoke-BatchFile "${env:VS110COMNTOOLS}..\..\VC\vcvarsall.bat" $Architecture
        Write-Host "Imported VS 2012 $Architecture environment variables." -ForegroundColor Green
      }
 
      '120|2013' {
        Invoke-BatchFile "${env:VS120COMNTOOLS}..\..\VC\vcvarsall.bat" $Architecture
        Write-Host "Imported VS 2013 $Architecture environment variables." -ForegroundColor Green
      }
      '140' {
        Invoke-BatchFile "${env:VS140COMNTOOLS}..\..\VC\vcvarsall.bat" $Architecture
        Write-Host "Imported VS 2014 $Architecture environment variables." -ForegroundColor Green
      }
 
      default {
        Write-Error "Import-VisualStudioVars: Unknown version: $Version"
      }
    }
  }
}
# SIG # Begin signature block
# MIIFzAYJKoZIhvcNAQcCoIIFvTCCBbkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnrikeFV2kZAsnfrL/2syILr6
# wrigggNVMIIDUTCCAj2gAwIBAgIQxav5BGIa87tCfotcMg3zUzAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDA3MTYxNjQzNTRaFw0zOTEyMzEyMzU5NTlaMC0xKzApBgNVBAMTIkJ1c2No
# IE5pbHMgSG9sZ2VyIFdBTkJVIFBvd2VyU2hlbGwwggEiMA0GCSqGSIb3DQEBAQUA
# A4IBDwAwggEKAoIBAQDDAb4T9RGYykKLPbWQFekx14bM/CJuilQ87HCd0qjI8Lj/
# Vx0q7Y0nIivBVPhz/l4eGByeLvLvpEPAItVOwXga9708mTb8En5Vc34EVjyVVAc4
# hvS7p/CmWmQewN4QZT0mdSKPJF98wZeLc4FBa5B8CX7+Yr2R1GGe/JX1y2ZuQRh9
# qfvijMfwcxQT0fzMVN8eUpCM0OKB8cBQk/QbKUnGWLMX07kRG5Cw6jMxBL2LaHrR
# suus+u6euqSl9b338Yiqga3F1S6DtIp7GAqGvwUb3dplC9kV5qMOkv2peJXX2+EG
# 3gyi04tyKFcyKkO/f7ybcZWBJiSVW1tOWji7Mku/AgMBAAGjdjB0MBMGA1UdJQQM
# MAoGCCsGAQUFBwMDMF0GA1UdAQRWMFSAEOJ9aPvUCRUGX7bq9/7g7w6hLjAsMSow
# KAYDVQQDEyFQb3dlclNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3SCEFF4X7ZQ
# RsePT3rZBbEzJrUwCQYFKw4DAh0FAAOCAQEAkQpF50wO9Om9BUV4ctRAXDQIJLWn
# cpgVIJ9PVYeR0572tBZP/lkmqsbeXhzkLUWHzR1hEFk3E51w/xM1EPjOoMVOhnHy
# eV1BhQTi4Sc7fx/hOoTaqe6t2tWIe/p1hwTmPj5jw4pidtiT5yww6OUGD4/jIwXW
# O6bZ9I1o5afE1PolE2zu6B9Gn76raQr7qRP534wP13DHHZgR7DvplpcWSTpcO1td
# 9mqktRnIGf2EqzHMLqDV87CV4sKhEm3pjjgIvqrOkR/xd38QQIzViqb5cWdEnHQm
# LeBm+5or2vGLKwdq01dsqmVtp9m+lP69mg003haUy5ArtagHU+t7x1S4+jGCAeEw
# ggHdAgEBMEAwLDEqMCgGA1UEAxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZpY2F0
# ZSBSb290AhDFq/kEYhrzu0J+i1wyDfNTMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3
# AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisG
# AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQTxMDtvLMa
# nne0J4zQ2iOIsriE+jANBgkqhkiG9w0BAQEFAASCAQC7b6ZVHs1zoZ7micBqJEgu
# 8uBX4H8TA7DXEOqdTl0bTWqpXym+g5sGqZfIPZH4zZnkPfeakmjsTz5CG1EGbXrj
# k8Kq3Wprta1yo6KhOPWuKxphcnB5IughqFVOG+/j/NPNhoF+xIFirZ4Dxynv5oZp
# wjAr3qVJU8hgRWkKVYU+Rw/b8PpZIZw6UOMA2w76MwllG6MAphxWV3mKXoLPdleU
# p6mKJEiPEhTofIL1HrVRW8pyCniqH5Oia1Kkqi0L7kBdIxQSq8psbv8xfec4pYnV
# g6FyscLcvONIJotL7ysuz0wptElQ10k8n4sDgctOeuxHt+eMiuUBdfkjlJ8OrsSj
# SIG # End signature block
