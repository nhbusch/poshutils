###########################################################################
#
# Add-Signature
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
  Signs a file. 

.DESCRIPTION
  The Add-Signature script signs a script file using the code-signing
  certificate of the current user.

.PARAMETER File
  Specifies the script file to sign.

.SYNTAX

.EXAMPLE
  PS > Add-Signature foo.txt
  Signs file foo.txt.
  
.LINK
  Set-AuthenticodeSignature

#>

function Add-Signature 
{
  [CmdletBinding()]
  param(
      [Parameter(Position=0, ValueFromPipeline=$true, 
       ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
      [String] $File
  )


  process 
  {
    $_cert = @(Get-ChildItem cert:\CurrentUser\My -codesigning)[0]
    Set-AuthenticodeSignature $File $_cert
  }
}

# SIG # Begin signature block
# MIIFzAYJKoZIhvcNAQcCoIIFvTCCBbkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1mJvI5PSVrI5b0lcLW9zZBIv
# UM+gggNVMIIDUTCCAj2gAwIBAgIQxav5BGIa87tCfotcMg3zUzAJBgUrDgMCHQUA
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
# AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBQ6g1r8NxEv
# qzI0wbb+gu04mmGKQTANBgkqhkiG9w0BAQEFAASCAQAwvSEms4+u0Vxv3cHdjCAA
# qJz74pt2oKTtSkCFcFwSFmn4noP1P1JCrX7Yr0mn6zvs5s8CbsOnHxzKknzD/bK3
# 7+MDgScZIvW8FCfn8vJusYyl9M2krmT0NR2n8Ysbnbb8Y8WfeOEDzsSE+khHOv0I
# SgnbLAUjDz08p/3TpaB3AadHpSd+n5fyGkP3wXidZLShL+w9aIcZ1K/H4q1SAZwh
# KMck+yfezXaEu37a57G5x+dyZbW8FmqrccZw3nf4Hg7GxoXfp3pz/kfyU0Pk4Y2c
# hjE8Gg3e+5OJh9P94O575SYAKrN4ixRfCbmCcJAxTpQ9PIrF+eWds2I4dElYJSrt
# SIG # End signature block
