$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\JSONPath\JSONPath.psm1 -Force

# Setting globally to allow access for code within InModuleScope 
Set-Variable "here" -Value $here -Scope Global

$prefix=($sut -replace '\.ps1','')+" Tests:"
Set-Variable "prefix" -Value $prefix -Scope Global

if (-not ("JSONPath.Pester.Root" -as [type]))
{
    Add-Type -Path "$here\CS\JSONPath.Pester.cs"
}

InModuleScope JSONPath {
    . $here\Cmdlets-Helpers\Get-RandomValue.ps1

    $valueCases=@(
        @{
            Segment="StringSingle"
            Value=Get-RandomValue -String
            ArrayLength=$null
        }
        @{
            Segment="StringArray"
            Value=Get-RandomValue -String
            ArrayLength=1
        }
        @{
            Segment="StringArray[2]"
            Value=Get-RandomValue -String
            ArrayLength=3
        }
        @{
            Segment="IntSingle"
            Value=Get-RandomValue -Int
            ArrayLength=$null
        }
        @{
            Segment="IntArray"
            Value=Get-RandomValue -Int
            ArrayLength=1
        }
        @{
            Segment="IntArray[2]"
            Value=Get-RandomValue -Int
            ArrayLength=3
        }
    )
    $compositeCases=@(
        @{
            Segment="Type1Single"
            ArrayLength=$null
        }
        @{
            Segment="Type1Array"
            ArrayLength=1
        }
        @{
            Segment="Type1Array[2]"
            ArrayLength=3
        }
    )

    $testCases=$valueCases | Where-Object {$_.Segment -notlike "*Array*"}|ForEach-Object {
        @{
            Segment=$_.Segment
            Value=$_.Value
            Operator="EQ"
            Expected=$true
        }
        @{
            Segment=$_.Segment
            Value=$_.Value
            Operator="NE"
            Expected=$false
        }
    }
    $invalidTestCases=$valueCases | Where-Object {$_.Segment -like "*Array*"}|ForEach-Object {
        @{
            Segment=$_.Segment
            Operator="EQ"
            Value=$_.Value
        }
        @{
            Segment=$_.Segment
            Operator="NE"
            Value=$_.Value
        }
    }

    Describe "$prefix"{
        $rootType="JSONPath.Pester.Root" -as [type]
        Context "Split" {
            It "Split-JSONPath with segment <Segment>" -TestCases $valueCases {
                param ( $Segment)
                $root=New-Object -TypeName $rootType
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info

                $actual=Split-JSONPath -InputObject $root -Path $Segment
                $actual | Should -Not -BeNullOrEmpty
                @($actual).Length  | Should -BeExactly 1
                $actual.Segment |Should -BeExactly $typeInfo.Segment
                $actual.PropertyName |Should -BeExactly $typeInfo.PropertyName
                $actual.IsIndexDeclared |Should -BeExactly $typeInfo.IsIndexDeclared
                $actual.PropertyType |Should -BeExactly $typeInfo.PropertyType
                $actual.IsPropertyArray |Should -BeExactly $typeInfo.IsPropertyArray
                $actual.ArrayElementType |Should -BeExactly $typeInfo.ArrayElementType
                $actual.IsPrimitiveOrString |Should -BeExactly $typeInfo.IsPrimitiveOrString
            }
            It "Split-JSONPath with segment <Segment>" -TestCases $compositeCases {
                param ( $Segment)
                $root=New-Object -TypeName $rootType
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info

                $actual=Split-JSONPath -InputObject $root -Path $Segment
                $actual | Should -Not -BeNullOrEmpty
                @($actual).Length  | Should -BeExactly 1
                $actual.Segment |Should -BeExactly $typeInfo.Segment
                $actual.PropertyName |Should -BeExactly $typeInfo.PropertyName
                $actual.IsIndexDeclared |Should -BeExactly $typeInfo.IsIndexDeclared
                $actual.PropertyType |Should -BeExactly $typeInfo.PropertyType
                $actual.IsPropertyArray |Should -BeExactly $typeInfo.IsPropertyArray
                $actual.ArrayElementType |Should -BeExactly $typeInfo.ArrayElementType
                $actual.IsPrimitiveOrString |Should -BeExactly $typeInfo.IsPrimitiveOrString
            }
            It "Split-JSONPath with segment Type1Single.Type2Single.StringSingle" {
                $root=New-Object -TypeName $rootType

                $actual=Split-JSONPath -InputObject $root -Path "Type1Single.Type2Single.StringSingle"
                $actual | Should -Not -BeNullOrEmpty
                @($actual).Length  | Should -BeExactly 3
                $actual[0].Segment |Should -BeExactly "Type1Single"
                $actual[0].PropertyName |Should -BeExactly "Type1Single"
                $actual[0].IsIndexDeclared |Should -BeExactly $false
                $actual[0].Index |Should -BeExactly $null
                $actual[0].PropertyType |Should -BeExactly ("JSONPath.Pester.Type1" -as [type])
                $actual[0].IsPropertyArray |Should -BeExactly $false
                $actual[0].ArrayElementType |Should -BeExactly $null
                $actual[0].IsPrimitiveOrString |Should -BeExactly $false

                $actual[1].Segment |Should -BeExactly "Type2Single"
                $actual[1].PropertyName |Should -BeExactly "Type2Single"
                $actual[1].IsIndexDeclared |Should -BeExactly $false
                $actual[10].Index |Should -BeExactly $null
                $actual[1].PropertyType |Should -BeExactly ("JSONPath.Pester.Type2" -as [type])
                $actual[1].IsPropertyArray |Should -BeExactly $false
                $actual[1].ArrayElementType |Should -BeExactly $null
                $actual[1].IsPrimitiveOrString |Should -BeExactly $false

                $actual[2].Segment |Should -BeExactly "StringSingle"
                $actual[2].PropertyName |Should -BeExactly "StringSingle"
                $actual[2].IsIndexDeclared |Should -BeExactly $false
                $actual[2].Index |Should -BeExactly $null
                $actual[2].PropertyType |Should -BeExactly ("System.String" -as [type])
                $actual[2].IsPropertyArray |Should -BeExactly $false
                $actual[2].ArrayElementType |Should -BeExactly $null
                $actual[2].IsPrimitiveOrString |Should -BeExactly $true
            }
            It "Split-JSONPath with segment Type1Array.Type2Array[1].StringArray[3]" {
                $root=New-Object -TypeName $rootType

                $actual=Split-JSONPath -InputObject $root -Path "Type1Array.Type2Array[1].StringArray[3]"
                $actual | Should -Not -BeNullOrEmpty
                @($actual).Length  | Should -BeExactly 3
                $actual[0].Segment |Should -BeExactly "Type1Array"
                $actual[0].PropertyName |Should -BeExactly "Type1Array"
                $actual[0].Index |Should -BeExactly $null
                $actual[0].IsIndexDeclared |Should -BeExactly $false
                $actual[0].PropertyType |Should -BeExactly ("JSONPath.Pester.Type1[]" -as [type])
                $actual[0].IsPropertyArray |Should -BeExactly $true
                $actual[0].ArrayElementType |Should -BeExactly "JSONPath.Pester.Type1"
                $actual[0].IsPrimitiveOrString |Should -BeExactly $false

                $actual[1].Segment |Should -BeExactly "Type2Array[1]"
                $actual[1].PropertyName |Should -BeExactly "Type2Array"
                $actual[1].IsIndexDeclared |Should -BeExactly $true
                $actual[1].Index |Should -BeExactly 1
                $actual[1].PropertyType |Should -BeExactly ("JSONPath.Pester.Type2[]" -as [type])
                $actual[1].IsPropertyArray |Should -BeExactly $true
                $actual[1].ArrayElementType |Should -BeExactly "JSONPath.Pester.Type2"
                $actual[1].IsPrimitiveOrString |Should -BeExactly $false

                $actual[2].Segment |Should -BeExactly "StringArray[3]"
                $actual[2].PropertyName |Should -BeExactly "StringArray"
                $actual[2].IsIndexDeclared |Should -BeExactly $true
                $actual[2].Index |Should -BeExactly 3
                $actual[2].PropertyType |Should -BeExactly ("System.String[]" -as [type])
                $actual[2].IsPropertyArray |Should -BeExactly $true
                $actual[2].ArrayElementType |Should -BeExactly "string"
                $actual[2].IsPrimitiveOrString |Should -BeExactly $true

            }
        }
        Context "Set" {
            It "Set-JSONPathValue with <Segment>=<Value>" -TestCases $valueCases {
                param ( $Segment, $Value, $ArrayLength)
                $root=New-Object -TypeName $rootType
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info
                Set-JSONPathValue -InputObject $root -TypeInfo $typeInfo -Value $Value
                $propertyName=$info.PropertyName
                $actual=$root.$propertyName
                $actual | Should -Not -BeNullOrEmpty
                if($ArrayLength)
                {
                    $actual.Length  | Should -BeExactly $ArrayLength
                    $actual[$ArrayLength-1] | Should -BeExactly $Value
                }
                else {
                    $actual | Should -BeExactly $Value
                }
            }
            It "Set-JSONPathComposite with segment <Segment>" -TestCases $compositeCases {
                param ( $Segment, $ArrayLength)
                $root=New-Object -TypeName $rootType
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info
                Set-JSONPathComposite -InputObject $root -TypeInfo $typeInfo
                $propertyName=$info.PropertyName
                $root.$propertyName | Should -Not -BeNullOrEmpty
                if($ArrayLength)
                {
                    $root.$propertyName.Length  | Should -BeExactly $ArrayLength
                }
            }
        }
        Context "Get" {
            $root=New-Object -TypeName $rootType
            $compositeCases[($compositeCases.Length-1)..0]|ForEach-Object {
                $info=Get-JSONPathSegmentInfo -Segment $_.Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info
                Set-JSONPathComposite -InputObject $root -TypeInfo $typeInfo
            }
            $valueCases[($valueCases.Length-1)..0]|ForEach-Object {
                $info=Get-JSONPathSegmentInfo -Segment $_.Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info
                Set-JSONPathValue -InputObject $root -TypeInfo $typeInfo -Value $_.Value
            }
            It "Get-JSONPathComposite with segment <Segment>" -TestCases $compositeCases {
                param ( $Segment, $ArrayLength)
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info
                $actual=Get-JSONPathComposite -InputObject $root -TypeInfo $typeInfo
                $propertyName=$info.PropertyName
                $root.$propertyName | Should -Not -BeNullOrEmpty
                if($ArrayLength)
                {
                    $root.$propertyName.Length  | Should -BeExactly 3
                }
            }    
            It "Test-JSONPathValue with Segment <Segment> -<Operator> <Value> resolves <Expected>" -TestCases $testCases {
                param ( $Segment, $Operator, $Value, $Expected)
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info

                $splat = @{
                    InputObject=$root
                    Value      = $Value
                }
                $splat.Add($Operator, $true)

                $actual=Test-JSONPathValue -TypeInfo $typeInfo @splat
                $propertyName=$info.PropertyName
                $root.$propertyName | Should -Not -BeNullOrEmpty
                $actual | Should -BeExactly $Expected

            }    
            It "Test-JSONPathValue with Segment <Segment> -<Operator> <Value> throws" -TestCases $invalidTestCases {
                param ( $Segment, $Operator, $Value)
                $info=Get-JSONPathSegmentInfo -Segment $Segment
                $typeInfo=Get-JSONPathSegmentTypeInfo -Type $rootType -Info $info

                $splat = @{
                    InputObject=$root
                    Value      = $Value
                }
                $splat.Add($Operator, $true)

                {Test-JSONPathValue -TypeInfo $typeInfo @splat} | Should -Throw
                $propertyName=$info.PropertyName
                $root.$propertyName | Should -Not -BeNullOrEmpty
            }    
        }
    }
}

Remove-Module -Name JSONPath