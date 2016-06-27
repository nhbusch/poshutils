################################################################################
#
# Utilites for VisualStudio(R).
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

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
  values are 2008, 2010, 2012, 2013, and 2015.

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
        [ValidateSet('90', '2008', '100', '2010', '110', '2012', '120', '2013', '140', '2015')]
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
      '140|2015' {
        Invoke-BatchFile "${env:VS140COMNTOOLS}..\..\VC\vcvarsall.bat" $Architecture
        Write-Host "Imported VS 2015 $Architecture environment variables." -ForegroundColor Green
      }
 
      default {
        Write-Error "Import-VisualStudioVars: Unknown version: $Version"
      }
    }
  }
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfAHXPpA4HraFC6mmnhuYyaYY
# WVqgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBS1odKZOFROMYPfk+ZHaGzHYOWxQDANBgkqhkiG
# 9w0BAQEFAASBgHKlgry2MvCMvaF3VcZ07RUGU/CyvGJddlKl6B2Srt46DyJpgW0F
# fzoA/92ZaQY2RLYcwS3TX78oYt/wmSC/foRa/Ack/8eZZuN8hxtaepp2WvmgeXSG
# 9Gm6ifzz9PNvUzwGPTW050U8R1RKu/cDxTfed6eYTMVGPt5BlHzjurZf
# SIG # End signature block
