function Set-1ASOAPSessionAMAHeader
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [Parameter(Mandatory = $false, ParameterSetName = "PSSession")]
        [string]$POSType,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [Parameter(Mandatory = $false, ParameterSetName = "PSSession")]
        [string]$RequestorType,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [Parameter(Mandatory = $false, ParameterSetName = "PSSession")]
        [string]$PseudoCityCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [Parameter(Mandatory = $false, ParameterSetName = "PSSession")]
        [string]$AgentDutyCode,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [Parameter(Mandatory = $false, ParameterSetName = "PSSession")]
        [string]$CompanyName,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [Parameter(Mandatory = $false, ParameterSetName = "Pipeline")]
        [switch]$PassThru,
        [Parameter(Mandatory = $true, ParameterSetName = "PSSession")]
        [string]$Uri
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        if($PSCmdlet.ParameterSetName -eq "PSSession")
        {
            $baseName="1ASOAP:Set-1ASOAPSessionAMAHeader:$Uri"
            Write-Debug "baseName=$baseName"
            Set-Variable -Name "$($baseName):POSType" -Value $POSType -Scope Global
            Set-Variable -Name "$($baseName):RequestorType" -Value $RequestorType -Scope Global
            Set-Variable -Name "$($baseName):PseudoCityCode" -Value $PseudoCityCode -Scope Global
            Set-Variable -Name "$($baseName):AgentDutyCode" -Value $AgentDutyCode -Scope Global
            Set-Variable -Name "$($baseName):CompanyName" -Value $CompanyName -Scope Global
        }
        else {
            $Proxy=Get-SOAPProxy -Hashtable $PSBoundParameters
            $baseName="1ASOAP:Set-1ASOAPSessionAMAHeader:$($Proxy.Url)"
            Write-Debug "baseName=$baseName"

            if(-not $POSType)
            {
                $POSType=Get-Variable -Name "$($baseName):POSType" -ValueOnly -Scope Global -ErrorAction SilentlyContinue
            }
            if(-not $RequestorType)
            {
                $RequestorType=Get-Variable -Name "$($baseName):RequestorType" -ValueOnly -Scope Global -ErrorAction SilentlyContinue
            }
            if(-not $PseudoCityCode)
            {
                $PseudoCityCode=Get-Variable -Name "$($baseName):PseudoCityCode" -ValueOnly -Scope Global -ErrorAction SilentlyContinue
            }
            if(-not $AgentDutyCode)
            {
                $AgentDutyCode=Get-Variable -Name "$($baseName):AgentDutyCode" -ValueOnly -Scope Global -ErrorAction SilentlyContinue
            }
            if(-not $CompanyName)
            {
                $CompanyName=Get-Variable -Name "$($baseName):CompanyName" -ValueOnly -Scope Global -ErrorAction SilentlyContinue
            }

            $Proxy | Clear-1ASOAPSessionAMAHeader
            if($POSType)
            {
                $Proxy | Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.POS_Type" -Value $POSType
            }
            if($RequestorType)
            {
                $Proxy | Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.RequestorType" -Value $RequestorType
            }
            if($PseudoCityCode)
            {
                $Proxy | Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.PseudoCityCode" -Value $PseudoCityCode
            }
            if($AgentDutyCode)
            {
                $Proxy | Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.AgentDutyCode" -Value $AgentDutyCode
            }
            if($CompanyName)
            {
                $Proxy | Set-JSONPath -Path "AMA_SecurityHostedUserValue.UserID.RequestorID.CompanyName.Value" -Value $CompanyName
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