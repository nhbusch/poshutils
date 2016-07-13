################################################################################
#
# Get-CmdletAlias
#
# Copyright (c) 2014-2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

<#
.SYNOPSIS
  Gets the alias for a cmdlet.

.DESCRIPTION
  The Get-CmdletAlias function returns the alias name of the cmdlet argument.

.PARAMETER Name
  Specifies the cmdlet.

.EXAMPLE
  PS > Set-Alias -Name gh -Value Get-Help
  PS > Get-CmdletAlias Get-Help
  Returns the alias 'gh'.
  
.LINK
  Get-Alias
#>

function Get-CmdletAlias
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param(
    [Parameter(Position=0, ValueFromPipeline=$true, 
     ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    [String]
	  [ValidateNotNullOrEmpty()]
	  $Name
  )

  process 
  {
    Get-Alias | where {$_.definition -like "*$Name*"} | Format-Table `
     Definition, Name -auto
  }

}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUHsAuKPVSsYn3+bz2J+/Qz/Fw
# 2t6gggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBSFwJRMLy7TguAAAa1j7bC4hCExwTANBgkqhkiG
# 9w0BAQEFAASBgKEHDY4fkQLm2LP407cKwIRFz2VAdbGtajzAvr1lA8UEsUlR6KN9
# 09j2FYxLtjunOeCKIYyWl5OijzE9St9HXsxYiX0ee0OjDj1JgcXzMR//2ruHv8CP
# GXw0ywQk0bRxVaWzxAbW9Y/NsAgC0HPLf1sNOW88wa/+Eg0UEDfzJ2yq
# SIG # End signature block
