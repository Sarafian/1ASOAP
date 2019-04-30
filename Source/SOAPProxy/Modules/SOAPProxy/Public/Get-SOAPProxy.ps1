function Get-SOAPProxy
{
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [switch]$Default,
        [Parameter(Mandatory = $true, ParameterSetName = "Uri")]
        [string]$Uri,
        [Parameter(Mandatory = $true, ParameterSetName = "Proxy")]
        [System.Object]$Proxy,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true, ParameterSetName = "Pipeline")]
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
            }
            "Uri" { 
                $variableUriName="SOAPProxy:Proxy:Uri:$Uri"
                Write-Debug "variableUriName=$variableUriName"
                
                Write-Debug "Looking for variable $variableUriName containing proxy"
                $Proxy=Get-Variable -Name $variableUriName -ValueOnly  -Scope Global -ErrorAction SilentlyContinue
    
                if($null -ne $Proxy)
                {
                    Write-Verbose "Found $($proxy.GetType().AssemblyQualifiedName) for $Uri"
                }
            }
            "Proxy" { 
            }
            "Pipeline" { 
                $Proxy=$PipedProxy 
            }
            "Hash" { 
                if($Hashtable.ContainsKey("PipedProxy"))
                {
                    $Proxy=$Hashtable.PipedProxy
                }
                elseif ($Hashtable.ContainsKey("Proxy")) {
                    $Proxy=$Hashtable.Proxy
                }
                elseif ($Hashtable.ContainsKey("Uri")) {
                    $Proxy=$Hashtable.Uri
                }
                else {
                    $Proxy=Get-SOAPProxy
                }
            }
        }
    }

    end
    {
        $Proxy
    }
}