function Trace-JSONPath
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "ObjectTrace")]
        [System.Object]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = "TypeTrace")]
        [Parameter(Mandatory = $true, ParameterSetName = "TypeRender")]
        [Type]$Type,
        [Parameter(Mandatory = $true, ParameterSetName = "TypeRender")]
        [switch]$RenderCode
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        switch ($PSCmdlet.ParameterSetName) {
            'ObjectTrace' {
                $Type=$InputObject.GetType()
                $typeInfos=$Type.GetProperties()|ForEach-Object {
                    Get-JSONPathSegmentTypeInfo -PropertyName $_.Name -Type $Type -Trace
                }

                $typeInfos| Where-Object -Property IsPrimitiveOrString -EQ $false| ForEach-Object {
                    $typeInfo=$_
                    $propertyName=$typeInfo.PropertyName
                    $propertyValue=$InputObject.$propertyName
                    $trace=$propertyName
                    if($propertyValue)
                    {
                        if($typeInfo.IsPropertyArray)
                        {
                            for($i=0;$i -lt $propertyValue.Count;$i++)
                            {
                                if($propertyValue[$i])
                                {
                                    Trace-JSONPath -InputObject $propertyValue[$i]|ForEach-Object {
                                        $trace+"[$i]."+$_
                                    }
                                }
                            }
                        }
                        else {
                            Trace-JSONPath -InputObject $propertyValue|ForEach-Object {
                                $trace+"."+$_
                            }
                        }
                    }
                }
                $typeInfos|Where-Object -Property IsPrimitiveOrString -EQ $true | ForEach-Object {
                    $typeInfo=$_
                    $propertyName=$typeInfo.PropertyName
                    $propertyValue=$InputObject.$propertyName
                    $trace=$propertyName
                    if($propertyValue)
                    {
                        if($typeInfo.IsPropertyArray)
                        {
                            for($i=0;$i -lt $propertyValue.Count;$i++)
                            {
                                if($typeInfo.ArrayElementType -eq [System.String])
                                {
                                    $trace+"[$i]=`"$($propertyValue[$i])`"$(if($null -eq $propertyValue[$i]){'(null)'})"
                                }
                                else {
                                    $trace+"[$i]=$($propertyValue[$i])"
                                }
                            }
                        }
                        else {
                            if($typeInfo.PropertyType -eq [System.String])
                            {
                                $trace+"=`"$propertyValue`""
                            }
                            else {
                                $trace+"=$propertyValue"
                            }
                        }
                    }
                }
            }
            'TypeTrace' {
                $typeInfos=$Type.GetProperties()|ForEach-Object {
                    Get-JSONPathSegmentTypeInfo -PropertyName $_.Name -Type $Type -Trace
                }
                $typeInfos|Where-Object -Property IsPrimitiveOrString -EQ $false |ForEach-Object {
                    $trace=$_.Trace
                    if($_.IsPropertyArray)
                    {
                        $typeToExpand=$_.ArrayElementType
                    }
                    else {
                        $typeToExpand=$_.PropertyType
                    }
                    Trace-JSONPath -Type $typeToExpand|ForEach-Object {
                        $trace+"."+$_
                    }
                }
                $typeInfos|Where-Object -Property IsPrimitiveOrString -EQ $true |Select-Object -ExpandProperty Trace
            }
            'TypeRender' {
                $traces=Trace-JSONPath -Type $Type

                $code=@(
                    "`$obj=New-Object -TypeName ""$($Type.FullName)"""
                )
                if($traces.Count -eq 0)
                {
                }
                elseif($traces.Count -eq 1)
                {
                    $split=$traces[0]-split "="
                    $code+="`$obj=Set-JSONPath -Path ""$($split[0])"" -Value $($split[1])"
                }
                else {
                    for($i=0;$i -lt $traces.Count;$i++)
                    {
                        $split=$traces[$i]-split "="
                        if($i -eq 0)
                        {
                            $code+="`$obj=`$obj | Set-JSONPath -Path ""$($split[0])"" -Value $($split[1]) -PassThru |"
                        }
                        elseif($i -eq $traces.Count -1)
                        {
                            $code+="`tSet-JSONPath -Path ""$($split[0])"" -Value $($split[1])"
                        }
                        else {
                            $code+="`tSet-JSONPath -Path ""$($split[0])"" -Value $($split[1]) -PassThru |"
                        }
                    }
                }
                $code -join [System.Environment]::NewLine
            }
        }    
    }
    end
    {

    }
}