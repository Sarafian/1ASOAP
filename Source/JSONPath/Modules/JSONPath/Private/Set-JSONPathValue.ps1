function Set-JSONPathValue
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [psobject]$TypeInfo,
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [AllowNull()]
        [System.Object]$Value
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

        $prefix="[$($TypeInfo.Segment)]"
    }

    process
    {
        if(-not $TypeInfo.IsPrimitiveOrString)
        {
            # TODO: Throw better error
            throw "When setting values in JSONPath, the target property must be a primitive or a System.String"
        }

        $propertyName=$TypeInfo.PropertyName
        # Setting the value
        if ($TypeInfo.IsPropertyArray) {
            if(-not $TypeInfo.IsIndexDeclared)
            {
                $normalizedIndex = 0
                $normalizedSegment = "$($Info.Segment)[$normalizedIndex]"
                Write-Warning "$prefix not declaring index when setting. Treating as $normalizedSegment"
            }
            else {
                $normalizedIndex = $typeInfo.Index
                $normalizedSegment=$Info.Segment
            }
            if($null -eq $InputObject.$propertyName)
            {
                $InputObject.$propertyName = New-Object $TypeInfo.PropertyType -ArgumentList ($normalizedIndex + 1)
                Write-Debug "$prefix. Initialized with array of $($TypeInfo.ArrayElementType) with length $($normalizedIndex+1)"
            }
            else {
                # TODO: What if the array is of smaller length?
            }

            Write-Debug "$prefix normalizedSegment=$normalizedSegment | normalizedIndex=$normalizedIndex"
            $InputObject.$propertyName[$normalizedIndex] = $Value
        }
        else {
            if(($null -eq $Value) -and ($TypeInfo.PropertyType.FullName -eq "System.String"))
            {
                # TODO: Can't nullify the string
                # TODO: Add invalid test
                throw "Cannot set null value to string property"
            }
            $InputObject.$propertyName = $Value   
        }
        Write-Debug "$prefix. Set value $Value"
    }

    end
    {

    }
}