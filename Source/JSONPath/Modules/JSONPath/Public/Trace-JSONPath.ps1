function Trace-JSONPath
{
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Trace")]
        [Parameter(Mandatory = $true, ParameterSetName = "Render")]
        [Type]$Type,
        [Parameter(Mandatory = $true, ParameterSetName = "Render")]
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
            'Trace' {
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
            'Render' {
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
                            $code+="`$obj=Set-JSONPath -Path ""$($split[0])"" -Value $($split[1]) -PassThru |"
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