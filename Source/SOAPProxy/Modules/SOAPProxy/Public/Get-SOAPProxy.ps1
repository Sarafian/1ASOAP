function Get-SOAPProxy
{
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "Default")]
        [switch]$Default,
        [Parameter(Mandatory = $true, ParameterSetName = "Uri")]
        [string]$Uri,
        [Parameter(Mandatory = $true, ParameterSetName = "Proxy")]
        [System.Object]$Proxy,
        [Parameter(Mandatory=$true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy,
        [Parameter(Mandatory=$true, ParameterSetName = "Hash")]
        [hashtable]$Hashtable
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        switch ($PSCmdlet.ParameterSetName) {
            "Default" { 
                $variableDefaultName="SOAPProxy:Proxy:Default"
                Write-Debug "variableDefaultName=$variableDefaultName"
    
                Write-Debug "Looking for variable $variableDefaultName containing default proxy"
                $Proxy=Get-Variable -Name $variableDefaultName -ValueOnly -Scope Global -ErrorAction SilentlyContinue
                if($null -eq $Proxy)
                {
                    throw "Default proxy not set"
                }
                else {
                    Write-Debug "Found $($Proxy.GetType().AssemblyQualifiedName) as default proxy"
                }
                $Proxy
            }
            "Uri" { 
                $variableUriName="SOAPProxy:Proxy:Uri:$Uri"
                Write-Debug "variableUriName=$variableUriName"
                
                Write-Debug "Looking for variable $variableUriName containing proxy"
                $proxy=Get-Variable -Name $variableUriName -ValueOnly  -Scope Global -ErrorAction SilentlyContinue
    
                if($null -ne $proxy)
                {
                    Write-Verbose "Found $($proxy.GetType().AssemblyQualifiedName) for $Uri"
                }
            }
            "Proxy" { 
                $Proxy
            }
            "Pipeline" { 
                $PipedProxy 
            }
            "Hash" { 
                if($Hashtable.ContainsKey("PipedProxy"))
                {
                    $Hashtable.PipedProxy
                }
                elseif ($Hashtable.ContainsKey("Proxy")) {
                    $Hashtable.Proxy
                }
                elseif ($Hashtable.ContainsKey("Uri")) {
                    $Hashtable.Uri
                }
                else {
                    Get-SOAPProxy -Default
                }
            }
        }
    }

    end
    {
    }
}