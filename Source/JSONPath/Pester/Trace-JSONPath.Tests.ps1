$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\JSONPath\JSONPath.psm1 -Force


$prefix=($sut -replace '\.ps1','')+" Tests:"

if (-not ("JSONPath.Pester.Root" -as [type]))
{
    Add-Type -Path "$here\CS\JSONPath.Pester.cs"
}

. $here\Cmdlets-Helpers\Get-RandomValue.ps1

<# Generate traces from type
    Trace-JSONPath -Type ("JSONPath.Pester.Root" -as [type])|ForEach-Object {"'$_'"}|Sort-Object|clip
    Trace-JSONPath -Type ("JSONPath.Pester.Root" -as [type])|Sort-Object|clip
    return
#>
<# Render code
    Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type]) -RenderCode|clip
    return
#>
<# Generate traces from object
    $inputObject=New-Object -TypeName "JSONPath.Pester.Root"

    $inputObject=$inputObject|
#region Type1Array[1]
<#
        Set-JSONPath -Path "Type1Array[1].Type2Single.StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Single.IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Single.IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[1].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[1].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[1].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[1].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[0].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[0].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[0].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].Type2Array[0].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].StringArray[1]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[1].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].IntArray[1]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[1].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
#endregion
#region Type1Array[0]
        Set-JSONPath -Path "Type1Array[0].Type2Single.StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Single.IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Single.IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[1].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[1].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[1].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[1].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[0].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[0].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[0].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].Type2Array[0].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].StringArray[1]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Array[0].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].IntArray[1]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Array[0].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
#endregion

#region Type1Single
        Set-JSONPath -Path "Type1Single.Type2Single.StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Single.StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Single.IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Single.IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[1].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[1].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[1].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[1].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[0].StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[0].StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[0].IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.Type2Array[0].IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.StringSingle" -Value (Get-RandomValue -String) -PassThru |
#        Set-JSONPath -Path "Type1Single.StringArray[1]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "Type1Single.IntSingle" -Value (Get-RandomValue -Int) -PassThru |
#        Set-JSONPath -Path "Type1Single.IntArray[1]" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "Type1Single.IntArray[0]" -Value (Get-RandomValue -Int) -PassThru |
#endregion  
        Set-JSONPath -Path "StringSingle" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "StringArray[1]" -Value (Get-RandomValue -String) -PassThru |
#        Set-JSONPath -Path "StringArray[0]" -Value (Get-RandomValue -String) -PassThru |
        Set-JSONPath -Path "IntSingle" -Value (Get-RandomValue -Int) -PassThru |
        Set-JSONPath -Path "IntArray[1]" -Value (Get-RandomValue -Int) -PassThru #|
#        Set-JSONPath -Path "IntArray[0]" -Value (Get-RandomValue -Int) -PassThru

    $clip=Trace-JSONPath -InputObject $inputObject
    $clip
#    $clip|clip
    return
#>

#region Expected Type Traces
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
$obj=$obj | Set-JSONPath -Path "Type1Single.Type2Single.StringSingle" -Value "String" -PassThru |
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
$obj=$obj | Set-JSONPath -Path "Type2Single.StringSingle" -Value "String" -PassThru |
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
$obj=$obj | Set-JSONPath -Path "StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "IntArray[0]" -Value 0
'@
#endregion

#region Expected Object Traces
<#
$randomString1=Get-RandomValue -String
$randomString2=Get-RandomValue -String
$randomInt1=Get-RandomValue -Int
$randomInt2=Get-RandomValue -Int
$rootTestCases=@(
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
#>
#endregion

<#
Describe "$prefix -TypeTrace" {
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
#        $actual.Length | Should -BeExactly $rootCode.Length
        $actual | Should -BeExactly $rootCode
    }
    It "Type1" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Type1" -as [type]) -RenderCode
#        $actual.Length | Should -BeExactly $type1Code.Length
        $actual | Should -BeExactly $type1Code
    }
    It "Type2" {
        $actual = Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type]) -RenderCode
#        $actual.Length | Should -BeExactly $type2Code.Length
        $actual | Should -BeExactly $type2Code
    }
}
#>
Describe "$prefix -ObjectTrace" {
    It "Primitives" {
        $rootObject=[JSONPath.Pester.Root]::new()
        $rootObject=$rootObject |
            Set-JSONPath -Path "StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "IntArray[1]" -Value 2 -PassThru

        $expectedTraces=@(
            'IntArray[0]=0'
            'IntArray[1]=2'
            'IntSingle=1'
            'StringArray[0]=""(null)'
            'StringArray[1]="2"'
            'StringSingle="1"'
        )

        $actual = Trace-JSONPath -InputObject $rootObject|Sort-Object
        
        $actual.Length | Should -BeExactly $expectedTraces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $expectedTraces[0]
        }
    }
    It "Type1Single Primitives" {
        $rootObject=[JSONPath.Pester.Root]::new()
        $rootObject=$rootObject |
            Set-JSONPath -Path "Type1Single.StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Single.StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Single.IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Single.IntArray[1]" -Value 2 -PassThru

        $expectedTraces=@(
            'Type1Single.IntArray[0]=0'
            'Type1Single.IntArray[1]=2'
            'Type1Single.IntSingle=1'
            'Type1Single.StringArray[0]=""(null)'
            'Type1Single.StringArray[1]="2"'
            'Type1Single.StringSingle="1"'
        )

        $actual = Trace-JSONPath -InputObject $rootObject|Sort-Object
        
        $actual.Length | Should -BeExactly $expectedTraces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $expectedTraces[0]
        }
    }
    It "Type1Array[1] Primitives" {
        $rootObject=[JSONPath.Pester.Root]::new()
        $rootObject=$rootObject |
            Set-JSONPath -Path "Type1Array[1].StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Array[1].StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Array[1].IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Array[1].IntArray[1]" -Value 2 -PassThru

        $expectedTraces=@(
            'Type1Array[1].IntArray[0]=0'
            'Type1Array[1].IntArray[1]=2'
            'Type1Array[1].IntSingle=1'
            'Type1Array[1].StringArray[0]=""(null)'
            'Type1Array[1].StringArray[1]="2"'
            'Type1Array[1].StringSingle="1"'
        )

        $actual = Trace-JSONPath -InputObject $rootObject|Sort-Object
        
        $actual.Length | Should -BeExactly $expectedTraces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $expectedTraces[0]
        }
    }
    It "Mixed" {
        $rootObject=[JSONPath.Pester.Root]::new()
        $rootObject=$rootObject |
            Set-JSONPath -Path "Type1Array[1].Type2Single.StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Single.IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Single.StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Single.IntArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Array[1].StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Array[1].IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Array[1].StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Array[1].Type2Array[1].IntArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Single.StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Single.IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Single.StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Single.IntArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Array[1].StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Array[1].IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Array[1].StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "Type1Single.Type2Array[1].IntArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "StringSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "IntSingle" -Value 1 -PassThru |
            Set-JSONPath -Path "StringArray[1]" -Value 2 -PassThru |
            Set-JSONPath -Path "IntArray[1]" -Value 2 -PassThru

        $expectedTraces=@(
            'IntArray[0]=0'
            'IntArray[1]=2'
            'IntSingle=1'
            'StringArray[0]=""(null)'
            'StringArray[1]="2"'
            'StringSingle="1"'
            'Type1Array[1].Type2Array[1].IntArray[0]=0'
            'Type1Array[1].Type2Array[1].IntArray[1]=2'
            'Type1Array[1].Type2Array[1].IntSingle=1'
            'Type1Array[1].Type2Array[1].StringArray[0]=""(null)'
            'Type1Array[1].Type2Array[1].StringArray[1]="2"'
            'Type1Array[1].Type2Array[1].StringSingle="1"'
            'Type1Array[1].Type2Single.IntArray[0]=0'
            'Type1Array[1].Type2Single.IntArray[1]=2'
            'Type1Array[1].Type2Single.IntSingle=1'
            'Type1Array[1].Type2Single.StringArray[0]=""(null)'
            'Type1Array[1].Type2Single.StringArray[1]="2"'
            'Type1Array[1].Type2Single.StringSingle="1"'
            'Type1Single.Type2Array[1].IntArray[0]=0'
            'Type1Single.Type2Array[1].IntArray[1]=2'
            'Type1Single.Type2Array[1].IntSingle=1'
            'Type1Single.Type2Array[1].StringArray[0]=""(null)'
            'Type1Single.Type2Array[1].StringArray[1]="2"'
            'Type1Single.Type2Array[1].StringSingle="1"'
            'Type1Single.Type2Single.IntArray[0]=0'
            'Type1Single.Type2Single.IntArray[1]=2'
            'Type1Single.Type2Single.IntSingle=1'
            'Type1Single.Type2Single.StringArray[0]=""(null)'
            'Type1Single.Type2Single.StringArray[1]="2"'
            'Type1Single.Type2Single.StringSingle="1"'
        )

        $actual = Trace-JSONPath -InputObject $rootObject|Sort-Object
        
        $actual.Length | Should -BeExactly $expectedTraces.Count

        for($i=0;$i -lt $actual.Count;$i++)
        {
            $actual[0] | Should -BeExactly $expectedTraces[0]
        }
    }
}