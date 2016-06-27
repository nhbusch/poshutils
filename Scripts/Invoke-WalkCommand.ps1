################################################################################
#
# Invoke-WalkCommand
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Invokes command recursively on child directories. 

.DESCRIPTION
  The Invoke-WalkCommand function executes a command or script block
  recursively on all sub-directories below Path. 

.PARAMETER Command
  Specifies the command or script block to execute.
  The argument must be properly enclosed in curly braces to be
  recognized as a script block.

.PARAMETER Path
  Specifies the parent directory from where to descend.
  The default location is the current directory.

.EXAMPLE
  PS > Invoke-WalkCommand {pwd} C:\path\to\my\files
  Lists all direct child directories of 'C:\path\to\my\files'.
  
.EXAMPLE
  PS > Invoke-WalkCommand { msbuild /t:clean }
  Cleans all projects in current directory and below.

.EXAMPLE
  PS > Invoke-WalkCommand -Command { Invoke-WalkCommand {pwd} }
  Lists all child directories and their children of current directory.
  
.LINK
  Invoke-Command
#>

function Invoke-WalkCommand 
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true, 
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [ScriptBlock]
	  [ValidateNotNullOrEmpty()]
	  $Command,
	  [Parameter(Position=1, ValueFromPipeline=$true, 
     ValueFromPipelineByPropertyName=$true, Mandatory=$false)]
    [String]
	  [ValidateNotNullOrEmpty()]
	  $Path = (Get-Location)
  )

  process 
  {
    if(!(Test-Path -Path $Path -PathType Container)) {
      throw New-Object System.IO.DirectoryNotFoundException("Path does not exist.")
    }

    # walk down child directories and have script operate on each in turn
    Get-ChildItem -Directory $Path | ForEach-Object {
      if($PSCmdlet.ShouldProcess($_, $Command)) {
        Push-Location (Join-Path $Path $_)

        #Write-Verbose "Applying `'$Command`' on `'$_`'"     
        & $Command # FIXME: Invoke-Command -ScriptBlock ?

        Pop-Location
      }
    }
  }  
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUYQTskim9C30oLYzCsSNQMTyF
# HXCgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBQ8dsUSinpxtPSyeP/xKPVCO6w7QzANBgkqhkiG
# 9w0BAQEFAASBgItlSwEP667I0leDjnPNLcX5Vj0QI0q2ZZZ9O7D4qn60hesFbbNq
# O2Am411BukViP9vbwwyqzay4tIGPmDZQMzFZvWlIgmRbkltMvexTEEhW4IG6ivkJ
# 5J1DaGyqwX3t1j2pR/i0VjNPa187Zms5hx0AZ9Wp8qkAmDdq3CYp6da6
# SIG # End signature block
