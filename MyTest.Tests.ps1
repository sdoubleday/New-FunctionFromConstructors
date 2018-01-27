<#SDS Modified Pester Test file header to handle modules.#>
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = ( (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.' ) -replace '.ps1', '.psd1'
$scriptBody = "using module $here\$sut"
$script = [ScriptBlock]::Create($scriptBody)
. $script



Describe "New-FunctionFromConstructors" {
    
    It "Makes functions available in the module" {
        ( foo ).GetType().Name | Should Be 'MySample' }
    
    It "Creates Functions!" {
        $( New-FunctionFromConstructors -Class $([MySample]) ) | ForEach-Object {Invoke-Expression $_.Expression}

        (Get-Command "New-Object-*").Count | Should Be 2 }

    
}

