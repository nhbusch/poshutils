################################################################################
#
# Configure PowerShell console settings
#
# Copyright (c) 2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

# Sets console settings
function Set-ConsoleConfig {
    $restore = $Host.UI.RawUI
    $console = $Host.UI.RawUI

    try {
        # Modify cursor
        $console.CursorSize = 12

        # Modify special property objects
        $buffer_size = $console.BufferSize
        $buffer_size.Width = 120
        $buffer_size.Height = 300
        $console.BufferSize = $buffer_size

        $size = $console.WindowSize
        $size.Width = 120
        $size.Height = 50
        $console.WindowSize = $size
    } catch [System.Management.Automation.SetValueInvocationException] {
        $console = $restore
    }

    # For dark color scheme
    $Host.PrivateData.DebugBackgroundColor = "Black"
    $Host.PrivateData.ErrorBackgroundColor = "Black"
    $Host.PrivateData.WarningForegroundColor = "DarkRed"
}

Set-ConsoleConfig
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU3w/FiFxis1RHax2GYuuEF4Nr
# 9vigggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBQ7GA57pWNgXh0r0yRcCbr4LbtaWzANBgkqhkiG
# 9w0BAQEFAASBgDGA9kFF722uKHI1iOry16lMyVcvxqmwon07RKaCAR+AVKsragJX
# /4Xq3vd8RF663E4+V7EaTsX4/DVWewiHmn2WjUEwwsfhtZnliajvFUs88mx8Eujm
# dlWyNKUn8LRZiVFPNS7eDm6weynPkyH3O4rOoy0AU6BYMB9NJoHP1l+2
# SIG # End signature block
