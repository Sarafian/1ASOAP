$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\1ASOAP\1ASOAP.psm1 -Force
Import-Module $here\..\..\SOAPProxy\Modules\SOAPProxy\SOAPProxy.psm1 -Force

# Setting globally to allow access for code within InModuleScope 
Set-Variable "here" -Value $here -Scope Global

$prefix=($sut -replace '\.ps1','')+" Tests:"
Set-Variable "prefix" -Value $prefix -Scope Global

InModuleScope 1ASOAP {
    . $here\Cmdlets-Helpers\Get-RandomValue.ps1
    . $here\Cmdlets-Helpers\New-1ASOAPProxyMock.ps1

    $mockProxy=New-1ASOAPProxyMock
    Mock Get-SOAPProxy {
        $mockProxy
    }

    Describe "$prefix"{
        BeforeEach {
            $mockProxy.SessionValue=([PSCustomObject]@{ID=1})
            $mockProxy.AMA_SecurityHostedUserValue=([PSCustomObject]@{ID=1})
        }
        It "Clear-1ASOAPSession" {
            $proxy=Clear-1ASOAPSession 
            $proxy|Should -BeNullOrEmpty
            $mockProxy.SessionValue |Should -BeNullOrEmpty
            $mockProxy.AMA_SecurityHostedUserValue |Should -Not -BeNullOrEmpty

            Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
                $Hashtable -ne $null -and 
                $Hashtable.Proxy -eq $null -and 
                $Hashtable.PipedProxy -eq $null
            }
        }
        It "Clear-1ASOAPSession -Proxy" {
            $proxy=Clear-1ASOAPSession -Proxy $mockProxy
            $proxy|Should -BeNullOrEmpty
            $mockProxy.SessionValue |Should -BeNullOrEmpty
            $mockProxy.AMA_SecurityHostedUserValue |Should -Not -BeNullOrEmpty

            Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
                $Hashtable -ne $null -and 
                $Hashtable.Proxy -ne $null -and 
                $Hashtable.PipedProxy -eq $null
            }
        }
        It "Proxy | Clear-1ASOAPSession -PassThru" {
            $proxy=$mockProxy|Clear-1ASOAPSession -PassThru
            $proxy|Should -Not -BeNullOrEmpty
            $proxy.SessionValue |Should -BeNullOrEmpty
            $proxy.AMA_SecurityHostedUserValue |Should -Not -BeNullOrEmpty

            Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
                $Hashtable -ne $null -and 
                $Hashtable.Proxy -eq $null -and 
                $Hashtable.PipedProxy -ne $null
            }
        }
        It "Clear-1ASOAPSessionAMAHeader" {
            $proxy=Clear-1ASOAPSessionAMAHeader 
            $proxy|Should -BeNullOrEmpty
            $mockProxy.SessionValue |Should -Not -BeNullOrEmpty
            $proxy.AMA_SecurityHostedUserValue |Should -BeNullOrEmpty

            Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
                $Hashtable -ne $null -and 
                $Hashtable.Proxy -eq $null -and 
                $Hashtable.PipedProxy -eq $null
            }
        }
        It "Clear-1ASOAPSessionAMAHeader -Proxy" {
            $proxy=Clear-1ASOAPSessionAMAHeader -Proxy $mockProxy
            $proxy|Should -BeNullOrEmpty
            $mockProxy.SessionValue |Should -Not -BeNullOrEmpty
            $proxy.AMA_SecurityHostedUserValue |Should -BeNullOrEmpty

            Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
                $Hashtable -ne $null -and 
                $Hashtable.Proxy -ne $null -and 
                $Hashtable.PipedProxy -eq $null
            }
        }
        It "Proxy | Clear-1ASOAPSessionAMAHeader -PassThru" {
            $proxy=$mockProxy|Clear-1ASOAPSessionAMAHeader -PassThru
            $proxy|Should -Not -BeNullOrEmpty
            $proxy.SessionValue |Should -Not -BeNullOrEmpty
            $proxy.AMA_SecurityHostedUserValue |Should -BeNullOrEmpty

            Assert-MockCalled Get-SOAPProxy -Times 1 -Scope It -ParameterFilter {
                $Hashtable -ne $null -and 
                $Hashtable.Proxy -eq $null -and 
                $Hashtable.PipedProxy -ne $null
            }
        }
    }
}

Remove-Module -Name 1ASOAP