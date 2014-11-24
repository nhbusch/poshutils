###############################################################################
#
# Get-UpdateHelpVersion
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
###############################################################################

Param
(
  [parameter(Mandatory=$False)]
  [String[]]
  $Module
)      
$HelpInfoNamespace = @{helpInfo="http://schemas.microsoft.com/powershell/help/2010/05"}

if($Module) 
{ 
	$Modules = Get-Module $Module -ListAvailable | where {$_.HelpInfoUri} 
}
else 
{ 
	$Modules = Get-Module -ListAvailable | where {$_.HelpInfoUri} 
}

foreach($mModule in $Modules)
{
  $mDir = $mModule.ModuleBase

  if(Test-Path $mdir\*helpinfo.xml)
  {
		$mName=$mModule.Name
		$mNodes = dir $mdir\*helpinfo.xml -ErrorAction SilentlyContinue | Select-Xml -Namespace $HelpInfoNamespace -XPath "//helpInfo:UICulture"
    foreach($mNode in $mNodes)
    {
			$mCulture=$mNode.Node.UICultureName
      $mVer=$mNode.Node.UICultureVersion
            
      [PSCustomObject]@{"ModuleName"=$mName; "Culture"=$mCulture; "Version"=$mVer}
    }
  }
}

# SIG # Begin signature block
# MIIFzAYJKoZIhvcNAQcCoIIFvTCCBbkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4/o0OgCP8h/nH27IDa9EeNeF
# vqqgggNVMIIDUTCCAj2gAwIBAgIQxav5BGIa87tCfotcMg3zUzAJBgUrDgMCHQUA
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
# AQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSGcRXtyqqP
# BNJWiNI//qgDCqgs+zANBgkqhkiG9w0BAQEFAASCAQC/OKWu2gzfcwnPN3Gh9E42
# k+3REPZQJdeGofgiNaPTjiVavmVtY5BylqbwUmgffaPgdzZb/HHVwbiGbjwgl+33
# GE17J/3snBQdW1YlwZlqTCpLSVN2UesIiULRI12ZNzAaJgBM9syGcdLtICGnw0bt
# Li8h3ad5B6yuRPZY4JMGE0debXV8UpBZKq8Y3Pd7rAKbBNIJ4X7H05qkNpXdiL85
# bgVsEkciYlu8OX8D6F/ICWQXgoiJoNgWpBc8lBffgKjxsu+8L375HxcVk6hP3cMk
# YwAH5vZHYxn/ViKoDaB5n4rlP6c3Hi+BV/2WgtVoJBZaoZbY+27xWDl5q1ugxjPa
# SIG # End signature block
