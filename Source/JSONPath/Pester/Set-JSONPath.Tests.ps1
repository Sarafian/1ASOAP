$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\JSONPath\JSONPath.psm1 -Force


$prefix=($sut -replace '\.ps1','')+" Tests:"

if (-not ("JSONPath.Pester.Root" -as [type]))
{
    Add-Type -Path "$here\CS\JSONPath.Pester.cs"
}

. $here\Cmdlets-Helpers\Get-RandomValue.ps1

$rootTestCases=@(
    @{
        Path="StringSingle"
        Value=Get-RandomValue -String
    }    
    @{
        Path="StringArray"
        Value=Get-RandomValue -String
    }    
    @{
        Path="StringArray[0]"
        Value=Get-RandomValue -String
    }    
    @{
        Path="StringArray[1]"
        Value=Get-RandomValue -String
    }    
    @{
        Path="IntSingle"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="IntArray"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="IntArray[0]"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="IntArray[1]"
        Value=Get-RandomValue -Int
    }    
)
$type1TestCases=@(
    @{
        Path="Type1Single.StringSingle"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Single.StringArray[0]"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Single.IntSingle"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="Type1Single.IntArray[0]"
        Value=Get-RandomValue -Int
    }
    @{
        Path="Type1Array[0].StringSingle"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Array[1].StringArray[0]"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Array[0].IntSingle"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="Type1Array[1].IntArray[0]"
        Value=Get-RandomValue -Int
    }
)

$type2TestCases=@(
    @{
        Path="Type1Single.Type2Single.StringSingle"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Single.Type2Array[0].StringSingle"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Single.Type2Single.StringArray[0]"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Single.Type2Array[0].StringArray[0]"
        Value=Get-RandomValue -String
    }    
    @{
        Path="Type1Single.Type2Single.IntSingle"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="Type1Single.Type2Array[0].IntSingle"
        Value=Get-RandomValue -Int
    }    
    @{
        Path="Type1Single.Type2Single.IntArray[0]"
        Value=Get-RandomValue -Int
    }
    @{
        Path="Type1Single.Type2Array[0].IntArray[0]"
        Value=Get-RandomValue -Int
    }
)

$invalidTestCases=@(
    @{
        Path="123Property"
    }    
    @{
        Path="Property[A123]"
    }    
    @{
        Path="Property[12]Abz"
    }    
)
Describe "$prefix" {
    It "Root <Path>=<Value>" -TestCases $rootTestCases {
        param ( $Path,$Value )
        $root=[JSONPath.Pester.Root]::new()
        $root|Set-JSONPath -Path $Path -Value $Value
        $actualValue=Invoke-Expression -Command ('$root.'+$Path)
        $actualValue|Should -BeExactly $Value
    }
    It "Root.Type1 <Path>=<Value>" -TestCases $type1TestCases {
        param ( $Path,$Value )
        $root=[JSONPath.Pester.Root]::new()
        $root|Set-JSONPath -Path $Path -Value $Value
        $actualValue=Invoke-Expression -Command ('$root.'+$Path)
        $actualValue|Should -BeExactly $Value
    }
    It "Root.Type1.Type2 <Path>=<Value>" -TestCases $type2TestCases {
        param ( $Path,$Value )
        $root=[JSONPath.Pester.Root]::new()
        $root|Set-JSONPath -Path $Path -Value $Value
        $actualValue=Invoke-Expression -Command ('$root.'+$Path)
        $actualValue|Should -BeExactly $Value
    }
    It "Invalid <Path>" -TestCases $invalidTestCases {
        param ( $Path )
        $root=[JSONPath.Pester.Root]::new()
        {$root|Set-JSONPath -Path $Path -Value $Value }|Should -Throw
    }
    It "PassThru" {
        $root=[JSONPath.Pester.Root]::new()
        $expectedString=Get-RandomValue -String
        $expectedInt=Get-RandomValue -Int
        $root|
            Set-JSONPath -Path "StringSingle" -Value $expectedString -PassThru |
            Set-JSONPath -Path "IntSingle" -Value $expectedInt

        $root.StringSingle|Should -BeExactly $expectedString
        $root.IntSingle|Should -BeExactly $expectedInt
    }
    # TODO Implement test to catpure warning
}