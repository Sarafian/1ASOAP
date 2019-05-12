$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\..\JSONPath\Modules\JSONPath\JSONPath.psm1 -Force
Import-Module $here\..\..\SOAPProxy\Modules\SOAPProxy\SOAPProxy.psm1 -Force

Import-Module $here\..\Modules\1ASOAP\1ASOAP.psm1 -Force

$prefix=($sut -replace '\.ps1','')+" Tests:"

. $here\Cmdlets-Helpers\Get-RandomValue.ps1
. $here\Cmdlets-Helpers\Set-1ASOAPProxyMock.ps1

Describe "$prefix Get-1ASOAPSession"{
    $mockProxy=Set-1ASOAPProxyMock -PassThru
    Mock Get-SOAPProxy {
        $mockProxy
    }

    BeforeEach {
        Set-1ASOAPProxyMock -Proxy $mockProxy
        $mockProxy.SessionValue.TransactionStatusCode=Get-RandomValue -String
    }
    It "Get-1ASOAPSession" {
        $session=Get-1ASOAPSession
        $session | Should -Not -BeExactly $null
        $session.TransactionStatusCode | Should -BeExactly $mockProxy.SessionValue.TransactionStatusCode

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Get-1ASOAPSession -Proxy" {
        $session=Get-1ASOAPSession -Proxy $mockProxy
        $session | Should -Not -BeExactly $null
        $session.TransactionStatusCode | Should -BeExactly $mockProxy.SessionValue.TransactionStatusCode

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Proxy | Get-1ASOAPSession" {
        $session=$mockProxy|Get-1ASOAPSession
        $session | Should -Not -BeExactly $null
        $session.TransactionStatusCode | Should -BeExactly $mockProxy.SessionValue.TransactionStatusCode

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }

    It "Get-1ASOAPSession -TransactionStatusCode" {
        $code=Get-1ASOAPSession -TransactionStatusCode
        $code | Should -Not -BeExactly $null
        $code | Should -BeExactly $mockProxy.SessionValue.TransactionStatusCode

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Get-1ASOAPSession -Proxy -TransactionStatusCode" {
        $code=Get-1ASOAPSession -Proxy $mockProxy -TransactionStatusCode
        $code | Should -Not -BeExactly $null
        $code | Should -BeExactly $mockProxy.SessionValue.TransactionStatusCode

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Proxy | Get-1ASOAPSession -TransactionStatusCode" {
        $code=$mockProxy|Get-1ASOAPSession -TransactionStatusCode
        $code | Should -Not -BeExactly $null
        $code | Should -BeExactly $mockProxy.SessionValue.TransactionStatusCode

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }
}

Describe "$prefix Get-1ASOAPSession with null proxy"{
    Mock Get-SOAPProxy {
        $null
    }

    BeforeEach {
    }

    It "Get-1ASOAPSession" {
        $session=Get-1ASOAPSession
        $session | Should -BeExactly $null

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Get-1ASOAPSession -Proxy null" {
        $session=Get-1ASOAPSession -Proxy $null
        $session | Should -BeExactly $null

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Get-1ASOAPSession -TransactionStatusCode" {
        $code=Get-1ASOAPSession -TransactionStatusCode
        $code | Should -BeExactly "None"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Get-1ASOAPSession -Proxy null -TransactionStatusCode" {
        $code=Get-1ASOAPSession -Proxy $null -TransactionStatusCode
        $code | Should -BeExactly "None"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

}

Describe "$prefix Start-1ASOAPSession"{
    $mockProxy=Set-1ASOAPProxyMock -PassThru
    Mock Get-SOAPProxy {
        $mockProxy
    }
    Mock Set-JSONPath {
        switch($Path) {
            'SessionValue.TransactionStatusCode' {
                $InputObject.SessionValue=[PSCustomObject]@{
                    TransactionStatusCode=$Value
                }
            }
            'AMA_SecurityHostedUserValue.UserID.POS_Type' {
                $InputObject.AMA_SecurityHostedUserValue.UserID.POS_Type=$Value
            }
            default {
                throw "Not a mock JSONPath $Path"
            }
        }
    }

    BeforeEach {
        Set-1ASOAPProxyMock -Proxy $mockProxy
    }
    It "Start-1ASOAPSession" {
        $proxy=Start-1ASOAPSession
        $proxy | Should -BeExactly $null
        $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Start-1ASOAPSession -Proxy" {
        $proxy=Start-1ASOAPSession -Proxy $mockProxy
        $proxy | Should -BeExactly $null
        $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Proxy | Start-1ASOAPSession" {
        $proxy=$mockProxy | Start-1ASOAPSession
        $proxy | Should -BeExactly $null
        $mockProxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }

    It "Start-1ASOAPSession -Proxy -PassThru" {
        $proxy=Start-1ASOAPSession -Proxy $mockProxy -PassThru
        $proxy | Should -Not -BeExactly $null
        $proxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }

    It "Proxy | Start-1ASOAPSession -PassThru" {
        $proxy=$mockProxy | Start-1ASOAPSession -PassThru
        $proxy | Should -Not -BeExactly $null
        $proxy.SessionValue.TransactionStatusCode | Should -BeExactly "Start"

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }
}

Describe "$prefix Test-1ASOAPSession" {
    $mockProxy=Set-1ASOAPProxyMock -PassThru
    Mock Get-SOAPProxy {
        $mockProxy
    }

    BeforeEach {
        Set-1ASOAPProxyMock -Proxy $mockProxy
    }
    It "Test-1ASOAPSession" {
        $mockProxy.SessionValue.TransactionStatusCode=Get-RandomValue -String
        $actual=Test-1ASOAPSession
        $actual | Should -BeExactly $true

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Test-1ASOAPSession -Proxy" {
        $mockProxy.SessionValue.TransactionStatusCode=Get-RandomValue -String
        $actual=Test-1ASOAPSession -Proxy $mockProxy
        $actual | Should -BeExactly $true

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Proxy | Test-1ASOAPSession" {
        $mockProxy.SessionValue.TransactionStatusCode=Get-RandomValue -String
        $actual=$mockProxy|Test-1ASOAPSession
        $actual | Should -BeExactly $true

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }

    $testCases=@(
        "Start"
        "InSeries"
        "End"
    )|ForEach-Object {
        @{
            TransactionStatusCode=$_
        }
    }
    It "Test-1ASOAPSession -TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($TransactionStatusCode)
        $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        $actual=Test-1ASOAPSession -TransactionStatusCode $TransactionStatusCode
        $actual | Should -BeExactly $true

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Test-1ASOAPSession -Proxy -TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($TransactionStatusCode)
        $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        $actual=Test-1ASOAPSession -Proxy $mockProxy -TransactionStatusCode $TransactionStatusCode
        $actual | Should -BeExactly $true

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Proxy | Test-1ASOAPSession -TransactionStatusCode <TransactionStatusCode>" -TestCases $testCases {
        param($TransactionStatusCode)
        $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        $actual=$mockProxy|Test-1ASOAPSession -TransactionStatusCode $TransactionStatusCode
        $actual | Should -BeExactly $true

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }
    }
    It "Test-1ASOAPSession -TransactionStatusCode Invalid" {
        {Test-1ASOAPSession -TransactionStatusCode Invalid}|Should throw
    }
    It "Test-1ASOAPSession -Proxy -TransactionStatusCode Invalid" {
        {Test-1ASOAPSession -Proxy $mockProxy -TransactionStatusCode Invalid}|Should throw
    }
    It "Proxy | Test-1ASOAPSession -TransactionStatusCode Invalid" {
        {$proxy| Test-1ASOAPSession -TransactionStatusCode Invalid}|Should throw
    }
}

Describe "$prefix Test-1ASOAPSession with null proxy" {
    Mock Get-SOAPProxy {
        $null
    }

    BeforeEach {

    }
    It "Test-1ASOAPSession" {
        $actual=Test-1ASOAPSession
        $actual | Should -BeExactly $false

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Test-1ASOAPSession -Proxy" {
        $actual=Test-1ASOAPSession -Proxy $null
        $actual | Should -BeExactly $false

        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }
    }
    It "Test-1ASOAPSession -TransactionStatusCode Invalid" {
        {Test-1ASOAPSession -TransactionStatusCode Invalid}|Should throw
    }
    It "Test-1ASOAPSession -Proxy -TransactionStatusCode Invalid" {
        {Test-1ASOAPSession -Proxy $null -TransactionStatusCode Invalid}|Should throw
    }
}

Describe "$prefix Stop-1ASession" {
    $mockProxy=Set-1ASOAPProxyMock -PassThru
    Mock Get-SOAPProxy {
        $mockProxy
    }
    Mock New-SOAPProxyRequest {
        "mock"
    }
    Mock Invoke-1ASOAPOperation {
    }

    BeforeEach {
        Set-1ASOAPProxyMock -Proxy $mockProxy
    }

    $testCases=@(
        "Start"
        "InSeries"
        "End"
    )|ForEach-Object {
        @{
            TransactionStatusCode=$_
        }
    }
    It "Stop-1ASOAPSession while <TransactionStatusCode>" -TestCases $testCases {
        param($TransactionStatusCode)
        $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        Stop-1ASOAPSession
        $mockProxy.SessionValue|Should -BeExactly $null
        $mockProxy.AMA_SecurityHostedUserValue|Should -BeExactly $null
        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -eq $null
        }

        switch($TransactionStatusCode)
        {
            { $_ -in "Start","InSeries"} {
                Assert-MockCalled New-SOAPProxyRequest -Times 1 -Scope It -ParameterFilter {
                    $Operation -eq "Security_SignOut"
                }
                Assert-MockCalled Invoke-1ASOAPOperation -Times 1 -Scope It -ParameterFilter {
                    $Operation -eq "Security_SignOut" -and
                    $Parameter -eq "mock"
                }
            }
            'End' {
                Assert-MockCalled New-SOAPProxyRequest -Times 0 -Scope It
                Assert-MockCalled Invoke-1ASOAPOperation -Times 0 -Scope It
            }
        }
    }
    It "Stop-1ASOAPSession -Proxy while <TransactionStatusCode>" -TestCases $testCases {
        param($TransactionStatusCode)
        $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        Stop-1ASOAPSession -Proxy $mockProxy
        $mockProxy.SessionValue|Should -BeExactly $null
        $mockProxy.AMA_SecurityHostedUserValue|Should -BeExactly $null
        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -ne $null -and 
            $Hashtable.PipedProxy -eq $null
        }

        switch($TransactionStatusCode)
        {
            { $_ -in "Start","InSeries"} {
                Assert-MockCalled New-SOAPProxyRequest -Times 1 -Scope It -ParameterFilter {
                    $Operation -eq "Security_SignOut"
                }
                Assert-MockCalled Invoke-1ASOAPOperation -Times 1 -Scope It -ParameterFilter {
                    $Operation -eq "Security_SignOut" -and
                    $Parameter -eq "mock"
                }
            }
            'End' {
                Assert-MockCalled New-SOAPProxyRequest -Times 0 -Scope It
                Assert-MockCalled Invoke-1ASOAPOperation -Times 0 -Scope It
            }
        }
    }
    It "Proxy | Stop-1ASOAPSession while <TransactionStatusCode>" -TestCases $testCases {
        param($TransactionStatusCode)
        $mockProxy.SessionValue.TransactionStatusCode=$TransactionStatusCode
        $mockProxy|Stop-1ASOAPSession
        $mockProxy.SessionValue|Should -BeExactly $null
        $mockProxy.AMA_SecurityHostedUserValue|Should -BeExactly $null
        Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
            $Hashtable -ne $null -and 
            $Hashtable.Proxy -eq $null -and 
            $Hashtable.PipedProxy -ne $null
        }

        switch($TransactionStatusCode)
        {
            { $_ -in "Start","InSeries"} {
                Assert-MockCalled New-SOAPProxyRequest -Times 1 -Scope It -ParameterFilter {
                    $Operation -eq "Security_SignOut"
                }
                Assert-MockCalled Invoke-1ASOAPOperation -Times 1 -Scope It -ParameterFilter {
                    $Operation -eq "Security_SignOut" -and
                    $Parameter -eq "mock"
                }
            }
            'End' {
                Assert-MockCalled New-SOAPProxyRequest -Times 0 -Scope It
                Assert-MockCalled Invoke-1ASOAPOperation -Times 0 -Scope It
            }
        }
    }
}