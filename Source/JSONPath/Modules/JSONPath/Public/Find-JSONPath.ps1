function Find-JSONPath
{
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "EQ")]
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "NE")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "EQ")]
        [Parameter(Mandatory = $true, ParameterSetName = "NE")]
        [string]$Path,
        [Parameter(Mandatory = $true, ParameterSetName = "EQ")]
        [Parameter(Mandatory = $true, ParameterSetName = "NE")]
        [AllowNull()]
        [System.Object]$Value,
        [Parameter(Mandatory = $true, ParameterSetName = "EQ")]
        [switch]$EQ,
        [Parameter(Mandatory = $true, ParameterSetName = "NE")]
        [switch]$NE
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $InputObject | ForEach-Object {
            $workingObject=$_
            $typeInfos=Split-JSONPath -InputObject $_ -Path $Path
            $level=0
            $foundObject=$true
            while ($foundObject -and ($level -lt $typeInfos.Length-1)) {
                $workingObject=$workingObject|ForEach-Object {
                    Get-JSONPathComposite -InputObject $_ -TypeInfo $typeInfos[$level]
                }| Where-Object { $_ -ne $null }
                $foundObject=@($workingObject).Length -ne 0 
                $level++
            }
            if($foundObject)
            {
                $testValues=$workingObject|ForEach-Object {
                    $testSplat = @{ } + $PSBoundParameters
                    $testSplat.Remove("InputObject")
                    $testSplat.Remove("Path")
                    $testSplat.Add("InputObject", $_)
                    $testSplat.Add("TypeInfo", $typeInfos[$level])
                    if(Test-JSONPathValue @testSplat)
                    {
                        $_
                    }
                }
                $foundObject=@($testValues).Length -ne 0
            }
            if($foundObject)
            {
                $_
            }
        }
    }

    end
    {

    }
}