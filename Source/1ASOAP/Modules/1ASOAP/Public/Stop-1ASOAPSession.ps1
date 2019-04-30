function Stop-1ASOAPSession
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
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) { Write-Debug "$($psbp.Key)=$($psbp.Value)" }
    }

    process
    {
        $Proxy=Get-1ASOAPProxyInternal -Hashtable $PSBoundParameters

        try
        {
            $transactionStatusCode = $Proxy | Get-1ASOAPSession -TransactionStatusCode
            Write-Debug "transactionStatusCode=$transactionStatusCode"
            if ($transactionStatusCode -in @("Start", "InSeries"))
            {
                $securitySignOut = $proxy |New-1ASOAPRequest -Operation Security_SignOut
                # TODO Why Security_SignOut throws exception?
                $null = $Proxy | Invoke-1ASOAPOperation -Operation Security_SignOut -Parameter $securitySignOut -WithSession -ErrorAction SilentlyContinue
            }
            else
            {
                Write-Warning "No session to stop"
            }
        }
        catch
        {
            $faultError = $_.Exception.InnerException
            # TODO Why Security_SignOut throws exception?
            if (($faultError.GetType().Fullname -eq "System.Web.Services.Protocols.SoapHeaderException") -and ($faultError.Message -eq " 95|Session|Inactive conversation"))
            {
                Write-Warning "Session ends from 1A with an error"
            }
            else
            {
                throw
            }
            
        }
        finally
        {
            $Proxy | 
                Clear-1ASOAPSession -PassThru |
                Clear-1ASOAPSessionAMAHeader
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