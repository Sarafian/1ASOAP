function Set-JSONPathComposite
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
        if($TypeInfo.IsPrimitiveOrString)
        {
            # TODO: Throw better error
            throw "Primitives or System.String properties can be referenced only as the last segment in the JSONPath"
        }

        $propertyName=$TypeInfo.PropertyName

        if ($TypeInfo.IsPropertyArray -and (-not $TypeInfo.IsIndexDeclared)) {
            $normalizedIndex = 0
            $normalizedSegment = "$($TypeInfo.Segment)[$normalizedIndex]"
            Write-Warning "$prefix not declaring index when setting. Treating as $normalizedSegment"
        }
        else {
            $normalizedIndex = $TypeInfo.Index
            $normalizedSegment=$TypeInfo.Segment
        }
        Write-Debug "$prefix normalizedSegment=$normalizedSegment | normalizedIndex=$normalizedIndex"

        # If the target property is array and is not null
        if ($TypeInfo.IsPropertyArray) {
            if($null -eq $InputObject.$propertyName)
            {
                $InputObject.$propertyName = New-Object $TypeInfo.PropertyType -ArgumentList ($normalizedIndex + 1)
                Write-Debug "$prefix. Initialized with array of $($TypeInfo.ArrayElementType) with length $($normalizedIndex+1)"
            }
            else {
                # TODO: What if the array is of smaller length?
            }
        }
        $returnObject=$null
        if($TypeInfo.IsPropertyArray)
        {
            # Make sure that the target property has a composite value
            if($null -eq $InputObject.$propertyName[$normalizedIndex])
            {
                $InputObject.$propertyName[$normalizedIndex] = New-Object $TypeInfo.ArrayElementType
                Write-Debug "$prefix. New instance of $($TypeInfo.ArrayElementType)"
            }
            $returnObject=$InputObject.$propertyName[$normalizedIndex]
        }
        else
        {
            # Make sure that the target property has a composite value
            if ($null -eq $InputObject.$propertyName) {
                $InputObject.$propertyName = New-Object $TypeInfo.PropertyType
                Write-Debug "$prefix. New instance of $($TypeInfo.PropertyType)"
            }
            $returnObject=$InputObject.$propertyName
        }
        $returnObject
    }

    end
    {

    }
}