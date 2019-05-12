This repository is meant to help simplify PowerShell scripting against [Amadeus's][1] [SOAP API][2] in a relatively simple way with clean code.
**Note** that the [author](@Sarafian) is not an expert in [Amadeus][1] or its API[2] and this repository is only meant to provide a simpler experience with the API based on the following considerations.

## Considerations

[Amadeus's][1] GDS also known as **1A** has the following attributes that are considered as part of this solution:
- 1A creates offers 1 endpoint that is composition of operations from different functional areas
  - PNR_Retrieve
  - PNR_Cancel
  - Security_SignOut
- With the endpoint being a dynamically different for each "customer", the module will not offer wrapper cmdlets but focuses on a simple and clean interaction with 1A's SOAP API.
- Each operation has a very composite request structure and an even more complicated one for response
- 1A SOAP API is stateful similar to the console. There are two options:
  - A request contains all the necessary information for a specific intention.
  - Use a session header to control start, continue or end the session with each API invocation.
- When importing a SOAP proxy in PowerShell, then behind the scenes, the .NET's Windows Communication Foundation generates in memory assemblies and types based on the imported WSDL.
- When working with SOAP proxies, dynamic objects cannot be used, because everything needs to be using the types generated from the WSDL, to allow generation of the SOAP envelope through the **DataContract** annotations

## Implementation details

- Instead of generating SOAP envelops and **POST**ing them to the 1A endpoint, use the [New-WebServiceProxy][7] cmdlet to generate a typed proxy and worked with typed memory objects.
- **Note* that [New-WebServiceProxy][7] is not implemented in PowerShell Core, since the underlying .NET Core doesn't support the `System.ServiceModel` assembly. For this reason, this module [SOAPProxy][4] requires **PowerShell 5.1**.
- With composite and nested type objects, the code becomes very verbose in order to set a property or find objects based on a condition.

For example for the `PNR_Retrieve` request we want to use expressions like `retrievalFacts.retrieve.type` to set or refer to the matching object in the respected XML:

```xml
<retrievalFacts>
  <retrieve>
    <type>2</type>
  </retrieve>
  <reservationOrProfileIdentifier>
    <reservation>
      <companyId>SN</companyId>
      <controlNumber>MTHOH2</controlNumber>
    </reservation>
  </reservationOrProfileIdentifier>
</retrievalFacts>
```

## Repository breakdown

The repository is composed by 3 modules. Each can be isolated and has the potential to become an independent repository. For the beginning, all will be places withing this repository with isolation in mind.

- [JSONPath][3] that provides basic functionality similar to Stefan's Goessner [JSONPath][6] concept. **Note** that 
  - this is not a full implementation of the idea, but it can be further extender.
  - it uses the same concepts both to drive `Set`, `Get`, `Test` and `Find`
- [SOAPProxy][4] that provides some basic functionality around [New-WebServiceProxy][7] to address the dynamic injection of .NET assemblies into the session. 
- [1ASOAP][5] that provides functionality around the 1A `Session` and `AMA_SecurityHostedUser` headers

## Samples

```powershell
# Initialize Proxy
$proxy=Initialize-1ASOAPProxy -Uri $URI -Namespace "amadeus.soap.example" -AsDefault -PassThru
try
{
  # Create the PNR_Retrieve request object	
  $pnrRetrieve = $proxy |New-1ASOAPRequest -Operation PNR_Retrieve

  # Fill in the structure of the PNR_Retrieve request
  $pnrRetrieve |
    Set-JSONPath -Path "retrievalFacts.retrieve.type" -Value 2 -PassThru |
    Set-JSONPath -Path "retrievalFacts.reservationOrProfileIdentifier.companyId" -Value "SN" -PassThru |
    Set-JSONPath -Path "retrievalFacts.reservationOrProfileIdentifier.controlNumber" -Value $pnr

  # Invoke PNR_Retrieve operation over 1A  
  $pnrRetrieveResponse = $proxy|Invoke-SN1AOperation -Operation PNR_Retrieve -Parameter $pnrRetrieve -WithSession

  # Capture all dataelements having ssr type CTCE
  $dataElementsIndivWithCTCE=$pnrRetrieveResponse.dataElementsMaster.dataElementsIndiv | 
    Find-JSONPath -Path"serviceRequest.ssr.type" -EQ -Value "CTCE"
}
finally
{
  # Stop the 1A session present in the proxy
  Stop-1ASOAPSession
}
```

[1]: https://www.amadeus.com
[2]: https://developers.amadeus.com/enterprise
[3]: Source/JSONPath/README.md
[4]: Source/SOAPProxy/README.md
[5]: Source/1ASOAP/README.md
[6]: https://goessner.net/articles/JsonPath/
[7]: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-webserviceproxy?view=powershell-5.1
