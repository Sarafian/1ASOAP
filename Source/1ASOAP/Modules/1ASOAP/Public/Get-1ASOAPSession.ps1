function Get-1ASOAPSession
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(ValueFromPipeline = $false, ParameterSetName = "Pipeline")]
        [switch]$TransactionStatusCode
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $Proxy=Get-SOAPProxy -Hashtable $PSBoundParameters

        if($null -ne $Proxy.SessionValue)
        {
            if($TransactionStatusCode)
            {
                $Proxy.SessionValue.TransactionStatusCode
            }
            else {
                $Proxy.SessionValue
            }
        }
        else {
            if($TransactionStatusCode)
            {
                "None"
            }
            else {
                $null
            }            
        }
    }

    end
    {
        if ($PassThru)
        {
            $Proxy
        }
    }
}