function Test-JSONPathValue
{
    param(
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "EQ")]
        [Parameter(ValueFromPipeline = $true, ParameterSetName = "NE")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "EQ")]
        [Parameter(Mandatory = $true, ParameterSetName = "NE")]
        [psobject]$TypeInfo,
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

        $prefix="[$($TypeInfo.Segment)]"
    }

    process
    {
        $propertyName = $TypeInfo.PropertyName
        
        $whereObjectSplat = @{ } + $PSBoundParameters
        $whereObjectSplat.Remove("InputObject")
        $whereObjectSplat.Remove("TypeInfo")
        $whereObjectSplat.Add("Property", $propertyName)
        if ($TypeInfo.IsPropertyArray)
        {
            # TODO: Index on last part of segmenet are not supported
            throw "Properties with arrays $segment are not supported"
        }
        if($null -eq $InputObject.$propertyName)
        {
            $false
        }
        $null -ne ($InputObject | Where-Object @whereObjectSplat)
    }

    end
    {

    }
}