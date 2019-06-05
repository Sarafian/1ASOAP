function Trace-JSONPathSegmentTypeInfo
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Info")]
        [psobject]$TypeInfo
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

    }

    process
    {
        if($TypeInfo.IsPrimitiveOrString)
        {
            
        }
        else {
            if($TypeInfo.IsPropertyArray)
            {
                $subTypeInfos=Expand-Type -Type $_.ArrayElementType
            }
            else {
                $subTypeInfos=Expand-Type -Type $_.PropertyType
            }
        }

    }

    end
    {

    }
}