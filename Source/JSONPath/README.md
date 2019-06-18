JSONPath provides basic functionality similar to Stefan's Goessner [JSONPath][1] concept.
Please **note** that this is not a full implementation of the concept, and it can be further extended. Also, the module extends the query functionality with setting and testing as well while always safe guarding against $null instances. Especially the set function will create all intermediate instances required to traverse a path.

Please **note** the original inception of this module was when building an automation over [Amadeus][2]'s SOAP API and for this reason class instance examples are related to this API's datacontracts. XML fragments are used to present a complex instance but the module is not related to XML.

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

The module's purpose is best suited when the above structure is defined with typed objects instead of dynamic ones, in a similar way that you would find with WSDL generated classes for a SOAP endpoint. This module is not related to XML but its inception originates from working with [Amadeus's][2] SOAP API, which is powered by very complex data contracts. With an XML example in mind, which is available on their API, one can visualize the JSONPath and hence the birth of this functionality.

For example if we would like to refer to value of `controlNumber` then we could use an expression like `retrievalFacts.reservationOrProfileIdentifier.reservation.controlNumber`.
Often, the composite nested structure has arrays and this module will try to abstract this detail when possible.
For example let's assume that `reservationOrProfileIdentifier` could refer to multiple instances of `reservation`. 
In this case the above expression would behave like this depending on the action:
- When the verb is `Find`, then all instances of `reservation` would be included in the query. If the first one was intended then the path should be `retrievalFacts.reservationOrProfileIdentifier.reservation[0].controlNumber`
- When the verb is `Set`, then the first instance of `reservation` will be processed effectively matching this path `retrievalFacts.reservationOrProfileIdentifier.reservation[0].controlNumber`.

When working with PowerShell and especially when working with dynamically generated types from a SOAP endpoint, then doing the above can be very tedious and results in very verbose and error prone code.
This module will make sure that 
- during `Find` operation, all intermediate steps will be guarded against null values and when an arrays is found all instances will be processes.
- during `Set` operation, all missing instances will be created based on the matching type. If the target property is an array, then a new array will be created.

The `Trace` functionality was added to help visualize the structure of a given type, which sometimes can become very complicated due to multiple levels of composition. The functionality offers two modes:

- A trace as an array of valid JSONPath expressions where when a array property is encountered, the expression uses a zero index array. This is also an indication that the specific segment in the JSONPath represents an array.
- A code rendering using `Set-JSONPath`

## Cmdlets

- `Find-JSONPath`
- `Set-JSONPath`
- `Trace-JSONPath`

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

# The second instance of retrievalFacts is returns
$retrieve.retrievalFacts| Find-JSONPath -Path "retrieve.type" -EQ -Value 3
```

# Trace Examples

For this section, the [Root][3] from Pester tests will be used

## Example 1 - Type tracing

The following command  `Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type])` returns the following permutations

```text
IntArray[0]=0
IntSingle=0
StringArray[0]="String"
StringSingle="String"
Type1Array[0].IntArray[0]=0
Type1Array[0].IntSingle=0
Type1Array[0].StringArray[0]="String"
Type1Array[0].StringSingle="String"
Type1Array[0].Type2Array[0].IntArray[0]=0
Type1Array[0].Type2Array[0].IntSingle=0
Type1Array[0].Type2Array[0].StringArray[0]="String"
Type1Array[0].Type2Array[0].StringSingle="String"
Type1Array[0].Type2Single.IntArray[0]=0
Type1Array[0].Type2Single.IntSingle=0
Type1Array[0].Type2Single.StringArray[0]="String"
Type1Array[0].Type2Single.StringSingle="String"
Type1Single.IntArray[0]=0
Type1Single.IntSingle=0
Type1Single.StringArray[0]="String"
Type1Single.StringSingle="String"
Type1Single.Type2Array[0].IntArray[0]=0
Type1Single.Type2Array[0].IntSingle=0
Type1Single.Type2Array[0].StringArray[0]="String"
Type1Single.Type2Array[0].StringSingle="String"
Type1Single.Type2Single.IntArray[0]=0
Type1Single.Type2Single.IntSingle=0
Type1Single.Type2Single.StringArray[0]="String"
Type1Single.Type2Single.StringSingle="String"
```

## Example 2 - Object trace

Let's assume that we want to see all JSONPaths with a value in a given object. To help visualize, we use this code to initialize the object

```powershell
$obj=$obj |	Set-JSONPath -Path "Type1Array[1].Type2Single.StringSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Single.IntSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Single.StringArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Single.IntArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Array[1].StringSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Array[1].IntSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Array[1].StringArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Array[1].Type2Array[1].IntArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.StringSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.IntSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.StringArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.IntArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[1].StringSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[1].IntSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[1].StringArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[1].IntArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "StringSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "IntSingle" -Value 1 -PassThru |
	Set-JSONPath -Path "StringArray[1]" -Value 2 -PassThru |
	Set-JSONPath -Path "IntArray[1]" -Value 2 -PassThru
```

**Notice that all arrays are missing on purpose the zero index to showcase how they are visualized:
- When not a primitive, then it won't show
- When a primitive string then it will render like `=""(null)` because for PowerShell strings that are `$null` or empty are considered the same. All values will be wrapped in double quotes to quickly reveal that the primitive is a string.
- When a primitive int then it will render like `=0`

```text
IntArray[0]=0
IntArray[1]=2
IntSingle=1
StringArray[0]=""(null)
StringArray[1]="2"
StringSingle="1"
Type1Array[1].Type2Array[1].IntArray[0]=0
Type1Array[1].Type2Array[1].IntArray[1]=2
Type1Array[1].Type2Array[1].IntSingle=1
Type1Array[1].Type2Array[1].StringArray[0]=""(null)
Type1Array[1].Type2Array[1].StringArray[1]="2"
Type1Array[1].Type2Array[1].StringSingle="1"
Type1Array[1].Type2Single.IntArray[0]=0
Type1Array[1].Type2Single.IntArray[1]=2
Type1Array[1].Type2Single.IntSingle=1
Type1Array[1].Type2Single.StringArray[0]=""(null)
Type1Array[1].Type2Single.StringArray[1]="2"
Type1Array[1].Type2Single.StringSingle="1"
Type1Single.Type2Array[1].IntArray[0]=0
Type1Single.Type2Array[1].IntArray[1]=2
Type1Single.Type2Array[1].IntSingle=1
Type1Single.Type2Array[1].StringArray[0]=""(null)
Type1Single.Type2Array[1].StringArray[1]="2"
Type1Single.Type2Array[1].StringSingle="1"
Type1Single.Type2Single.IntArray[0]=0
Type1Single.Type2Single.IntArray[1]=2
Type1Single.Type2Single.IntSingle=1
Type1Single.Type2Single.StringArray[0]=""(null)
Type1Single.Type2Single.StringArray[1]="2"
Type1Single.Type2Single.StringSingle="1"
```


## Example 3 - Render tracing

The render functionality of `Trace-JSONPath` uses the above trace set, to generate a code fragment that is ready to use in PowerShell. 
`Trace-JSONPath -Type ("JSONPath.Pester.Type2" -as [type]) -RenderCode` renders the following code fragment.

```powershell
$obj=New-Object -TypeName "JSONPath.Pester.Root"
$obj=obj|Set-JSONPath -Path "Type1Single.Type2Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.Type2Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Single.IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].Type2Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "Type1Array[0].IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "Type1Array[0].IntArray[0]" -Value 0 -PassThru |
	Set-JSONPath -Path "StringSingle" -Value "String" -PassThru |
	Set-JSONPath -Path "StringArray[0]" -Value "String" -PassThru |
	Set-JSONPath -Path "IntSingle" -Value 0 -PassThru |
	Set-JSONPath -Path "IntArray[0]" -Value 0
```
  
[1]: https://goessner.net/articles/JsonPath/
[2]: https://www.amadeus.com
[3]: JSONPath/Pester/CS/JSONPath.Pester.cs