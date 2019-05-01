function Set-1ASOAPSessionAMAHeader
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [string]$POSType = "1",
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [string]$RequestorType = "U",
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [string]$PseudoCityCode = "BRUSN08AA",
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [string]$AgentDutyCode = "GS",
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [string]$CompanyName = "SN",
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
            Clear-1ASOAPSessionAMAHeader -PassThru |
            Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.POS_Type" -Value $POSType -PassThru |
            Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.RequestorType" -Value $RequestorType -PassThru |
            Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.PseudoCityCode" -Value $PseudoCityCode -PassThru |
            Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.AgentDutyCode" -Value $AgentDutyCode -PassThru |
            Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.RequestorID.CompanyName.Value" -Value $CompanyName
    }

    end
    {
        if ($PassThru)
        {
            $Proxy
        }
    }
}