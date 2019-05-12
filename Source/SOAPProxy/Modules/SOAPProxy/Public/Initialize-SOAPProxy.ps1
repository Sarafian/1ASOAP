function Initialize-SOAPProxy
{
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Parameter")]
        [ValidateScript({
            $temp=$null
            [System.Uri]::TryCreate($_,"Absolute",[ref]$temp)
        })]
        [string]$Uri,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [String]$NameSpace,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [String]$Class,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [switch]$AsDefault,
        [Parameter(Mandatory = $false, ParameterSetName = "Parameter")]
        [switch]$PassThru
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $variableUriName="SOAPProxy:Proxy:Uri:$Uri"
        $variableDefaultName="SOAPProxy:Proxy:Default"
        Write-Debug "variableUriName=$variableUriName"
        Write-Debug "variableDefaultName=$variableDefaultName"
        
        Write-Debug "Looking for variable $variableUriName containing already created proxy"
        $proxy=Get-Variable -Name $variableUriName -ValueOnly  -Scope Global -ErrorAction SilentlyContinue
        if($proxy)
        {
            Write-Debug "Found Proxy in variable $variableUriName"
            Write-Warning "Proxy for $Uri already initialized"
        }
        else 
        {
            Write-Debug "Creating new proxy"
            $splatNewWebServiceProxy=@{}+$PSBoundParameters
            $splatNewWebServiceProxy.Remove("PassThru")
            $splatNewWebServiceProxy.Remove("AsDefault")
            $proxy = New-WebServiceProxy @splatNewWebServiceProxy
            Write-Verbose "$($proxy.GetType().Fullname) for $Uri created"
            Write-Debug "Storing proxy in variable $variableUriName"
            Set-Variable -Name $variableUriName -Value $proxy -Scope Global
        }
        if($AsDefault)
        {
            Write-Debug "Removing existing variable $variableDefaultName containing already assigned proxy"
            Remove-Variable -Name $variableDefaultName -Force -ErrorAction SilentlyContinue
            Write-Debug "Storing default proxy in variable $variableDefaultName"
            Set-Variable -Name $variableDefaultName -Value $proxy -Scope Global
            Write-Verbose "$($proxy.GetType().AssemblyQualifiedName) for $Uri is now default"
        }
    }

    end
    {
        if($PassThru)
        {
            $proxy
        }
    }
}