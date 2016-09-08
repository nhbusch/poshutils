################################################################################
#
# Invoke-MsBuildHere
#
# Copyright (c) 2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Builds solution or projects in current directory.

.DESCRIPTION
  The Invoke-MsBuildHere function searches for solution or project files in the
  current directory and invokes the MsBuild command on the first found solution
  or project. Solutions take precedence over C# projects which take precedence
  over C++ projects which come before C projects.

  This function supports building in Debug or Release mode on x86 or x64 platforms.
  Permissible targets are Clean, Build or Rebuild.

.PARAMETER Target
  Specifies the build target, either Clean, Build or Rebuild.

.PARAMETER Configuration
  Specifies the build configuration, eihter Debug or Release.

.PARAMETER Platform
  Specifies the platform to build for.

.EXAMPLE
  PS > Invoke-MsBuildHere
  Performs a debug rebuild for the first found solution for the
  host platform.

.EXAMPLE
  PS > Invoke-MsBuildHere -C Release -T Clean -P amd64
  Clears the last release build on a x64 platform.

.LINK
  Invoke-MsBuild
#>

function Invoke-MsBuildHere
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true, Mandatory=$false)]
    [Alias("T")]
    [String]
    [ValidateSet("Clean", "Build", "Rebuild")]
    $Target = 'Rebuild',
    [Parameter(Position=1, ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true, Mandatory=$false)]
    [Alias("Config","C")]
    [String]
    [ValidateSet("Debug", "Release")]
    $Configuration = "Debug",
    [Parameter(Position=2, ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true, Mandatory=$false)]
    [Alias("Arch","P")]
    [String]
    [ValidateSet("x86","win32", "x64", "amd64", "x86_64", "win64")]
    $Platform = $(if( [intptr]::size -eq 8) {'x64'} else {'x86'})
  )

  begin
  {
    if(!(Get-Command -Name Invoke-MsBuild)) {
      Write-Error "Missing required command `'Invoke-MsBuild`'."
      return
    }
  }

  process
  {
    $_types = @('*.proj','*.sln', '*.csproj', '*.vcxproj', '*.vcproj')

    foreach($type in $_types) {
      $_inputs = @(Get-ChildItem (".\" + $type))
      if($_inputs.Count -gt 0) {
        break
      }
    }
    $_input = ($_inputs[0]).Name
    if([string]::IsNullOrEmpty($_input)) {
      Write-Error "No suitable input found. Supported types are: $_types."
      return
    }
    Write-Output "Building solution or project `'$_input`'..."

    switch -regex ($Platform) {
      'x86|win32' {
        $_platform = 'x86'
      }
      'x64|amd64|x86_64|win64' {
        $_platform = 'x64'
      }
      default {
       $_platform = 'x64'
      }
    }

    switch -regex ($Target) {
      'Clean' {
        $_target = 'Clean'
      }
      'Build' {
        $_target = 'Build'
      }
      'Rebuild' {
        $_target = 'Clean,Build'
      }
      default {
       $_target = 'Clean;Build'
      }
    }

    $_params = "/target:$_target /property:Configuration=$Configuration;Platform=$_platform;BuildInParallel=true /maxcpucount"

    Write-Verbose "Building with `'$($_params))`'."

    $_result = Invoke-MsBuild -Path $_input -BuildLogDirectoryPath (Get-Location | Convert-Path) `
    -MsBuildParameters $_params

    if($_result.BuildSucceeded -eq $true) {
      Write-Output "Build succeeded."
    }
    elseif($_result.BuildSucceeded -eq $false) {
      Write-Output "Build FAILED. Check the build log $($_result.BuildLogFilePath) for details."
    }
    else {
      if([string]::IsNullOrEmpty($_result.Message)) {
        Write-Output "Build completed with unspecified error."
      }
      else {
        Write-Output "Build: $($_result.Message)"
      }
    }
  }
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUb5qgbdPVC1r59dCTIU1tu0MI
# dAmgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBS8tinX7a7GXymaxdczRZX/5IbeBTANBgkqhkiG
# 9w0BAQEFAASBgJf3g7dGpT2DNHFaL4voPbitogU7arzEFORP70OAZQVqrAISo9dk
# kM/PYxZZZ5/9eyfGGCUQ0B13OPVZUQxOJRvsT9vPttLs0+XAIlZZ547DtzCPH5cJ
# WxGC692EyRFtrOMmdNxB37QAAKdm52x3Js3186jOadbXZVSK+z5kOPVP
# SIG # End signature block
