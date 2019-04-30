function Get-JSONPathComposite
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [psobject]$TypeInfo
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

        $prefix="[$($TypeInfo.Segment)]"
    }

    process
    {
        $propertyName = $segmentInfo.PropertyName
        $segment=$segmentInfo.Segment
        if ($TypeInfo.IsIndexDeclared)
        {
            $index = $TypeInfo.Index
            $resolveObject = $InputObject | Where-Object {
                ($null -ne $_.$propertyName) -and ($null -ne $_.$propertyName[$index])
            } | ForEach-Object {
                $_.$propertyName[$index]
            }
        }
        else
        {
            $resolveObject = $InputObject.$segment
        }
        $resolveObject = $resolveObject | Where-Object { $_ -ne $null }
        Write-Debug "$prefix found $(@($resolveObject).Length) objects"
        if (@($resolveObject).Length -ne 0)
        {
            @($resolveObject)
        }
        else
        {
            $null
        }
    }

    end
    {

    }
}