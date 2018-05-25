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
# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2MHNndZTvqHH+PKtJplqsvJP
# +GCgggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBT4uzDYrdPArRli/HbnO+K49usk1DANBgkqhkiG
# 9w0BAQEFAASBgHG27+jfGG3a0+6yRZZUYGgJqVotWGqwMAqFflXcu4pxc7ghmRfF
# UoRVKuUR5tS8zFx9MKp3qYb4mdjyFaVE5hIMoCnvgLyrg6gX0cWYf33fBxXPe6y4
# gDVVK91EQ7ygHvKVAdqkitDBYc4CFKyemp8v+JaYimMX8GMJODQOnK+2
# SIG # End signature block
