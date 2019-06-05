function Trace-SOAPProxy
{
    param(
        [Parameter(Mandatory = $false, ParameterSetName = "Trace Request")]
        [Parameter(Mandatory = $false, ParameterSetName = "Trace Response")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true, ParameterSetName = "Trace Request")]
        [Parameter(Mandatory = $true, ParameterSetName = "Trace Response")]
        [string]$Operation,
        [Parameter(Mandatory = $true, ParameterSetName = "Trace Request")]
        [switch]$Request,
        [Parameter(Mandatory = $true, ParameterSetName = "Trace Response")]
        [switch]$Response,
        [Parameter(Mandatory = $false, ParameterSetName = "Trace Request")]
        [switch]$RenderCode
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $info=Get-SOAPProxy -Hashtable $PSBoundParameters| Get-SOAPProxyInfo
        switch($PSCmdlet.ParameterSetName)
        {
            'Trace Request' {
                $requestType=$info|Where-Object -Property Operation -EQ $Operation|Select-Object -ExpandProperty RequestType
                Write-Debug "requestType=$requestType"
                if($RenderCode)
                {
                    $codeLines=(Trace-JSONPath -Type $requestType -RenderCode) -split [System.Environment]::NewLine
                    $codeLines[0]="`$request$Operation=New-SOAPProxyRequest -Operation `"$Operation`""
                    ($codeLines -join [System.Environment]::NewLine).Replace("`$obj","`$request$Operation")

                }
                else {
                    Trace-JSONPath -Type $requestType
                }
            }
            'Trace Response' {
                $responseType=$info|Where-Object -Property Operation -EQ $Operation|Select-Object -ExpandProperty ResponseType
                Write-Debug "requestType=$responseType"
                Trace-JSONPath -Type $responseType
            }
        }

    }

    end
    {

    }
}