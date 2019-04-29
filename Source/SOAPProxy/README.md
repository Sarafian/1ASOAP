The main function of this module is work around some of the technical issues created by the [New-WebServiceProxy][1] cmdlet.

## The issue with New-WebServiceProxy

When the [New-WebServiceProxy][1] then the underlying pipeline of WCF will generate .NET types matching the description of the WSDL file. The types will not be created in e.g. C# files, but instead they will be contained within a dynamically generated assembly which is also loaded into the current `AppDomain`.

When executing the `New-WebServiceProxy` multiple times, then the result is that there are more than one assembly loaded in memory for the exact same types. Let's assume that upon invocation of `New-WebServiceProxy` we specified the `-Namespace` and `-Class` parameters like this

```powershell
$proxy1=New-WebServiceProxy -URI $uri -Namespace "SOAP" -Class "Proxy"
$proxy2=New-WebServiceProxy -URI $uri -Namespace "SOAP" -Class "Proxy"
```

At this momement, there are two assemblies containing the type `SOAP.Proxy` and all the relevant types. If you would attempt to create an instance of one of this types e.g. `OperationRequest` then you would create a new instance based on the type name `SOAP.OperationRequest` like this

```powershell
$request=[SOAP.OperationRequest]::new()
```

The issue is that it is not clear which assembly was used and for this reason one of the following two commands would throw an error, because each of the `$proxy1` and `$proxy2` would expect a `SOAP.OperationRequest` instance matching its own assembly.

```powershell
$proxy1.Operation($request)
$proxy2.Operation($request)
```

To avoid this situation, a semaphore like concept needs to be leveraged. Among many tricks is to check if the expected type `SOAP.Proxy` is already available and skip the proxy creation. Another trick would be to use variables.

**SOAPProxy** modules offers a cmdlet `Initialize-SOAPProxy` that abstracts this concept into one simple command. 

**Cmdlets**

- `Initialize-SOAPProxy` initializes a proxy from a URI. if specified, the proxy is marked as default and all other cmdlets will retrieve it when the URI is not specified
- `Get-SOAPProxy` returns a proxy. If the URI is not specified, then a default one is attempted to be retrieved.
- `Get-SOAPProxyInfo` returns a recordset, where each record contains the name of an Operation and the full type names for its request and response types.
- `New-SOAPProxyRequest` returns an instance intended to be used by the specified operation of a proxy.

The module can handle multiple proxies and since this ability is incorporated within it, all cmdlets and especially `New-SOAPProxyRequest` are in harmony with regards to the assembly of each type. Even if two URIs would generate the same type name, working with the module's cmdlets and the [JSONPath]2] module.

Effectively, the proxy instance is used as the driver for everything. As an instance, it has a type in .NET and all types are part of an assembly.

## PowerShell Core not supported

Unfortunately, [New-WebServiceProxy][1] is not implemented in PowerShell Core, since the underlying .NET Core doesn't support the `System.ServiceModel` assembly. For this reason, this module requires **PowerShell 5.1** or lower.

## Samples


```powershell
Initialize-Proxy -URI $uri1 -AsDefault

Initialize-Proxy -URI $uri2

# Get default proxy for uri1
$proxy1=Get-Proxy
# Get proxy for uri1
$proxy1=Get-Proxy -Uri $uri1

# Get proxy for uri2
$proxy2=Get-Proxy -URI uri2

# Get default proxy information for uri1
$proxyInfo1=Get-ProxyInfo
# Get proxy information for uri1
$proxyInfo1=Get-ProxyInfo -Uri $uri1

# Get proxy information for uri2
$proxyInfo2=Get-ProxyInfo -URI uri2


```
