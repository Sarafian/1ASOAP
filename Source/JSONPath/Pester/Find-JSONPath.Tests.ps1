$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\JSONPath\JSONPath.psm1 -Force


$prefix=($sut -replace '\.ps1','')+" Tests:"

if (-not ("JSONPath.Pester.Root" -as [type]))
{
    Add-Type -Path "$here\CS\JSONPath.Pester.cs"
}

. $here\Cmdlets-Helpers\Get-RandomValue.ps1
$randomString = (Get-RandomValue -String).Replace("Random", "Stable")
$randomInt = (Get-RandomValue -Int) - 10000

$maxArrayLength = 3
$root = [JSONPath.Pester.Root]::new()
$root | 
    Set-JSONPath -Path "StringSingle" -Value (Get-RandomValue -String) -PassThru |
    Set-JSONPath -Path "IntSingle" -Value (Get-RandomValue -Int) -PassThru |
    Set-JSONPath -Path "Type1Single.StringSingle" -Value (Get-RandomValue -String) -PassThru |
    Set-JSONPath -Path "Type1Single.IntSingle" -Value (Get-RandomValue -Int)

for ($i = $maxArrayLength - 1; $i -ge 0; $i--)
{
    if ($i -eq 0)
    {
        $iterationRandomString = Get-RandomValue -String
        $iterationRandomInt = Get-RandomValue -Int
    }
    else
    {
        $iterationRandomString = $randomString
        $iterationRandomInt = $randomInt
    }
    $root | Set-JSONPath -Path "StringArray[$i]" -Value $iterationRandomString
    $root | Set-JSONPath -Path "IntArray[$i]" -Value $iterationRandomInt
}    

#$root | Set-JSONPath -Path "Type1Array[$($maxArrayLength+1)]" -Value $null
#for($type1Index=0;$type1Index -lt $maxArrayLength;$type1Index++)
for ($type1Index = $maxArrayLength - 1; $type1Index -ge 0; $type1Index--)
{
    if ($type1Index -eq 0)
    {
        $iterationRandomString = Get-RandomValue -String
        $iterationRandomInt = Get-RandomValue -Int
    }
    else
    {
        $iterationRandomString = $randomString
        $iterationRandomInt = $randomInt
    }
    $root | Set-JSONPath -Path "Type1Array[$type1Index].StringSingle" -Value $iterationRandomString
    $root | Set-JSONPath -Path "Type1Array[$type1Index].IntSingle" -Value $iterationRandomInt

    for ($i = $maxArrayLength - 1; $i -ge 0; $i--)
    {
        if ($i -eq 0)
        {
            $iterationRandomString = Get-RandomValue -String
            $iterationRandomInt = Get-RandomValue -Int
        }
        else
        {
            $iterationRandomString = $randomString
            $iterationRandomInt = $randomInt
        }
        $root | Set-JSONPath -Path "Type1Array[$type1Index].StringArray[$i]" -Value $iterationRandomString
    $root | Set-JSONPath -Path "Type1Array[$type1Index].IntArray[$i]" -Value $iterationRandomInt
    }

    $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Single.StringSingle" -Value (Get-RandomValue -String)
    $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Single.IntSingle" -Value (Get-RandomValue -Int)
#    $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Array[$($maxArrayLength+1)]" -Value $null
        
    #    for($type2Index=0;$type2Index -lt $maxArrayLength;$type2Index++)
    for ($type2Index = $maxArrayLength - 2; $type2Index -ge 0; $type2Index--)
    {
        if ($type2Index -eq 0)
        {
            $iterationRandomString = Get-RandomValue -String
            $iterationRandomInt = Get-RandomValue -Int
        }
        else
        {
            $iterationRandomString = $randomString
            $iterationRandomInt = $randomInt
        }
        $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Array[$type2Index].StringSingle" -Value $iterationRandomString
        $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Array[$type2Index].IntSingle" -Value $iterationRandomInt
            
        for ($i = $maxArrayLength - 2; $i -ge 0; $i--)
        {
            if ($i -eq 0)
            {
                $iterationRandomString = Get-RandomValue -String
                $iterationRandomInt = Get-RandomValue -Int
            }
            else
            {
                $iterationRandomString = $randomString
                $iterationRandomInt = $randomInt
            }
            $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Array[$type2Index].StringArray[$i]" -Value $iterationRandomString
            $root | Set-JSONPath -Path "Type1Array[$type1Index].Type2Array[$type2Index].IntArray[$i]" -Value $iterationRandomInt
        }

    }
}
$rootTestCases = @(
    @{
        Path = "StringSingle"
        Operator   = "EQ"
        Value      = $root.StringSingle
    }    
    @{
        Path = "IntSingle"
        Operator   = "EQ"
        Value      = $root.IntSingle
    }    
    @{
        Path = "Type1Single.StringSingle"
        Operator   = "EQ"
        Value      = $root.Type1Single[0].StringSingle
    }    
    @{
        Path = "Type1Single.IntSingle"
        Operator   = "EQ"
        Value      = $root.Type1Single[0].IntSingle
    }    
    @{
        Path = "StringSingle"
        Operator   = "NE"
        Value      = $null
    }    
    @{
        Path = "IntSingle"
        Operator   = "NE"
        Value      = $null
    }    
    @{
        Path = "Type1Single.StringSingle"
        Operator   = "NE"
        Value      = $null
    }    
    @{
        Path = "Type1Single.IntSingle"
        Operator   = "NE"
        Value      = $null
    }    
    @{
        Path = "Type1Array.StringSingle"
        Operator   = "EQ"
        Value      = $randomString
    }    
    @{
        Path = "Type1Array.IntSingle"
        Operator   = "EQ"
        Value      = $randomInt
    }    
    @{
        Path = "Type1Array.StringSingle"
        Operator   = "NE"
        Value      = $randomString
    }    
    @{
        Path = "Type1Array.IntSingle"
        Operator   = "NE"
        Value      = $randomInt
    }    
)

$type1TestCases = @(
    @{
        Path = "StringSingle"
        Operator   = "EQ"
        Value      = $root.Type1Array[0].StringSingle
    }    
    @{
        Path = "IntSingle"
        Operator   = "EQ"
        Value      = $root.Type1Array[0].IntSingle
    }    
    @{
        Path    = "StringSingle"
        Operator      = "EQ"
        Value         = $randomString
        ExpectedCount = $maxArrayLength - 1
    }    
    @{
        Path    = "IntSingle"
        Operator      = "EQ"
        Value         = $randomInt
        ExpectedCount = $maxArrayLength - 1
    }    
    @{
        Path    = "Type2Single.StringSingle"
        Operator      = "EQ"
        Value         = $randomString
        ExpectedCount = 0
    }    
    @{
        Path    = "Type2Single.IntSingle"
        Operator      = "EQ"
        Value         = $randomInt
        ExpectedCount = 0
    }    
    @{
        Path    = "StringSingle"
        Operator      = "NE"
        Value         = $null
        ExpectedCount = $maxArrayLength
    }    
    @{
        Path    = "IntSingle"
        Operator      = "NE"
        Value         = $null
        ExpectedCount = $maxArrayLength
    }    
    @{
        Path    = "Type2Single.StringSingle"
        Operator      = "NE"
        Value         = $null
        ExpectedCount = $maxArrayLength
    }    
    @{
        Path    = "Type2Single.IntSingle"
        Operator      = "NE"
        Value         = $null
        ExpectedCount = $maxArrayLength
    }    
    @{
        Path    = "Type2Array.StringSingle"
        Operator      = "NE"
        Value         = $null
        ExpectedCount = $maxArrayLength
    }    
    @{
        Path    = "Type2Array.IntSingle"
        Operator      = "NE"
        Value         = $null
        ExpectedCount = $maxArrayLength
    }    
)
$notResolvingTestCases = @(
    "Type1Array[$maxArrayLength].StringSingle"
) | ForEach-Object {
    @{
        Path = $_
        Operator   = "EQ"
        ExpectedCount=0
        Value=Get-RandomValue -String
    }
    @{
        Path = $_
        Operator   = "NE"
        ExpectedCount=0
        Value=Get-RandomValue -String
    }
}

$invalidTestCases = @(
    "StringArray[0]"
    "StringArray[1]"
    "IntArray[0]"
    "IntArray[1]"
    "Type1Array[1].StringArray[0]"
    "Type1Single.StringArray[0]"
) | ForEach-Object {
    @{
        Path = $_
        Operator   = "EQ"
    }
    @{
        Path = $_
        Operator   = "NE"
    }
}

@(
    $rootTestCases
    $type1TestCases
) | ForEach-Object {
    $_ | ForEach-Object {
        if (-not $_.ContainsKey("ExpectedCount"))
        {
            $_.Add("ExpectedCount", 1)
        }
    }
}

$itTitle = '| Find-JSONPath -Path "<Path>" -<Operator> "<Value>" resolves to <ExpectedCount> object(s)'

Describe "$prefix" {
    Context "Root" {
        It "Root $itTitle" -TestCases $rootTestCases {
            param ( $Path, $Operator, $Value, $ExpectedCount )
            $splat = @{
                Path = $Path
                Value      = $Value
            }
            $splat.Add($Operator, $true)
            $actual = $root | Find-JSONPath @splat
            @($actual).Length | Should -BeExactly $ExpectedCount

            if($ExpectedCount -eq 0)
            {
                $actual | Should -BeNullOrEmpty
            }
            else {
                $actual | Should -Not -BeNullOrEmpty
                if($ExpectedCount -eq 1)
                {
                    $actual | SHould -BeOfType [JSONPath.Pester.Root]
                }
            }
        }
    }

    Context "Root.Type1Array" {
        It "Root.Type1Array $itTitle" -TestCases $type1TestCases {
            param ( $Path, $Operator, $Value, $ExpectedCount )
            $splat = @{
                Path = $Path
                Value      = $Value
            }
            $splat.Add($Operator, $true)
            $actual = $root.Type1Array | Where-Object { $_ -ne $null } | Find-JSONPath @splat
            @($actual).Length | Should -BeExactly $ExpectedCount

            if($ExpectedCount -eq 0)
            {
                $actual | Should -BeNullOrEmpty
            }
            else {
                $actual | Should -Not -BeNullOrEmpty
                if($ExpectedCount -eq 1)
                {
                    $actual | SHould -BeOfType [JSONPath.Pester.Type1]
                }
            }
        }
    }
    Context "Not resolving" {
        It "Not resolving $itTitle" -TestCases $notResolvingTestCases {
            param ( $Path, $Operator, $ExpectedCount ,$Value)
            $splat = @{
                Path = $Path
                Value      = $Value
            }
            $splat.Add($Operator, $true)
            $actual = $root | Find-JSONPath @splat
            @($actual).Length | Should -BeExactly $ExpectedCount
            $actual | Should -BeNullOrEmpty
        }
    }
    Context "Invalid" {
        It "Invalid <Path> -<Operator> throws error" -TestCases $invalidTestCases {
            param ( $Path, $Operator )
            $splat = @{
                Path = $Path
                Value      = $null
            }
            $splat.Add($Operator, $true)
            { $root | Find-JSONPath @splat } | Should -Throw
        }
    }
}
