################################################################################
#
# Configure PoshGit (https://github.com/dahlbyk/posh-git/)
#
# Copyright (c) 2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

# Requires posh-git v1.x
if (!$global:GitPromptSettings) { return }

# title, leave as is
$global:GitPromptSettings.WindowTitle = ''

# Configure prompt
# prefix: username@computername:
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $global:GitPromptSettings.DefaultPromptPrefix.Text = `
        "`e[32m$env:USERNAME`e[90m@`e[35m$env:COMPUTERNAME``e[90m:"
} else {
    $aesc = [char]27 + "["
    $global:GitPromptSettings.DefaultPromptPrefix.Text = `
        "$($aesc)32m$env:USERNAME$($aesc)90m@$($aesc)35m$env:COMPUTERNAME$($aesc)90m:"
}
# path
$global:GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
$global:GitPromptSettings.DefaultPromptPath.ForegroundColor = [System.ConsoleColor]::DarkYellow

# delimiter
$global:GitPromptSettings.BeforeStatus.ForegroundColor = [System.ConsoleColor]::White
$global:GitPromptSettings.DelimStatus.ForegroundColor = [System.ConsoleColor]::White
$global:GitPromptSettings.AfterStatus.ForegroundColor = [System.ConsoleColor]::White
# working tree
$global:GitPromptSettings.WorkingColor.ForegroundColor = [System.ConsoleColor]::DarkRed
# index
$global:GitPromptSettings.IndexColor.ForegroundColor = [System.ConsoleColor]::DarkYellow
# stash
$global:GitPromptSettings.StashColor.ForegroundColor = [System.ConsoleColor]::DarkMagenta
$global:GitPromptSettings.BeforeStash.ForegroundColor = [System.ConsoleColor]::DarkMagenta
$global:GitPromptSettings.AfterStash.ForegroundColor = [System.ConsoleColor]::DarkMagenta

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6xwFF7hat+64cvjm6upQShVM
# uCigggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBR7N2PWHsh9GdrqK/yD+ER2p4q3dTANBgkqhkiG
# 9w0BAQEFAASBgBlyBITc/Gi5+LhQeghn5eEiksfuTeNIP+lFRPGRfh/NjrUCUz3P
# XPcZTwPAAkdANG11yIYR6+Znd499o0eybgEnko5rZwPjQZex0VAO+dyIayVxkKES
# NoJsa8gfY+Ny3CUU5ISIOpnKksslkO0Yl0Rjg82AE3Fsvw7gUsDChsog
# SIG # End signature block
