###########################################################################
#
# Powershell profile for current user on current host
#
# Copyright (c) 2014 Nils H. Busch. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###########################################################################

# Customize PowerShell console host
(Get-Host).UI.RawUI.WindowTitle = `
  "Windows PowerShell [$env:USERDOMAIN\$env:USERNAME@$env:COMPUTERNAME]"

# Customize prompt; disabled as posh-git customizes the prompt
#function prompt
#{
#	$loc = $($executionContext.SessionState.Path.CurrentLocation).Path
#  $loc.replace("$env:USERPROFILE",'~') + "$('>' * ($nestedPromptLevel + 1)) "
#}