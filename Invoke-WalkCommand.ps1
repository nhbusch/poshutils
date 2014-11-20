###########################################################################
#
# Invoke-WalkCommand
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###########################################################################

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
# MIIFzAYJKoZIhvcNAQcCoIIFvTCCBbkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU9wyYH/0JbaWHfcAjGocCffZS
# sqagggNVMIIDUTCCAj2gAwIBAgIQxav5BGIa87tCfotcMg3zUzAJBgUrDgMCHQUA
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
# AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRLOpD+EY9m
# oqhnqxLuY/s7slyDdDANBgkqhkiG9w0BAQEFAASCAQCHM7Q+ODOVvyRNTu9p0Upl
# pUTFQTmCRiF6PVPLLcE6NpvnGBw1tTsFUoWeJgPskKpJ14l8xu/ZOqhl7hnSmBpC
# L5DxEBt68wWcM8h7RRMxGaJp4N5mEO5OG6J8XtySd6OAPZP6MwtY0djb6uxYk8R3
# /nbSMorgqx3Ozxu//7i41LZ2uNxSiMw4qo9kXtCmpghSOVyjYYm1rMdqH3HuFk09
# LwLy/OA7y9bZNuV6OdvH0sev2zLZwmDWVzhF5PmWZ206J/WNZbC+iHEjp68aC1le
# vMbVqDBSbJOC21zQ+ovcH4+pjVjbDm9ole+Sx6JCmwrAIZoJJNQcYrV8fU87d15o
# SIG # End signature block
