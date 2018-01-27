
CLASS ConstructorName : Attribute {
    [String]$Name
    
    ConstructorName ([String]$Name) {
        $this.Name = $Name}

}

function New-FunctionFromConstructors {
<#
.DESCRIPTION
You will need this using statement (with relative path to this module file)
in the code where you want to use this function:
using module '.\New-FunctionFromConstructors.psm1'
(No, a manifest file such as New-FunctionFromConstructors.psd1 will not work. No, I don't know why.)

Then, to gain access to your new function-constructors, use this right after your class definition 
or in whatever context you are using the functions, as they don't export well (yes, the $() around the [Type] is important):

    $( New-FunctionFromConstructors -Class $([YourClassNameGoesHere]) ) | ForEach-Object {Invoke-Expression $_.Expression}

(You might also just actually USE the output to create ACTUAL FUNCTIONS, like this:

    $(New-FunctionFromConstructors -Class $([YourClassNameGoesHere]) ).Expression | Clip.exe

Then paste that into your module. You will still need the using statement to get access to the [ConstructorName()] attribute.
But if you don't...)

To gain access to the functions in the ISE, run the script to create the function, then run the command above.
#>
[CmdletBinding()]
PARAM(
    [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][System.Reflection.TypeInfo]$Class
)
BEGIN{}<#End Begin#>
PROCESS{
    $Class.GetConstructors() | ForEach-Object {
        $parameters = $_.GetParameters() | Select Name, ParameterType
            $parameters | Out-string | Write-Verbose

        $newFxName = "New-Object-$($Class.Name)-$($_.GetCustomAttributes('ConstructorName').Name)"
        $runThis = "
        FUNCTION $newFxName {
        [CmdletBinding()]
        PARAM($(  $($parameters | ForEach-Object {  '[PARAMETER(Mandatory=$True,ValueFromPipelineByPropertyName=$True)]['+$_.ParameterType+']$'+$_.Name  }) -join ',' ))
        BEGIN{}
        PROCESS{
        `$([$($Class.Name)].GetConstructors() | Where-Object {`$_.GetCustomAttributes('ConstructorName').Name -Like '$($_.GetCustomAttributes('ConstructorName').Name)'} ).Invoke(@(`$$($parameters.Name -join ',$' )))
        }
        END{}
        }
        "
        Return [PSCustomObject]@{Name=$newFxName;Expression=$runthis} 

    }<#End Foreach-Object#>

}<#End Process#>
END{}<#End End#>

}


