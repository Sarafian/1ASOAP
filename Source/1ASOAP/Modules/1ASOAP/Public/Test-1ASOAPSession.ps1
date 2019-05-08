function Test-1ASOAPSession
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(ValueFromPipeline = $false, ParameterSetName = "Pipeline")]
        [ValidateSet("Start","InSeries","End")]
        [string]$TransactionStatusCode
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $Proxy=Get-SOAPProxy -Hashtable $PSBoundParameters

        if($null -eq $Proxy)
        {
            $false
        }
        else {
                
            if($TransactionStatusCode)
            {
                ($Proxy|Get-1ASOAPSession -TransactionStatusCode) -eq $TransactionStatusCode
            }
            else {
                $null -ne ($Proxy|Get-1ASOAPSession)
            }
        }
}

    end
    {

    }
}