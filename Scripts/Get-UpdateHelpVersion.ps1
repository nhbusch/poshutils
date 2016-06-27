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
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUCyu/DN5KUGbJ44P2ZuHtJZGG
# zi+gggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRSEnybbwybVzn+QQjSjsYKgU25FzANBgkqhkiG
# 9w0BAQEFAASBgDp0HxAO9twOZwCz39Ubb3rEEW+S+M6E3vL42nFkxhsZAnym5V5t
# OJ5DKfIoHD8K50CJ1+y/y44BbhrAWsgUD6NA28i0y8Rb9eq785mh+8/OExyIqkuz
# tKnWr07WDWHA1samT8tN/c2GcKgvSreoCj9G/j6OzhOcJrXEbdUR/vCr
# SIG # End signature block
