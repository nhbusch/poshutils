################################################################################
#
# Format-Document
#
# Copyright (c) 2015 Nils H. Busch. All rights reserved.
#
# Distributed under the MIT License (MIT).
# See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT.
#
# Original code Copyright (c) David Fowler.
#
################################################################################

<#
.SYNOPSIS
  Formats documents recursively.

.DESCRIPTION
  The Format-Document command recursively formats all source code files in the 
  current solution based on the current code formatting settings.

.PARAMETER ProjectName
  Specifies the VisualStudio project to format

.SYNTAX

.EXAMPLE
  PS > Format-Document -ProjectName Foo
  Recursively formats the project Foo.
  
.LINK
  
#>

function Format-Document {
  param(
    [parameter(ValueFromPipelineByPropertyName = $true)]
    [string[]]$ProjectName
  )
  process {
    $ProjectName | %{ 
      Recurse-Project -ProjectName $_ -Action { param($item)
        if($item.Type -eq 'Folder' -or !$item.Language) {
          return
      }
                        
      $window = $item.ProjectItem.Open('{7651A701-06E5-11D1-8EBD-00A0C90F26EA}')
      if ($window) {
        Write-Host "Processing `"$($item.ProjectItem.Name)`""
        [System.Threading.Thread]::Sleep(100)
          $window.Activate()
          $Item.ProjectItem.Document.DTE.ExecuteCommand('Edit.FormatDocument')
          $Item.ProjectItem.Document.DTE.ExecuteCommand('Edit.RemoveAndSort')
          $window.Close(1)
        }
      }
    }
  }
}

function Recurse-Project {
  param(
    [parameter(ValueFromPipelineByPropertyName = $true)]
    [string[]]$ProjectName,
    [parameter(Mandatory = $true)]$Action
  )

  process {
    # Convert project item guid into friendly name
    function Get-Type($kind) {
      switch($kind) {
        '{6BB5F8EE-4483-11D3-8BCF-00C04F8EC28C}' { 'File' }
        '{6BB5F8EF-4483-11D3-8BCF-00C04F8EC28C}' { 'Folder' }
        default { $kind }
     }
   }
        
  # Convert language guid to friendly name
  function Get-Language($item) {
    if(!$item.FileCodeModel) {
      return $null
    }
            
    $kind = $item.FileCodeModel.Language
    switch($kind) {
      #'{B5E9BD34-6D3E-4B5D-925E-8A43B79820B4}' { 'C#' }
      #'{B5E9BD33-6D3E-4B5D-925E-8A43B79820B4}' { 'VB' }
      '{694DD9B6-B865-4C5B-AD85-86356E9C88DC}' { 'C#' } 
      '{E34ACDC0-BAAE-11D0-88BF-00A0C9110049}' { 'VB' }
      '{B2F072B0-ABC1-11D0-9D62-00C04FD9DFD9}' { 'C++' }
      default { $kind }
    }
  }
        
  # Walk over all project items running the action on each
  function Recurse-ProjectItems($projectItems, $action) {
     $projectItems | %{
       $obj = New-Object PSObject -Property @{
         ProjectItem = $_
         Type = Get-Type $_.Kind
         Language = Get-Language $_
       }
                
       & $action $obj
                
       if($_.ProjectItems) {
         Recurse-ProjectItems $_.ProjectItems $action
       }
     }
  }
        
  if($ProjectName) {
    $p = Get-Project $ProjectName
  }
  else {
    $p = Get-Project
  }
        
  $p | %{ Recurse-ProjectItems $_.ProjectItems $Action } 
  }
}

# Statement completion for project names
Register-TabExpansion 'Recurse-Project' @{
  ProjectName = { Get-Project -All | Select -ExpandProperty Name }
}

