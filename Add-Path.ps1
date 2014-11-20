###########################################################################
#
# Add-Path
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
  Adds path to system path. 

.DESCRIPTION
  The Add-Path function appends a path to the system path for the current
  session. The path will be added only if it is not already in the list of
  system paths.

  The path will be added permanently if the Permanent flag is set.

  The path will be appended (default) or prepended depending on the
  Prepend flag.

.PARAMETER Path
  Specifies the path to add.

.PARAMETER Permanent
  Specifies whether to add the path permanently.

.PARAMETER Prepend
  Specifies whether to add the path to the beginning or end of list.

.EXAMPLE
  PS > Add-Path C:\path\to\my\files 
  Adds the directory 'C:\path\to\my\files' to the list of system paths for the
  current process.

.EXAMPLE
  PS > Add-Path -Path C:\path\to\my\files -Permanent -Prepend
  Prepends the directory 'C:\path\to\my\files' permanently to the list of system 
  paths.
  
.LINK

#>

function Add-Path 
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true, 
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [String]
	  [ValidateNotNullOrEmpty()]
	  $Path,
	  [Parameter(ValueFromPipeline=$false, 
     ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
    [Switch] 
	  $Permanent,
    [Parameter(ValueFromPipeline=$false, 
     ValueFromPipelineByPropertyName=$false, Mandatory=$false)]
    [Switch] 
	  $Prepend
  )

  process 
  {
    if (!(Test-Path -Path $Path -PathType Container))
    {
      throw New-Object System.IO.DirectoryNotFoundException("Path does not exist. Nothing will be added.")
    }

    # query current search path
    $_current = [System.Environment]::GetEnvironmentVariable("path")

    # add only if not already present, warn otherwise
    if($_current | Select-String -SimpleMatch $Path) {
      Write-Warning "The path `'$Path`' is already part of the system path."
    }
    else {
      # add backslash
      if(!($Path[-1] -match '\\')) { 
        $Path = $Path + '\'
      }
      Write-Verbose "Adding path `'$Path`' to system path."

      if($Prepend) {
        $_new = $Path + ';' + $_current
      }
      else {
        $_new = $_current + ';' + $Path
      }

      if($PSCmdlet.ShouldProcess($Path)) {
        if($Permanent) {
          [System.Environment]::SetEnvironmentVariable("path",$_new,'Machine')
        }
        else {
          [System.Environment]::SetEnvironmentVariable("path",$_new)
        }
      }
    }
  }

  end 
  {
    return $_new
  }
}
# SIG # Begin signature block
# MIIFzAYJKoZIhvcNAQcCoIIFvTCCBbkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUU0M7XXI1iVzL+Dwu6zZzH9DQ
# pLugggNVMIIDUTCCAj2gAwIBAgIQxav5BGIa87tCfotcMg3zUzAJBgUrDgMCHQUA
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
# AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQtWMTkGcN6
# 4xBmt75T68r5sUoOKjANBgkqhkiG9w0BAQEFAASCAQC51wGiEh7tw0DLl2/6OxEc
# 5P6I6vSBb87/xEEUIVe9ejPa04dcFrlSabbbT6nqfklKe+bFr/GkgoKGduTJKzNg
# eaS2+feiHKwTPwrkScg9P17ZcKiHTRTM/NwcFgu27Doxs0mmLdjE2GF+3ZzCCRip
# HC7CPbZ/fX0RI55ETcpKKA7h/hN7e8Xro0vTPlVRZDJ0q0bZ8zbnVYKmegrQy90G
# d1dC2d7SITc82rB1MzptEsmSe0wfyD4v0JcLyNasazigKfK2+USFeIkqbacJhcH4
# CemwM1EvSHxarPZjujG2Or00Ct+WIkDIBxxcaAsy4YGmnSWqv4h3uznsReng8r3H
# SIG # End signature block
