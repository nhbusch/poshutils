################################################################################
#
# Configure PSColor settings
#
# Copyright (c) 2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

# Other hosts don't work so well
if ($host.Name -ne 'ConsoleHost' -or !(Get-Module -Name PSColor)) { return }

# Configure colors and extensions
$global:PSColor = @{
  File = @{
      Default    = @{ Color = 'DarkBlue' }
      Directory  = @{ Color = 'Blue'}
      Hidden     = @{ Color = 'DarkGreen'; Pattern = '^\.' }
      Code       = @{ Color = 'Yellow'; Pattern = '\.(java|c|cpp|cs|js|css|html|m|rust|hs|vim)$' }
      Executable = @{ Color = 'Green'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$' }
      Text       = @{ Color = 'DarkCyan'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown|json)$' }
      Compressed = @{ Color = 'Cyan'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
  }
  Service = @{
      Default = @{ Color = 'DarkBlue' }
      Running = @{ Color = 'Green' }
      Stopped = @{ Color = 'DarkRed' }
  }
  Match = @{
      Default    = @{ Color = 'Magenta' }
      Path       = @{ Color = 'DarkMagenta'}
      LineNumber = @{ Color = 'Gray' }
      Line       = @{ Color = 'DarkBlue' }
  }
}
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0qVqLN5KFgdB8+LyMei8YqpS
# C+CgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBQL45W0NMpHiBDJJM7+EFjhfCxq5TANBgkqhkiG
# 9w0BAQEFAASBgCRKR6/kHsvALN/mj94kqwn8lY6Ub0GefdgDZ0JFM3vK5W5pdM4F
# V0NEFjeGBnDG9sso+9fto2+BAOg3cpnIoHfEJkr7uIqSwtHQIwoR5JL5267OpUiS
# PQAd+fujSqjuZhUND3tIkD//BOVt9H5yqldczaXWZbGJ0KDphk4Xb2v7
# SIG # End signature block
