# Replicate some of the settings from PSReadlineConfig.Local.ps1
# as some settings mess up commands like ls, pwd

# Internal PowerShell Console comes with PSReadline 2.x
$PSReadLineOptions = @{
    EditMode                      = "Vi"
    ViModeIndicator               = "Cursor"
    HistoryNoDuplicates           = $true
    HistorySearchCursorMovesToEnd = $true
    BellStyle                     = "Visual"
    Colors                        = @{
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
    }
}
Set-PSReadLineOption @PSReadLineOptions