param(
    [Parameter(Mandatory=$true)]
    [string]$Uri,
    [Parameter(Mandatory=$true)]
    [string]$PNR
)

# Import the modules
& $PSScriptRoot\..\..\Import-Modules.ps1

try
{
    # Initialize default proxy
    # No need to specify a proxy for the rest of the code
    Initialize-SOAPProxy -Uri $Uri -AsDefault

    # Start the session with 1A
    Start-1ASOAPSession

    # Create an empty pnr retrieve request object
    $pnrRetrieve = New-SOAPProxyRequest -Operation PNR_Retrieve

    # Fill in the request 
    $pnrRetrieve |
        Set-JSONPath -Path "retrievalFacts.retrieve.type" -Value 2 -PassThru |
        Set-JSONPath -Path "retrievalFacts.reservationOrProfileIdentifier.companyId" -Value "SN" -PassThru |
        Set-JSONPath -Path "retrievalFacts.reservationOrProfileIdentifier.controlNumber" -Value $PNR

    # Invoke the PNR_Retrieve
    $pnrRetrieveResponse = Invoke-1ASOAPOperation -Operation PNR_Retrieve -Parameter $pnrRetrieve

<#
    $dataElementsIndivWithCTCE=$pnrRetrieveResponse.dataElementsMaster.dataElementsIndiv | 
        Where-ObjectWithPath -Expression "serviceRequest.ssr.type" -EQ -Value "CTCE"
        
    $dataElementsIndivWithCTCE=@($dataElementsIndivWithCTCE)
    if($dataElementsIndivWithCTCE.Count -gt 0)
    {
        Write-Host "Found $($dataElementsIndivWithCTCE.Count) SSR elements with type CTCE for PNR $pnr" -ForegroundColor Green
        $otElementsToCancel=@($dataElementsIndivWithCTCE.elementManagementData.reference|Where-Object -Property qualifier -eq -Value "OT")
        Write-Host "Found $($otElementsToCancel.Count) OT references with  PNR $pnr" -ForegroundColor Green
        $otElementsToCancel | ForEach-Object {
            $number=$_.number
            Write-Progress -Status "Removing OT reference with number $number from PNR $pnr" @splatWriteProgress -CurrentOperation "Preparing data"
    
            $pnrCancel=$proxy |New-SN1ARequest -Operation PNR_Cancel
            $pnrCancel |
                Set-segmentDeep -Expression "pnrActions[0]" -Value 10 -PassThru |
                Set-segmentDeep -Expression "cancelElements.entryType" -Value E -PassThru |
                Set-segmentDeep -Expression "cancelElements.element.identifier" -Value "OT" -PassThru |
                Set-segmentDeep -Expression "cancelElements.element.number" -Value "$number"

            Write-Progress -Status "Deleting OT with number $number from PNR $pnr" @splatWriteProgress -CurrentOperation "Executing"
            #$pnrCancelResponse = $proxy|Invoke-SN1AOperation -Operation PNR_Cancel -Parameter $pnrCancel -WithSession
        }
    }
    else {
        Write-Host "No SSR elements with type CTCE for PNR $pnr" -ForegroundColor Green
    }
#>    
}
finally
{
    Stop-1ASOAPSession
}