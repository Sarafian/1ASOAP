function Get-SOAPProxyInternal
{
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $false,ParameterSetName = "Parameter")]
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
            "Hash" { 
                if($Hashtable.ContainsKey("PipedProxy"))
                {
                    $Hashtable.PipedProxy
                }
                elseif ($Hashtable.ContainsKey("Proxy")) {
                    $Hashtable.Proxy
                }
                else {
                    Get-SOAPProxyInternal
                }
            }
            "Pipeline" { 
                $PipedProxy 
            }
            "Parameter" { 
                if($null -eq $Proxy)
                {
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
                $Proxy
            }
        }
    }

    end
    {

    }
}