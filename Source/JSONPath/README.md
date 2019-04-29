JSONPath provides basic functionality similar to Stefan's Goessner [JSONPath][1] concept.
Please **note** that this is not a full implementation of the concept[1], but it can be further extended.

## Goal

The overall goal of this module is to allow a simple processing of objects that would in memory represented by an XML structure like this:

```xml
<retrievalFacts>
  <retrieve>
    <type>2</type>
  </retrieve>
  <reservationOrProfileIdentifier>
    <reservation>
      <companyId></companyId>
      <controlNumber></controlNumber>
    </reservation>
  </reservationOrProfileIdentifier>
</retrievalFacts>
```

The module's purpose is best suited when the above structure is defined with typed objects instead of dynamic ones, in a similar way that you would find with WSDL generated classes for a SOAP endpoint.

For example if we would like to refer to value of `controlNumber` then we could use an expression like `retrievalFacts.reservationOrProfileIdentifier.reservation.controlNumber`.
Often, the composite nested structure has arrays and this module will try to abstract this when possible.
For example let's assume that `reservationOrProfileIdentifier` could refer to multiple instances of `reservation`. 
In this case the above expression would behave like this depending on the action:
- When the verb is `Find`, then all instances of `reservation` would be included in the query. If the first one was intended then the path should be `retrievalFacts.reservationOrProfileIdentifier.reservation[0].controlNumber`
- When the verb is `Set`, then the first instance of `reservation` will be processed effectively matching this path `retrievalFacts.reservationOrProfileIdentifier.reservation[0].controlNumber`.

When working with PowerShell and especially when working with dynamically generated types from a SOAP endpoint, then doing the above can be very tedious and results in very verbose and error prone code.
This module will make sure that 
- during `Find` operation, all intermediate steps will be guarded against null values and when an arrays is found all instances will be processes.
- during `Set` operation, all missing instances will be created based on the matching type. If the target property is an array, then a new array will be created.

## Cmdlets

- `Find-JSONPath`
- `Set-JSONPath`

## Examples

The functionality of the module is tested with Pester modules and multiple examples can be found.
Using conceptually the above xml structure as part of an variable `$retrieve`, the following would be some examples of usage

```powershell
<# Creates this sub-structure
<retrievalFacts>
  <retrieve>
    <type>2</type>
  </retrieve>
</retrievalFacts>
#>
$retrieve| Set-JSONPath -Path "retrievalFacts.retrieve.type" -Value 2

<# Some examples of expectations of non listed querying
<retrievalFacts>
  <retrieve>
    <type>2</type>
  </retrieve>
</retrievalFacts>
#>

# The $retrieve instance is returned
$retrieve| Find-JSONPath -Path "retrievalFacts.retrieve.type" -EQ -Value 2

# Null is returned
$retrieve| Find-JSONPath -Path "retrievalFacts.retrieve.type" -EQ -Value 3
$retrieve| Find-JSONPath -Path "retrievalFacts.invalid.type" -EQ -Value 3

<# Some examples of expectations of non listed querying
<retrievalFacts>
  <retrieve>
    <type>2</type>
  </retrieve>
</retrievalFacts>
<retrievalFacts>
  <retrieve>
    <type>3</type>
  </retrieve>
</retrievalFacts>
#>

# The $retrieve instance is returned
$retrieve| Find-JSONPath -Path "retrievalFacts.retrieve.type" -EQ -Value 3

# The second instance of retrievalFacts is returnes
$retrieve.retrievalFacts| Find-JSONPath -Path "retrieve.type" -EQ -Value 3
```

  
[1]: https://goessner.net/articles/JsonPath/  
