###############################################################################
#
# Powershell profile for current user on current host
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
###############################################################################

# Customize PowerShell console host
(Get-Host).UI.RawUI.WindowTitle = `
  "Windows PowerShell [$env:USERDOMAIN\$env:USERNAME@$env:COMPUTERNAME]"
