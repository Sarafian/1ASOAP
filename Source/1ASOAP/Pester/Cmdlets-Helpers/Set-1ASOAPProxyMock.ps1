function Set-1ASOAPProxyMock
{
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [switch]$PassThru
    )
    if (-not ("SOAP.Pester.Set1ASOAPProxyMock.Proxy" -as [type]))
    {
        Add-Type -Path "$PSScriptRoot\..\CS\Set-1ASOAPProxyMock.cs"
    }
    if(-Not $Proxy)
    {
        $Proxy=New-Object -TypeName "SOAP.Pester.Set1ASOAPProxyMock.Proxy"
    }
    $Proxy.SessionValue=New-Object -TypeName "SOAP.Pester.Set1ASOAPProxyMock.SessionValue"
<#
    $Proxy.AMA_SecurityHostedUserValue=New-Object -TypeName 1ASOAP.Pester.Set1ASOAPProxyMock.AMA_SecurityHostedUserValue
    $Proxy.AMA_SecurityHostedUserValue.UserID=New-Object -TypeName 1ASOAP.Pester.Set1ASOAPProxyMock.UserID
    $Proxy.AMA_SecurityHostedUserValue.UserID.RequestorID=New-Object -TypeName 1ASOAP.Pester.Set1ASOAPProxyMock.RequestorID
    $Proxy.AMA_SecurityHostedUserValue.UserID.RequestorID.CompanyName=New-Object -TypeName 1ASOAP.Pester.Set1ASOAPProxyMock.CompanyName
#>
    <#
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
#>    
    if($PassThru)
    {
        $Proxy
    }
}