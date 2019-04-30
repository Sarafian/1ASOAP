$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. $here\$sut

$prefix = ($sut -replace '\.ps1', '') + " Tests:"

if (-not ("JSONPath.Pester.Root" -as [type]))
{
    Add-Type -Path "$here\..\..\..\Pester\CS\JSONPath.Pester.cs"
}
Add-Type -Path "$here\..\..\..\Pester\Cmdlets-Helpers\Get-RandomValue.ps1"

$singleTestCases=@(
    @{
        Segment="StringSingle"
        PropertyType="System.String" -as [type]
        IsPrimitiveOrString=$true
    }
    @{
        Segment="IntSingle"
        PropertyType="int" -as [type]
        IsPrimitiveOrString=$true
    }
    @{
        Segment="Type1Single"
        PropertyType="JSONPath.Pester.Type1" -as [type]
        IsPrimitiveOrString=$false
    }
)
$arrayTestCases=@(
    @{
        Segment="StringArray"
        PropertyType="System.String[]" -as [type]
        IsPrimitiveOrString=$true
        Index=$null
    }
    @{
        Segment="IntArray"
        PropertyType="int[]" -as [type]
        IsPrimitiveOrString=$true
        Index=$null
    }
    @{
        Segment="Type1Array"
        PropertyType="JSONPath.Pester.Type1[]" -as [type]
        IsPrimitiveOrString=$false
        Index=$null
    }
    @{
        Segment="StringArray[0]"
        PropertyType="System.String[]" -as [type]
        IsPrimitiveOrString=$true
        Index=0
    }
    @{
        Segment="IntArray[1]"
        PropertyType="int[]" -as [type]
        IsPrimitiveOrString=$true
        Index=1
    }
    @{
        Segment="Type1Array[2]"
        PropertyType="JSONPath.Pester.Type1[]" -as [type]
        IsPrimitiveOrString=$false
        Index=2
    }
)
$invalidTestCases=@(
    @{
        Segment="InvalidProperty"
    }
)

Describe "$prefix" {
    
    It "Single <Segment> returns object with PropertyType=<PropertyType> and IsPrimitiveOrString=<IsPrimitiveOrString>" -TestCases $singleTestCases {
        param ( $Segment, $PropertyType, $IsPrimitiveOrString)
        $info=[PSCustomObject]@{
            Segment = $Segment
            PropertyName = $Segment
            IsIndexDeclared=$false
            Index=$null
        }

        $actualTypeInfo=Get-JSONPathSegmentTypeInfo -Info $info -Type ("JSONPath.Pester.Root" -as [type])
        $actualTypeInfo | Should -Not -BeNullOrEmpty
        $actualTypeInfo.GetType().Fullname | Should -BeExactly "System.Management.Automation.PSCustomObject"
        $actualTypeInfo.Segment | Should -BeExactly $info.Segment
        $actualTypeInfo.PropertyName | Should -BeExactly $info.PropertyName
        $actualTypeInfo.IsIndexDeclared | Should -BeExactly $info.IsIndexDeclared
        $actualTypeInfo.Index | Should -BeExactly $info.Index

        $actualTypeInfo.PropertyType | Should -BeExactly $PropertyType
        $actualTypeInfo.IsPropertyArray | Should -BeExactly $false
        $actualTypeInfo.ArrayElementType | Should -BeExactly $null
        $actualTypeInfo.IsPrimitiveOrString | Should -BeExactly $IsPrimitiveOrString
    }
    It "Array <Segment> returns object with PropertyType=<PropertyType> and IsPrimitiveOrString=<IsPrimitiveOrString>" -TestCases $arrayTestCases {
        param ( $Segment, $PropertyType, $IsPrimitiveOrString, $Index)
        $info=[PSCustomObject]@{
            Segment = $Segment
            PropertyName = $Segment
            IsIndexDeclared=($Index -ne $null)
            Index=$Index
        }
        if($info.IsIndexDeclared)
        {
            $info.PropertyName=$Segment.SubString(0,$Segment.IndexOf("["))
        }
        
        $actualTypeInfo=Get-JSONPathSegmentTypeInfo -Info $info -Type ("JSONPath.Pester.Root" -as [type])
        $actualTypeInfo | Should -Not -BeNullOrEmpty
        $actualTypeInfo.GetType().Fullname | Should -BeExactly "System.Management.Automation.PSCustomObject"
        $actualTypeInfo.Segment | Should -BeExactly $info.Segment
        $actualTypeInfo.PropertyName | Should -BeExactly $info.PropertyName
        $actualTypeInfo.IsIndexDeclared | Should -BeExactly $info.IsIndexDeclared
        $actualTypeInfo.Index | Should -BeExactly $info.Index

        $actualTypeInfo.PropertyType | Should -BeExactly $PropertyType
        $actualTypeInfo.IsPropertyArray | Should -BeExactly $true
        $actualTypeInfo.ArrayElementType | Should -BeExactly $PropertyType.GetElementType()
        $actualTypeInfo.IsPrimitiveOrString | Should -BeExactly $IsPrimitiveOrString
    }
    It "Invalid <Segment> throws error" -TestCases $invalidTestCases {
        param ( $Segment)
        $info=[PSCustomObject]@{
            Segment = $Segment
            PropertyName = $Segment
        }
        {Get-JSONPathSegmentTypeInfo -Info $info -Type ("JSONPath.Pester.Root")} | Should -Throw
    }
}