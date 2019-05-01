function Start-1ASOAPSession
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [switch]$PassThru
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $Proxy=Get-SOAPProxy -Hashtable $PSBoundParameters

        $Proxy |
            Clear-1ASOAPSession -PassThru |
            Set-JSONPath -Path "SessionValue.TransactionStatusCode" -Value "Start"
    }

    end
    {
        if ($PassThru)
        {
            $Proxy
        }
    }
}