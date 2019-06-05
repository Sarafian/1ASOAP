$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\JSONPath\JSONPath.psm1 -Force


$prefix=($sut -replace '\.ps1','')+" Tests:"

if (-not ("JSONPath.Pester.Root" -as [type]))
{
    Add-Type -Path "$here\CS\JSONPath.Pester.cs"
}

#<#
    # Generate traces
    Trace-JSONPath -Type ("JSONPath.Pester.Root" -as [type])|ForEach-Object {"'$_'"}|Sort-Object|clip
    Trace-JSONPath -Type ("JSONPath.Pester.Root" -as [type])|Sort-Object|clip
    return
#>
<#
    # Render code
    Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type]) -RenderCode|clip
    return
#>
#region Expected Traces
$rootTraces=@(
    'IntArray[0]=0'
    'IntSingle=0'
    'StringArray[0]="String"'
    'StringSingle="String"'
    'Type1Array[0].IntArray[0]=0'
    'Type1Array[0].IntSingle=0'
    'Type1Array[0].StringArray[0]="String"'
    'Type1Array[0].StringSingle="String"'
    'Type1Array[0].Type2Array[0].IntArray[0]=0'
    'Type1Array[0].Type2Array[0].IntSingle=0'
    'Type1Array[0].Type2Array[0].StringArray[0]="String"'
    'Type1Array[0].Type2Array[0].StringSingle="String"'
    'Type1Array[0].Type2Single.IntArray[0]=0'
    'Type1Array[0].Type2Single.IntSingle=0'
    'Type1Array[0].Type2Single.StringArray[0]="String"'
    'Type1Array[0].Type2Single.StringSingle="String"'
    'Type1Single.IntArray[0]=0'
    'Type1Single.IntSingle=0'
    'Type1Single.StringArray[0]="String"'
    'Type1Single.StringSingle="String"'
    'Type1Single.Type2Array[0].IntArray[0]=0'
    'Type1Single.Type2Array[0].IntSingle=0'
    'Type1Single.Type2Array[0].StringArray[0]="String"'
    'Type1Single.Type2Array[0].StringSingle="String"'
    'Type1Single.Type2Single.IntArray[0]=0'
    'Type1Single.Type2Single.IntSingle=0'
    'Type1Single.Type2Single.StringArray[0]="String"'
    'Type1Single.Type2Single.StringSingle="String"'
)
$type1Traces=@(
    'IntArray[0]=0'
    'IntSingle=0'
    'StringArray[0]="String"'
    'StringSingle="String"'
    'Type2Array[0].IntArray[0]=0'
    'Type2Array[0].IntSingle=0'
    'Type2Array[0].StringArray[0]="String"'
    'Type2Array[0].StringSingle="String"'
    'Type2Single.IntArray[0]=0'
    'Type2Single.IntSingle=0'
    'Type2Single.StringArray[0]="String"'
    'Type2Single.StringSingle="String"'
)
$type2Traces=@(
    'IntArray[0]=0'
    'IntSingle=0'
    'StringArray[0]="String"'
    'StringSingle="String"'
)
#endregion

#region Expected Code
$rootCode=@'
$obj=New-Object -TypeName "JSONPath.Pester.Root"
$obj=Set-JSONPath -Path "Type1Single.Type2Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "IntArray[0]" -Value 0
'@

$type1Code=@'
$obj=New-Object -TypeName "JSONPath.Pester.Type1"
$obj=Set-JSONPath -Path "Type2Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type2Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type2Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type2Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type2Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type2Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type2Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type2Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "IntArray[0]" -Value 0
'@

$type2Code=@'
$obj=New-Object -TypeName "JSONPath.Pester.Type2"
$obj=Set-JSONPath -Path "StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "IntArray[0]" -Value 0
'@
#endregion
Describe "$prefix -Trace" {
    It "Root" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Root" -as [type])|Sort-Object
        $actual.Length | Should -BeExactly $rootTraces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $rootTraces[0]
        }
    }
    It "Type1" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Type1" -as [type])|Sort-Object
        $actual.Length | Should -BeExactly $type1Traces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $type1Traces[0]
        }
    }
    It "Type2" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type])|Sort-Object
        $actual.Length | Should -BeExactly $type2Traces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $type2Traces[0]
        }
    }
}
Describe "$prefix -Render" {
    It "Root" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Root" -as [type]) -RenderCode
        $actual.Length | Should -BeExactly $rootCode.Length
        $actual | Should -BeExactly $rootCode
    }
    It "Type1" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Type1" -as [type]) -RenderCode
        $actual.Length | Should -BeExactly $type1Code.Length
        $actual | Should -BeExactly $type1Code
    }
    It "Type2" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type]) -RenderCode
        $actual.Length | Should -BeExactly $type2Code.Length
        $actual | Should -BeExactly $type2Code
    }
}