$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\..\JSONPath\Modules\JSONPath\JSONPath.psm1 -Force
Import-Module $here\..\..\SOAPProxy\Modules\SOAPProxy\SOAPProxy.psm1 -Force

Import-Module $here\..\Modules\1ASOAP\1ASOAP.psm1 -Force

$prefix=($sut -replace '\.ps1','')+" Tests:"

. $here\Cmdlets-Helpers\Get-RandomValue.ps1
. $here\Cmdlets-Helpers\Set-1ASOAPProxyMock.ps1


$testCases=@()

foreach($state in @($null,"Start","InSeries","End"))
{
    $testCases+=@{
        Operation=Get-RandomValue -String
        Parameter=Get-RandomValue -String
        TransactionStatusCode=$state
    }
}

Describe "$prefix Invoke-1ASOAPOperation"{
    $mockProxy=Set-1ASOAPProxyMock -PassThru
    Mock Get-SOAPProxy {
        $mockProxy
    }
<#
    Mock Set-JSONPath {
        switch($Path) {
            'SessionValue.TransactionStatusCode' {
                $InputObject.SessionValue=[PSCustomObject]@{
                    TransactionStatusCode=$Value
                }
            }
            {$_ -like 'AMA_SecurityHostedUserValue.UserID.*'} {
                $InputObject.AMA_SecurityHostedUserValue=[PSCustomObject]@{
                    UserID=[PSCustomObject]@{
                        POS_Type=[string]$null
                        RequestorType=[string]$null
                        PseudoCityCode=[string]$null
                        AgentDutyCode=[string]$null
                        RequestorID=[PSCustomObject]@{
                            CompanyName=[PSCustomObject]@{
                                Value=[string]$null
                            }                    
                        }
                    }
                }
#                $InputObject.AMA_SecurityHostedUserValue.UserID.POS_Type=$Value
            }
            default {
                throw "Not a mock JSONPath $Path"
            }
        }
    }
#>    
    BeforeEach {
        Set-1ASOAPProxyMock -Proxy $mockProxy
        Set-1ASOAPSessionAMAHeader -Uri $mockProxy.Url -POSType (Get-RandomValue -String)
    }
    It "No Test: Add Operation <Operation> with Parameter <Parameter> to proxy" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
        $S = {"Response: $Parameter"}
        $mockProxy | Add-Member -MemberType ScriptMethod -Name $Operation -Value $S
    }
    It "Invoke-1ASOAPOperation -Operation <Operation> -Parameter <Parameter> while with session TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
            
        if($null -ne $TransactionStatusCode)
        {
            $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        }
        else {
            $mockProxy.SessionValue=$null
            $mockProxy.AMA_SecurityHostedUserValue=$null
        }
        $actual=Invoke-1ASOAPOperation -Operation $Operation -Parameter $Parameter
        $actual|Should -Not -BeExactly $null
        $actual|Should -BeExactly "Response: $Parameter"
        switch($TransactionStatusCode)
        {
            $null {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
            }
            "Start" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
                
            }
            "InSeries" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "InSeries"
                $mockProxy.AMA_SecurityHostedUserValue | Should -BeExactly $null
            }
            "End" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
            }
        }
        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Invoke-1ASOAPOperation -Proxy -Operation <Operation> -Parameter <Parameter> while with session TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
            
        if($null -ne $TransactionStatusCode)
        {
            $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        }
        else {
            $mockProxy.SessionValue=$null
            $mockProxy.AMA_SecurityHostedUserValue=$null
        }
        $actual=Invoke-1ASOAPOperation -Proxy $mockProxy -Operation $Operation -Parameter $Parameter
        $actual|Should -Not -BeExactly $null
        $actual|Should -BeExactly "Response: $Parameter"
        switch($TransactionStatusCode)
        {
            $null {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
            }
            "Start" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
                
            }
            "InSeries" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "InSeries"
                $mockProxy.AMA_SecurityHostedUserValue | Should -BeExactly $null
            }
            "End" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
            }
        }
        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Proxy|Invoke-1ASOAPOperation -Operation <Operation> -Parameter <Parameter> while with session TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
            
        if($null -ne $TransactionStatusCode)
        {
            $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        }
        else {
            $mockProxy.SessionValue=$null
            $mockProxy.AMA_SecurityHostedUserValue=$null
        }
        $actual=$mockProxy|Invoke-1ASOAPOperation -Operation $Operation -Parameter $Parameter
        $actual|Should -Not -BeExactly $null
        $actual|Should -BeExactly "Response: $Parameter"
        switch($TransactionStatusCode)
        {
            $null {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
            }
            "Start" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
                
            }
            "InSeries" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "InSeries"
                $mockProxy.AMA_SecurityHostedUserValue | Should -BeExactly $null
            }
            "End" {
                $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"
                $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null
            }
        }
        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }
<#
    It "Invoke-1ASOAPOperation -Operation <Operation> -Parameter <Parameter> while with session TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
            
        if($null -ne $TransactionStatusCode)
        {
            $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        }
        else {
            $mockProxy.SessionValue=$null
        }
        $actual=Invoke-1ASOAPOperation -Operation $Operation -Parameter $Parameter
        $actual|Should -Not -BeExactly $null
        $actual|Should -BeExactly "Response: $Parameter"

        $mockProxy.SessionValue | Should -BeExactly $null
        $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Invoke-1ASOAPOperation -Proxy -Operation <Operation> -Parameter <Parameter> while with session TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
            
        if($null -ne $TransactionStatusCode)
        {
            $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        }
        else {
            $mockProxy.SessionValue=$null
        }
        $actual=Invoke-1ASOAPOperation -Proxy $mockProxy -Operation $Operation -Parameter $Parameter
        $actual|Should -Not -BeExactly $null
        $actual|Should -BeExactly "Response: $Parameter"

        $mockProxy.SessionValue | Should -BeExactly $null
        $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Proxy| Invoke-1ASOAPOperation -Operation <Operation> -Parameter <Parameter> while with session TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($Operation,$Parameter,$TransactionStatusCode)
            
        if($null -ne $TransactionStatusCode)
        {
            $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        }
        else {
            $mockProxy.SessionValue=$null
        }
        $actual=$mockProxy | Invoke-1ASOAPOperation -Operation $Operation -Parameter $Parameter
        $actual|Should -Not -BeExactly $null
        $actual|Should -BeExactly "Response: $Parameter"

        $mockProxy.SessionValue | Should -BeExactly $null
        $mockProxy.AMA_SecurityHostedUserValue | Should -Not -BeExactly $null

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }
#>    
}