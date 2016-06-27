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

if (!$Global:GitPromptSettings) { return }

# Configure prompt
$Global:GitPromptSettings.BeforeForegroundColor=[ConsoleColor]::DarkYellow
$Global:GitPromptSettings.AfterForegroundColor=[ConsoleColor]::DarkYellow
$Global:GitPromptSettings.DelimForegroundColor=[ConsoleColor]::DarkYellow
$Global:GitPromptSettings.IndexForegroundColor=[ConsoleColor]::Gray
$Global:GitPromptSettings.WorkingForegroundColor=[ConsoleColor]::DarkRed # DarkGreen
$Global:GitPromptSettings.UntrackedForegroundColor=[ConsoleColor]::DarkRed # Obsolete in 1.2
#$Global:GitPromptSettings.LocalDefaultForegroundColor=[ConsoleColor]::DarkGreen 
#$Global:GitPromptSettings.LocalWorkingForegroundColor=[ConsoleColor]::DarkRed  # White?
#$Global:GitPromptSettings.LocalStagedForegroundColor=[ConsoleColor]::Cyan
#$Global:GitPromptSettings.StashForegroundColor=[ConsoleColor]::Red 

# Configure title
$Global:GitPromptSettings.EnableWindowTitle="Git [$env:USERDOMAIN\$env:USERNAME@$env:COMPUTERNAME]: "