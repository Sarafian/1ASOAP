function Get-JSONPathSegmentTypeInfo
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [System.Type]$Type,
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [psobject]$Info
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}

        $prefix="[$($Info.Segment)]"
    }

    process
    {
        $typeInfoHash=@{
            Segment=$Info.Segment
            PropertyName=$Info.PropertyName
            IsIndexDeclared=$Info.IsIndexDeclared
            Index=$Info.Index
        }

        $propertyType = $Type.GetProperty($Info.PropertyName).PropertyType
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

        New-Object -TypeName psobject -Property $typeInfoHash
    }

    end
    {

    }
}