function Set-1ASOAPProxyMock
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [switch]$PassThru
    )
    if(-Not $Proxy)
    {
        $Proxy=[PSCustomObject]@{
            SessionValue = $null
            AMA_SecurityHostedUserValue = $null
        }
    }
    $Proxy.SessionValue=[PSCustomObject]@{
        TransactionStatusCode=[string]$null
    }
    $Proxy.AMA_SecurityHostedUserValue = [PSCustomObject]@{
        UserID=[PSCustomObject]@{
            POS_Type=[string]$null
            RequestorType=[string]$null
            PseudoCityCode=[string]$null
            AgentDutyCode=[string]$null
            RequestorID=[PSCustomObject]@{
                CompanyName=[PSCustomObject]@{
                    Value=[string]$null
                }                    
            }
        }
    }
    if($PassThru)
    {
        $Proxy
    }
}