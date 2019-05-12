function Split-JSONPath
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [string]$Path
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

    }

    process
    {
        $segmentInfos=$Path -split "\." |ForEach-Object {Get-JSONPathSegmentInfo -Segment $_}
        $typePathInfos=@()
        $currentType=$InputObject.GetType()
        foreach($segmentInfo in $segmentInfos)
        {
            $typeInfo=Get-JSONPathSegmentTypeInfo -Info $segmentInfo -Type $currentType
            if($typeInfo.IsPropertyArray)
            {
                $currentType=$typeInfo.ArrayElementType
            }
            else {
                $currentType=$typeInfo.PropertyType
            }
            $typePathInfos+=$typeInfo
        }
        $typePathInfos
    }

    end
    {

    }
}