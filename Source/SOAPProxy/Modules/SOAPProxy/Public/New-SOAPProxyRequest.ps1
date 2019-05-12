function New-SOAPProxyRequest
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $true, ParameterSetName = "Pipeline")]
        [string]$Operation
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $info=Get-SOAPProxy -Hashtable $PSBoundParameters| Get-SOAPProxyInfo
        
        $requestType=$info|Where-Object -Property Operation -EQ $Operation|Select-Object -ExpandProperty RequestType
        Write-Debug "requestType=$requestType"
        if($requestType.FullName -eq "System.String")
        {
            ""
        }
        else {
            New-Object -TypeName $requestType
        }
    }

    end
    {

    }
}