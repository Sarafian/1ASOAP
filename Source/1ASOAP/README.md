## Goal

This module tries to provide a simple abstraction over common aspects of consuming the [Amadeus][1] SOAP API. The API is always customized to each consumer and for this reason there isn't a standard set of operations available on each endpoint. For this reason this module doesn't offer cmdlets per 1A operation.

The abstraction of `1ASOAP` depends on the functionalities of [SOAPProxy][3] and [JSONPath][2] and allows the following concepts

- Initialize a proxy for an Amadeus endpoint within the PowerShell session.
- Initialize SessionAMAHeader values for a proxy's url within the PowerShell session.
- Invoke operations and let module take care of headers and errors.
- Finalize the session in the proxy.

## Cmdlets

- `Get-1ASOAPSession`
- `Invoke-1ASOAPOperation`
- `Set-1ASOAPSessionAMAHeader`
- `Start-1ASOAPSession`
- `Stop-1ASOAPSession`
- `Test-1ASOAPSession`

## Things to consider

### Invoke-1ASOAPOperation 

`Invoke-1ASOAPOperation` will look into the proxy's session state and depending on the value, it will make sure that the proxy will be properly adjusted

- When the session is not set then 
  - Starts the session
  - Set the SessionAMAHeader values. 
- When the session's `TransactionStatusCode` is `Start`
  - Set the SessionAMAHeader values. 
- When the session's `TransactionStatusCode` is `InSerries`
  - Clear the SessionAMAHeader. 
- When the session's `TransactionStatusCode` is `End`
  - Starts the session
  - Set the SessionAMAHeader values. 
  
The `Invoke-1ASOAPOperation` will internally manipulate the SessionAMAHeader of the proxy by invoking the `Set-1ASOAPSessionAMAHeader` on it. The SessionAMAHeader contains specific information provided by Amadeus related to the target endpoint. The values cannot be coded by they still need to be accessible for access. For this reason the `Set-1ASOAPSessionAMAHeader` provides a variation where the values are stored in the powershell's environmental variable and when normally invoked the cmdlet will try to acquire these values.

For example

```powershell
$amaHeaderSplat=@{
    POSType=""
    RequestorType=""
    PseudoCityCode=""
    AgentDutyCode=""
    CompanyName=""
    Uri="" #This is the target uri for which the header values are applicable.
}
Set-1ASOAPSessionAMAHeader @amaHeaderSplat
```

Once the session is initialized then any invocation `Set-1ASOAPSessionAMAHeader` against a proxy initialized the above `Uri` will access the right information.

### Stop-1ASOAPSession

`Stop-1ASOAPSession` will try and invoke the `Security_Signout` operation on Amadeus endpoint using the `Invoke-1ASOAPOperation`.


## Examples

### A simple PNR_Retrieve

This is an example that executes a `PNR_Retrieve` on an endpoint `$Uri` and for a PNR `$pnr`

```powershell
$uri="" # This is your Amadeus 1A endpoint
$pnr="" # This is the target PNR

#region Initialize the session
Import-Module .\Source\JSONPath\Modules\JSONPath\JSONPath.psm1
Import-Module .\Source\SOAPProxy\Modules\SOAPProxy\SOAPProxy.psm1
Import-Module .\Source\1ASOAP\Modules\1ASOAP\1ASOAP.psm1

# Enter your custom header SessionAMAHeader values
# This needs to be done only once in the current session
$amaHeaderSplat=@{
    POSType=""
    RequestorType=""
    PseudoCityCode=""
    AgentDutyCode=""
    CompanyName=""
}
Set-1ASOAPSessionAMAHeader @amaHeaderSplat

# Initialize default proxy
# No need to specify a proxy for the rest of the code
Initialize-SOAPProxy -Uri $Uri -AsDefault

#endregion

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
```

[1]: https://www.amadeus.com
[2]: /Sarafian/1ASOAP/Source/JSONPath/README.md
[3]: /Sarafian/1ASOAP/Source/SOAPProxy/README.md
