using module '.\New-FunctionFromConstructors.psm1'
CLASS MySample {
    [String]$Prop1
    [String]$Prop2

    [ConstructorName('SpecifyEach')]
    MySample ([String]$Prop1,[String]$Prop2) {
        $this.Prop1 = $Prop1
        $this.Prop2 = $Prop2
    }

    [ConstructorName('ConcatenatePairs')]
    MySample ([String]$Prop1a,[String]$Prop1b,[String]$Prop2a,[String]$Prop2b) {
        $this.Prop1 = $Prop1a + $Prop1b
        $this.Prop2 = $Prop2a + $Prop2b
    }
}
$( New-FunctionFromConstructors -Class $([MySample]) ) | ForEach-Object {Invoke-Expression $_.Expression}

FUNCTION foo {
[CMDLETBINDING()]
PARAM()

Return $( New-Object-MySample-SpecifyEach -Prop1 'yyyyyy' -Prop2 'lllll' )

}
