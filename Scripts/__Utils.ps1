function Get-Batchfile ($file) {
    $cmd = "`"$file`" & set"
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
}
  
function VsVars32($version = "10.0")
{
    $key = "HKLM:SOFTWARE\Microsoft\VisualStudio\" + $version
    $VsKey = Get-ItemProperty $key
    $VsInstallPath = [System.IO.Path]::GetDirectoryName($VsKey.InstallDir)
    $VsToolsDir = [System.IO.Path]::GetDirectoryName($VsInstallPath)
    $VsToolsDir = [System.IO.Path]::Combine($VsToolsDir, "Tools")
    $BatchFile = [System.IO.Path]::Combine($VsToolsDir, "vsvars32.bat")
    Get-Batchfile $BatchFile
    [System.Console]::Title = "Visual Studio " + $version + " Windows Powershell"
    //add a call to set-consoleicon as seen below...hm...!
}


##############################################################################
## Script: Set-ConsoleIcon.ps1
## By: Aaron Lerch, tiny tiny mods by Hanselman
## Website: www.aaronlerch.com/blog 
## Set the icon of the current console window to the specified icon
## Dot-Source first, like . .\set-consoleicon.ps1
## Usage:  Set-ConsoleIcon [string]
## PS:1 > Set-ConsoleIcon "C:\Icons\special_powershell_icon.ico" 
##############################################################################
 
$WM_SETICON = 0x80
$ICON_SMALL = 0
 
function Set-ConsoleIcon
{
    param(
        [string] $iconFile
    )
 
    [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") | out-null
$iconFile
    # Verify the file exists
    if ([System.IO.File]::Exists($iconFile) -eq $TRUE)
    {
        $icon = new-object System.Drawing.Icon($iconFile) 
 
        if ($icon -ne $null)
        {
            $consoleHandle = GetConsoleWindow
            SendMessage $consoleHandle $WM_SETICON $ICON_SMALL $icon.Handle 
        }
    }
    else
    {
        Write-Host "Icon file not found"
    }
}
 
 
## Invoke a Win32 P/Invoke call.
## From: Lee Holmes
## http://www.leeholmes.com/blog/GetTheOwnerOfAProcessInPowerShellPInvokeAndRefOutParameters.aspx
function Invoke-Win32([string] $dllName, [Type] $returnType, 
   [string] $methodName, [Type[]] $parameterTypes, [Object[]] $parameters) 
{
   ## Begin to build the dynamic assembly
   $domain = [AppDomain]::CurrentDomain
   $name = New-Object Reflection.AssemblyName 'PInvokeAssembly'
   $assembly = $domain.DefineDynamicAssembly($name, 'Run') 
   $module = $assembly.DefineDynamicModule('PInvokeModule')
   $type = $module.DefineType('PInvokeType', "Public,BeforeFieldInit")
 
   ## Go through all of the parameters passed to us.  As we do this, 
   ## we clone the user's inputs into another array that we will use for
   ## the P/Invoke call.  
   $inputParameters = @()
   $refParameters = @()
   
   for($counter = 1; $counter -le $parameterTypes.Length; $counter++) 
   {
      ## If an item is a PSReference, then the user 
      ## wants an [out] parameter.
      if($parameterTypes[$counter - 1] -eq [Ref])
      {
         ## Remember which parameters are used for [Out] parameters 
         $refParameters += $counter
 
         ## On the cloned array, we replace the PSReference type with the 
         ## .Net reference type that represents the value of the PSReference, 
         ## and the value with the value held by the PSReference. 
         $parameterTypes[$counter - 1] = 
            $parameters[$counter - 1].Value.GetType().MakeByRefType()
         $inputParameters += $parameters[$counter - 1].Value
      }
      else
      {
         ## Otherwise, just add their actual parameter to the
         ## input array.
         $inputParameters += $parameters[$counter - 1]
      }
   }
 
   ## Define the actual P/Invoke method, adding the [Out] 
   ## attribute for any parameters that were originally [Ref] 
   ## parameters.
   $method = $type.DefineMethod($methodName, 'Public,HideBySig,Static,PinvokeImpl', 
      $returnType, $parameterTypes) 
   foreach($refParameter in $refParameters)
   {
      $method.DefineParameter($refParameter, "Out", $null)
   }
 
   ## Apply the P/Invoke constructor
   $ctor = [Runtime.InteropServices.DllImportAttribute].GetConstructor([string])
   $attr = New-Object Reflection.Emit.CustomAttributeBuilder $ctor, $dllName
   $method.SetCustomAttribute($attr)
 
   ## Create the temporary type, and invoke the method.
   $realType = $type.CreateType() 
   $realType.InvokeMember($methodName, 'Public,Static,InvokeMethod', $null, $null, 
      $inputParameters)
 
   ## Finally, go through all of the reference parameters, and update the
   ## values of the PSReference objects that the user passed in. 
   foreach($refParameter in $refParameters)
   {
      $parameters[$refParameter - 1].Value = $inputParameters[$refParameter - 1]
   }
}
 
function SendMessage([IntPtr] $hWnd, [Int32] $message, [Int32] $wParam, [Int32] $lParam) 
{
    $parameterTypes = [IntPtr], [Int32], [Int32], [Int32]
    $parameters = $hWnd, $message, $wParam, $lParam
 
    Invoke-Win32 "user32.dll" ([Int32]) "SendMessage" $parameterTypes $parameters 
}
 
function GetConsoleWindow()
{
    Invoke-Win32 "kernel32" ([IntPtr]) "GetConsoleWindow"
}

# SIG # Begin signature block
# MIIERgYJKoZIhvcNAQcCoIIENzCCBDMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnL5V2FydceK3iQVKbWytvhHH
# aDugggJQMIICTDCCAbmgAwIBAgIQy8TBt4Oo9JZDpd5zbA43pDAJBgUrDgMCHQUA
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBTVwe2reuE05w8TuxjT1ujcTy9bSjANBgkqhkiG
# 9w0BAQEFAASBgArdwcOYY9ozB5A7RNw8a6U+7sRvpWvG7Weofl93qGh66QsWK8E2
# QM2dCvnYHJq2p60yj1y538hDayA51+8Q9/8MsMATxYVlK9zp5XFPN8GTi3xY85h5
# cfDD4djy8WSUIssgGapd2KM38W9OsCfe5KqGR9tJ+qMGHaZv4JiJdk0H
# SIG # End signature block
