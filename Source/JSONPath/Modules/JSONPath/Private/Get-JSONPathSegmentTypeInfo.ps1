function Get-JSONPathSegmentTypeInfo
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Info")]
        [Parameter(Mandatory = $true, ParameterSetName = "Trace")]
        [System.Type]$Type,
        [Parameter(Mandatory = $true, ParameterSetName = "Info")]
        [psobject]$Info,
        [Parameter(Mandatory = $true, ParameterSetName = "Trace")]
        [string]$PropertyName,
        [Parameter(Mandatory = $true, ParameterSetName = "Trace")]
        [switch]$Trace
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

        switch($PSCmdlet.ParameterSetName)
        {
            'Info' {
                $prefix="[$($Info.Segment)]"
            }
            'Trace' {
                $prefix="[$PropertyName]"
            }
        }
    }

    process
    {
        switch($PSCmdlet.ParameterSetName)
        {
            'Info' {
                $typeInfoHash=@{
                    Segment=$Info.Segment
                    PropertyName=$Info.PropertyName
                    IsIndexDeclared=$Info.IsIndexDeclared
                    Index=$Info.Index
                }
            }
            'Trace' {
                $typeInfoHash=@{
                    PropertyName=$PropertyName
                }
            }
        }

        $propertyType = $Type.GetProperty($typeInfoHash.PropertyName).PropertyType
        if($null -eq $propertyType)
        {
            throw "$Segment is invalid for type $Type"
        }
        Write-Debug "$prefix propertyType=$propertyType | propertyType.BaseType.Name=$($propertyType.BaseType.Name) | propertyType.IsArray=$($propertyType.IsArray) | propertyType.IsPrimitive=$($propertyType.IsPrimitive) | propertyType.IsClass=$($propertyType.IsClass)"

        $typeInfoHash.Add("PropertyType",$propertyType)

        $typeInfoHash.Add("IsPropertyArray",$propertyType.IsArray)
        # If the property is an array extract the element type of the array
        if ($propertyType.IsArray) {
            $propertyElementType = $propertyType.GetElementType()
            Write-Debug "$prefix propertyElementType=$propertyElementType | propertyElementType.BaseType.Name=$($propertyElementType.BaseType.Name) | propertyElementType.IsArray=$($propertyElementType.IsArray) | $prefix propertyElementType.IsPrimitive=$($propertyElementType.IsPrimitive) | $prefix propertyElementType.IsClass=$($propertyElementType.IsClass)"
            $typeInfoHash.Add("ArrayElementType",$propertyElementType)
            $typeInfoHash.Add("IsPrimitiveOrString",$propertyElementType.IsPrimitive -or ($propertyElementType.FullName -eq "System.String"))
        }
        else {
            $typeInfoHash.Add("ArrayElementType",$null)
            $typeInfoHash.Add("IsPrimitiveOrString",$propertyType.IsPrimitive -or ($propertyType.FullName -eq "System.String"))
        }
        
        if($PSCmdlet.ParameterSetName -eq "Trace")
        {
            if ($propertyType.IsArray) {
                $typeInfoHash.Add("Segment","$PropertyName[0]")
                $typeInfoHash.Add("IsIndexDeclared",$true)
                $typeInfoHash.Add("Index",0)
                $traceValueType=$typeInfoHash.ArrayElementType
            }
            else {
                $typeInfoHash.Add("Segment",$PropertyName)
                $typeInfoHash.Add("IsIndexDeclared",$false)
                $typeInfoHash.Add("Index",$null)
                $traceValueType=$typeInfoHash.PropertyType
            }
            $traceSegments=@(
                $typeInfoHash.Segment
            )
            if($typeInfoHash.IsPrimitiveOrString)
            {
                if($traceValueType.FullName -eq "System.String")
                {
                    $traceSegments+='"String"'
                }
                else {
                    $traceSegments+='0'
                }
            }
            $typeInfoHash.Add("Trace",($traceSegments -join "="))
        }
        New-Object -TypeName psobject -Property $typeInfoHash
    }

    end
    {

    }
}