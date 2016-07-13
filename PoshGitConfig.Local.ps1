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
#$Global:GitPromptSettings.BeforeIndexForegroundColor=[ConsoleColor]::Gray
$Global:GitPromptSettings.BeforeStashForegroundColor=[ConsoleColor]::Magenta
$Global:GitPromptSettings.StashForegroundColor=[ConsoleColor]::Magenta 
$Global:GitPromptSettings.AfterStashForegroundColor=[ConsoleColor]::Magenta 
# Configure title
$Global:GitPromptSettings.EnableWindowTitle="Git [$env:USERDOMAIN\$env:USERNAME@$env:COMPUTERNAME]: "