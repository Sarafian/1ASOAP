$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. $here\$sut

$prefix = ($sut -replace '\.ps1', '') + " Tests:"

$validTestCases=@(
    @{
        Segment="P"
        PropertyName="P"
        IsIndexDeclared=$false
        Index=$null
    }
    @{
        Segment="Property"
        PropertyName="Property"
        IsIndexDeclared=$false
        Index=$null
    }
    @{
        Segment="Property123"
        PropertyName="Property123"
        IsIndexDeclared=$false
        Index=$null
    }
    @{
        Segment="P[0]"
        PropertyName="P"
        IsIndexDeclared=$true
        Index=0
    }
    @{
        Segment="Property[0]"
        PropertyName="Property"
        IsIndexDeclared=$true
        Index=0
    }
    @{
        Segment="Property123[0]"
        PropertyName="Property123"
        IsIndexDeclared=$true
        Index=0
    }
)

$invalidTestCases=@(
    "123Property"
    "Property[]"
    "Property[-1]"
    "Property[A123]"
    "Property[12]Abz"
    "Property\.Abz"
)|ForEach-Object {
    @{
        Segment=$_
    }
}
Describe "$prefix" {
    It "Valid <Segment> returns PropertyName=<PropertyName>, IsIndexDeclared=<IsIndexDeclared> and Index=<Index>" -TestCases $validTestCases {
        param ( $Segment, $PropertyName, $IsIndexDeclared, $Index )
        $actualInfo = Get-JSONPathSegmentInfo -Segment $Segment
        $actualInfo | Should -Not -BeNullOrEmpty
        $actualInfo.GetType().Fullname | Should -BeExactly "System.Management.Automation.PSCustomObject"
        $actualInfo.Segment | Should -BeExactly $Segment
        $actualInfo.PropertyName | Should -BeExactly $PropertyName
        $actualInfo.IsIndexDeclared | Should -BeExactly $IsIndexDeclared
        $actualInfo.Index | Should -BeExactly $Index
    }
    It "Invalid <Segment> throws error" -TestCases $invalidTestCases {
        param ( $Segment)
        {Get-JSONPathSegmentInfo -Segment $Segment} | Should -Throw
    }
}
