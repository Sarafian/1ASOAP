function Set-JSONPath
{
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "Pipeline")]
        [String]$Path,
        [Parameter(Mandatory = $true, ParameterSetName = "Pipeline")]
        [AllowNull()]
        [System.Object]$Value,
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [switch]$PassThru
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
            while ($level -lt $typeInfos.Length-1) {
                $workingObject=Set-JSONPathComposite -InputObject $workingObject -TypeInfo $typeInfos[$level]
                $level++
            }
            Set-JSONPathValue -InputObject $workingObject -TypeInfo $typeInfos[$level] -Value $Value
            Write-Verbose "Set Value $Value to $Path"
            if($PassThru)
            {
                $InputObject
            }
        }
    }

    end
    {

    }
}