function Get-SOAPProxyInfo
{
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $false,ParameterSetName = "Parameter")]
        [System.Object]$Proxy,
        [Parameter(Mandatory = $true,ValueFromPipeline = $true, ParameterSetName = "Pipeline")]
        [System.Object]$PipedProxy
    )

    begin
    {
        Write-Debug "PSCmdlet.ParameterSetName=$($PSCmdlet.ParameterSetName)"
        foreach ($psbp in $PSBoundParameters.GetEnumerator()) {Write-Debug "$($psbp.Key)=$($psbp.Value)"}
    }

    process
    {
        $Proxy=Get-SOAPProxy @PSBoundParameters

        if($null -ne $Proxy)
        {
            $Proxy|Get-Member -MemberType Method -Name "*Async" |Where-Object -Property Name -NE "CancelAsync" | ForEach-Object {
                $name=$_.Name.Replace("Async","")
                $member=$Proxy|Get-Member -Name $name -MemberType Method
                # TODO: What if the method has multiple parameters
                $definitionRegEx = "(?<responseType>.+) $($member.Name)\((?<requestType>.+)\)"
                Write-Debug "definitionRegEx=$definitionRegEx"
                if (Get-Variable -Name Matches -ErrorAction SilentlyContinue) {
                    $Matches.Clear()
                }
                $requestType=$null
                $responseType=$null
                if($member.Definition -match $definitionRegEx)
                {
                    $requestType = $Matches.requestType
                    $responseType = $Matches.responseType
                }
                else
                {
                    Write-Warning "Could not parse the definition for method $($member.Name)"
                }
                [pscustomobject]@{
                    Operation=$member.Name
                    RequestType=[Type]$requestType 
                    ResponseType=[Type]$responseType
                }
            }          
        }
    }

    end
    {

    }
}