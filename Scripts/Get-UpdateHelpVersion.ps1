################################################################################
#
# Get-UpdateHelpVersion
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Gets update information about help on modules.

.DESCRIPTION
  The Get-UpdateHelpVersion script checks for updates of module help information
  and returns the modules and help version of more recent module help.

.PARAMETER Module
  Specifies the module for which to retrieve update information.

.SYNTAX

.EXAMPLE
  PS > Get-UpdateHelpVersion ISE
  Retrieves update information on ISE help.

.LINK

#>

function Get-UpdateHelpVersion
{
	[CmdletBinding()]
	param(
		[parameter(Mandatory=$False)]
		[String[]] $Module
	)

	process {
		$HelpInfoNamespace = @{helpInfo="http://schemas.microsoft.com/powershell/help/2010/05"}

		if($Module) {
		  $Modules = Get-Module $Module -ListAvailable | where {$_.HelpInfoUri}
    }
    else {
	    $Modules = Get-Module -ListAvailable | where {$_.HelpInfoUri}
    }

    foreach($mModule in $Modules) {
      $mDir = $mModule.ModuleBase

      if(Test-Path $mdir\*helpinfo.xml) {
	  	  $mName=$mModule.Name
		    $mNodes = dir $mdir\*helpinfo.xml -ErrorAction SilentlyContinue | Select-Xml -Namespace $HelpInfoNamespace -XPath "//helpInfo:UICulture"
        foreach($mNode in $mNodes) {
			    $mCulture=$mNode.Node.UICultureName
          $mVer=$mNode.Node.UICultureVersion

          [PSCustomObject]@{"ModuleName"=$mName; "Culture"=$mCulture; "Version"=$mVer}
        }
      }
    }
  }
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyAaITMdojw0b0rtQoIlnIVPZ
# 0ECgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRis6SdpKRrf2YT9a39b2c2Qg8sXzANBgkqhkiG
# 9w0BAQEFAASBgGGUm6EOF+2t2/i3iiFXFcN+ztmwtZsL36nK5IYb1xny95aONL4k
# SoafaMBhg5yiQHAZSf9dIE4RtaRUtp0SZP2TYQNE9Rt3AMf40z8GWtzaOmLzn0ZA
# UiXUJ1FHjYaidBoJhrqdIRDM6m3sUwgKepTYTr0boyDByS2jQeN/xxbh
# SIG # End signature block
