################################################################################
#
# The MIT License (MIT)
#
# Copyright (c) 2018 Nils H. Busch
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
################################################################################

<#
.SYNOPSIS
A collection of custom developer tools.
#>


<#
.SYNOPSIS
Clears test output.

.DESCRIPTION
The Clear-TestData function recursively removes all test output directories
below the given root path.

.PARAMETER Path
  Specifies the root path.

.PARAMETER Name
  Specifies the test directory name. Default name is 'TestResults'.

.EXAMPLE
PS > Clear-TestData -Path .\MyRoot -Name "TestResults"
Recursively removes all directories named 'TestResults' below 'MyRoot'.

.LINK
  Remove-Item
#>
function Clear-TestData {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        [Alias("P")]
        [String]
        [ValidateNotNullOrEmpty()]
        $Path,
        [Parameter(Position = 1, ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
        [Alias("N")]
        [String]
        [ValidateNotNullOrEmpty()]
        $Name = "TestResults"
    )

    begin {}
    process {
        if($PSCmdlet.ShouldProcess("Recursively deleting all directories `"$Name`" below `"$Path`"",
                "Are you sure you want to delete these directories?",
                "Delete directories")) {
            Get-ChildItem $Path -Include $Name -Recurse | ForEach-Object ($_) {
                Write-Verbose "Deleting $($_.FullName)"
                Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable e

                if ($e) {
                    Write-Warning $e.Exception.Message
                }
            }
        }
    }
    end {}
}