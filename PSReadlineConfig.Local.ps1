################################################################################
#
# Configure PSReadline settings
#
# Copyright (c) 2015-2016 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
################################################################################

# Other hosts don't work so well
if ($host.Name -ne 'ConsoleHost' -or !(Get-Module -Name PSReadline)) { return }

#region General

# Make a 'sane' decision if available
if((Get-Module PSReadline).Version -ge "1.2") {
  Set-PSReadlineOption -EditMode "Vi"
  Set-PSReadlineOption -ViModeIndicator Cursor
}
else {
  Write-Warning "Vi mode not supported. Reverting to default mode.`nPlease, upgrade `'PSReadline`' version to 1.2 or higher."
}

#endregion

#region Visual
if((Get-Module PSReadline).Version -ge "2.0") {
  Set-PSReadlineOption -Colors @{
    Comment   = 'DarkGray'
    String    = 'Green'
    Number    = 'DarkYellow'
    Type      = 'Yellow'
    Operator  = 'Cyan'
    Member    = 'DarkBlue'
    Variable  = 'Red'
    Keyword   = 'Magenta'
    Command   = 'Blue'
    Parameter = 'Cyan'
    Error     = 'DarkRed'
    #ContinuationPrompt = ''
  }
}
else {
  Set-PSReadlineOption -TokenKind Comment -ForegroundColor DarkGray
  Set-PSReadlineOption -TokenKind String -ForegroundColor Green
  Set-PSReadlineOption -TokenKind Number -ForegroundColor DarkYellow
  Set-PSReadlineOption -TokenKind Type -ForegroundColor Yellow
  Set-PSReadlineOption -TokenKind Operator -ForegroundColor Cyan
  Set-PSReadlineOption -TokenKind Member -ForegroundColor DarkBlue
  Set-PSReadlineOption -TokenKind Variable -ForegroundColor Red
  Set-PSReadlineOption -TokenKind Keyword -ForegroundColor Magenta
  Set-PSReadlineOption -TokenKind Command -ForegroundColor Blue 
  Set-PSReadlineOption -TokenKind Parameter -ForegroundColor Cyan
  Set-PSReadlineOption -ErrorForegroundColor DarkRed
}

# Don't be a nuisance
Set-PSReadlineOption -BellStyle Visual

#endregion

#region History
Set-PSReadlineOption
Set-PSReadlineOption -MaximumHistoryCount 4096 `
  -HistorySearchCursorMovesToEnd `
  -HistoryNoDuplicates `
  -HistorySavePath (Join-Path $env:APPDATA -ChildPath "Microsoft\Windows\PowerShell\console_history.txt")

Set-PSReadlineOption -AddToHistoryHandler {
  param([string]$line)
  return $line.Length -gt 3
}

# Fix bug Vi mode not honoring HistorySearchCursorMovesToEnd
# Vi command mode j,k follow default Emacs behavior where cursor is placed where left
Set-PSReadlineKeyHandler -Key UpArrow `
  -BriefDescription PreviousHistory `
  -LongDescription 'Replace the input with the previous item in the history' `
  -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::PreviousHistory()
  [Microsoft.PowerShell.PSConsoleReadLine]::MoveToEndOfLine()
}

Set-PSReadlineKeyHandler -Key DownArrow `
  -BriefDescription NextHistory `
  -LongDescription 'Replace the input with the next item in the history' `
  -ScriptBlock {
  [Microsoft.PowerShell.PSConsoleReadLine]::NextHistory()
  [Microsoft.PowerShell.PSConsoleReadLine]::MoveToEndOfLine()
}

# It also clears the line with RevertLine so the undo stack is reset,
# though redo will still reconstruct the command line.
# Mnemonic: _S_napshot / _S_tash
Set-PSReadlineKeyHandler -Key Alt+s `
  -BriefDescription SaveInHistory `
  -LongDescription "Save current line in history but do not execute" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
  [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

# This key handler shows the entire or filtered history using Out-GridView. The
# typed text is used as the substring pattern for filtering. A selected command
# is inserted to the command line without invoking. Multiple command selection
# is supported, e.g. selected by Ctrl + Click.
Set-PSReadlineKeyHandler -Key F8 `
  -BriefDescription History `
  -LongDescription 'Show command history' `
  -ScriptBlock {
  $pattern = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
  if ($pattern) {
    $pattern = [regex]::Escape($pattern)
  }

  $history = [System.Collections.ArrayList]@(
    $last = ''
    $lines = ''
    foreach ($line in [System.IO.File]::ReadLines((Get-PSReadlineOption).HistorySavePath)) {
      if ($line.EndsWith('`')) {
        $line = $line.Substring(0, $line.Length - 1)
        $lines = if ($lines) {
          "$lines`n$line"
        }
        else {
          $line
        }
        continue
      }

      if ($lines) {
        $line = "$lines`n$line"
        $lines = ''
      }

      if (($line -cne $last) -and (!$pattern -or ($line -match $pattern))) {
        $last = $line
        $line
      }
    }
  )
  $history.Reverse()
  $command = $history | Out-GridView -Title History -PassThru
  if ($command) {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
  }
}

#endregion

#region Smart copy/paste

# Insert text from the clipboard as a here string
Set-PSReadlineKeyHandler -Key Ctrl+Shift+v `
  -BriefDescription PasteAsHereString `
  -LongDescription "Paste the clipboard text as a here string" `
  -ScriptBlock {
  param($key, $arg)

  Add-Type -Assembly PresentationCore
  if ([System.Windows.Clipboard]::ContainsText()) {
    # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
    $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n", "`n").TrimEnd()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
  }
  else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
  }
}

# Copy working directory to clipboard
# Mnemonic:_W_orking directory
Set-PSReadlineKeyHandler -Key Alt+w `
  -BriefDescription CopyWorkingDirectoryToClipboard `
  -LongDescription "Copy the working directory to the clipboard" `
  -ScriptBlock {
  Add-Type -Assembly PresentationCore
  [System.Windows.Clipboard]::SetText($pwd.Path, 'Text')
}

#endregion

#region Text objects

# Smart insertion of braces/parens, quotation marks
Set-PSReadlineKeyHandler -Key '"', "'" `
  -BriefDescription SmartInsertQuote `
  -LongDescription "Insert paired quotes if not already on a quote" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($line[$cursor] -eq $key.KeyChar) {
    # Just move the cursor
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  }
  else {
    # Insert matching quotes, move cursor to be in between the quotes
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
  }
}

Set-PSReadlineKeyHandler -Key '(', '{', '[' `
  -BriefDescription InsertPairedBraces `
  -LongDescription "Insert matching braces" `
  -ScriptBlock {
  param($key, $arg)

  $closeChar = switch ($key.KeyChar) {
    <#case#> '(' { [char]')'; break }
    <#case#> '{' { [char]'}'; break }
    <#case#> '[' { [char]']'; break }
  }

  [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
}

Set-PSReadlineKeyHandler -Key ')', ']', '}' `
  -BriefDescription SmartCloseBraces `
  -LongDescription "Insert closing brace or skip" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($line[$cursor] -eq $key.KeyChar) {
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
  }
  else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
  }
}

# Smart deletion handling matching quotes and backspaces
Set-PSReadlineKeyHandler -Key Backspace `
  -BriefDescription SmartBackspace `
  -LongDescription "Delete previous character or matching quotes/parens/braces" `
  -ScriptBlock {
  param($key, $arg)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

  if ($cursor -gt 0) {
    $toMatch = $null
    if ($cursor -lt $line.Length) {
      switch ($line[$cursor]) {
        <#case#> '"' { $toMatch = '"'; break }
        <#case#> "'" { $toMatch = "'"; break }
        <#case#> ')' { $toMatch = '('; break }
        <#case#> ']' { $toMatch = '['; break }
        <#case#> '}' { $toMatch = '{'; break }
      }
    }

    if ($toMatch -ne $null -and $line[$cursor - 1] -eq $toMatch) {
      [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
    }
    else {
      [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
    }
  }
}

# Sometimes you want to get a property of invoke a member on what you've entered so far
# but you need parens to do that.  This binding will help by putting parens around the current selection,
# or if nothing is selected, the whole line.
Set-PSReadlineKeyHandler -Key 'Alt+(' `
  -BriefDescription ParenthesizeSelection `
  -LongDescription "Put parenthesis around the selection or entire line and move the cursor to after the closing parenthesis" `
  -ScriptBlock {
  param($key, $arg)

  $selectionStart = $null
  $selectionLength = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)

  $line = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
  if ($selectionStart -ne -1) {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, '(' + $line.SubString($selectionStart, $selectionLength) + ')')
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
  }
  else {
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, $line.Length, '(' + $line + ')')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
  }
}

# Change the token under or before the cursor, cycling through single quotes, double quotes,
# or no quotes each time it is invoked.
Set-PSReadlineKeyHandler -Key "Alt+'" `
  -BriefDescription ToggleQuoteArgument `
  -LongDescription "Toggle quotes on the argument under the cursor" `
  -ScriptBlock {
  param($key, $arg)

  $ast = $null
  $tokens = $null
  $errors = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

  $tokenToChange = $null
  foreach ($token in $tokens) {
    $extent = $token.Extent
    if ($extent.StartOffset -le $cursor -and $extent.EndOffset -ge $cursor) {
      $tokenToChange = $token

      # If the cursor is at the end (it's really 1 past the end) of the previous token,
      # we only want to change the previous token if there is no token under the cursor
      if ($extent.EndOffset -eq $cursor -and $foreach.MoveNext()) {
        $nextToken = $foreach.Current
        if ($nextToken.Extent.StartOffset -eq $cursor) {
          $tokenToChange = $nextToken
        }
      }
      break
    }
  }

  if ($tokenToChange -ne $null) {
    $extent = $tokenToChange.Extent
    $tokenText = $extent.Text
    if ($tokenText[0] -eq '"' -and $tokenText[-1] -eq '"') {
      # Switch to no quotes
      $replacement = $tokenText.Substring(1, $tokenText.Length - 2)
    }
    elseif ($tokenText[0] -eq "'" -and $tokenText[-1] -eq "'") {
      # Switch to double quotes
      $replacement = '"' + $tokenText.Substring(1, $tokenText.Length - 2) + '"'
    }
    else {
      # Add single quotes
      $replacement = "'" + $tokenText + "'"
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
      $extent.StartOffset,
      $tokenText.Length,
      $replacement)
  }
}

#endregion

#region Tools

# Capture screen; mnemonic _D_isplay _C_apture
Set-PSReadlineKeyHandler -Chord 'Ctrl+D,Ctrl+C' -Function CaptureScreen

# Replace any aliases on the command line with the resolved commands.
# Mnemonic: _E_xpand alias
Set-PSReadlineKeyHandler -Key Alt+e `
  -BriefDescription ExpandAliases `
  -LongDescription "Replace all aliases with the full command" `
  -ScriptBlock {
  param($key, $arg)

  $ast = $null
  $tokens = $null
  $errors = $null
  $cursor = $null
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

  $startAdjustment = 0
  foreach ($token in $tokens) {
    if ($token.TokenFlags -band [System.Management.Automation.Language.TokenFlags]::CommandName) {
      $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
      if ($alias -ne $null) {
        $resolvedCommand = $alias.ResolvedCommandName
        if ($resolvedCommand -ne $null) {
          $extent = $token.Extent
          $length = $extent.EndOffset - $extent.StartOffset
          [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $extent.StartOffset + $startAdjustment,
            $length,
            $resolvedCommand)

          # Our copy of the tokens won't have been updated, so we need to
          # adjust by the difference in length
          $startAdjustment += ($resolvedCommand.Length - $length)
        }
      }
    }
  }
}

# Mark, yank, and jump current directory
# Ctrl+Shift+j then type a key to mark the current directory.
# Ctrl+j with the same key will change back to that directory without
# needing to type cd and won't change the command line.

$global:PSReadlineMarks = @{ }

Set-PSReadlineKeyHandler -Key Ctrl+Shift+j `
  -BriefDescription MarkDirectory `
  -LongDescription "Mark the current directory" `
  -ScriptBlock {
  param($key, $arg)

  $key = [Console]::ReadKey($true)
  $global:PSReadlineMarks[$key.KeyChar] = $pwd
}

Set-PSReadlineKeyHandler -Key Ctrl+j `
  -BriefDescription JumpDirectory `
  -LongDescription "Goto the marked directory" `
  -ScriptBlock {
  param($key, $arg)

  $key = [Console]::ReadKey()
  $dir = $global:PSReadlineMarks[$key.KeyChar]
  if ($dir) {
    Set-Location $dir
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  }
}

# Build current directory
#Set-PSReadlineKeyHandler -Key F7 `
#-BriefDescription BuildDirectory `
#-LongDescription "Build project in current directory" `
#                         -ScriptBlock {
#  param($key, $arg)

#  # FIXME output of function garbles command line
#  $command = Invoke-MsBuildHere -Target Rebuild | Out-File out.log | Get-Content
#  if ($command) {
#    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command))
#    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
#    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
#  }
#}

#endregion

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUVycdUbVL0Gtvvpp8b+kroTsA
# hp+gggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRdrRTLIRUw4o8AR/RxxR13FzfuezANBgkqhkiG
# 9w0BAQEFAASBgG+zd7D312ObCiJdw0AP97waZAlUGnPvuWJCfgbpXhWalx63IXps
# oahcleDy3O9Xq08rK/VZwWpqaVvhUsIDx6jp+4WGi3FGB4MqaZ+kz92GkwOiL73a
# 9nJVbzn+uQ3bPjHrQmWNwvaJLSC54kDFuCdtVPicYKuzqWbFQ+M2DCFr
# SIG # End signature block
