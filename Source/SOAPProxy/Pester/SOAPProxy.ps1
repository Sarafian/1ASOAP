$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\SOAPProxy\SOAPProxy.psm1 -Force


$prefix=($sut -replace '\.ps1','')+" Tests:"

. $here\Cmdlets-Helpers\Get-RandomValue.ps1

$testCases=@(
    @{
        Uri="https://uri1.com"
    }
    @{
        Uri="https://uri2.com"
        NameSpace=$null
        Class=$null
    }
    @{
        Uri="https://uri3.com"
        NameSpace="Namespace3"
        Class="Class1"
    }
    @{
        Uri="https://uri4.com"
        NameSpace="Namespace4"
        Class="Class4"
        Default=$true
    }
)
$testCases|ForEach-Object {
    $_.Add("NormalizedUri",([System.Uri]$_.Uri).AbsoluteUri)
}
<#
Describe "$prefix Initialize-SOAPProxy without default proxy" {
    BeforeAll {
        Remove-Variable -Name "SOAPProxy*" -Scope Global -ErrorAction SilentlyContinue
    }
    Mock New-WebServiceProxy {
        [PSCustomObject]@{
            Uri=[System.Uri]$Uri.AbsoluteUri
            NameSpace=$Namespace
            Class=$Class
        }
        
    }
    It "[NotInitialized]:Initialize-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class> -PassThru" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $splat=@{
            Uri=$Uri
        }
        if($Namespace)
        {
            $splat.Add("Namespace",$Namespace)
        }
        if($Class)
        {
            $splat.Add("Class",$Class)
        }
        $actual=Initialize-SOAPProxy @splat -PassThru
        $actual | Should -Not -BeNullOrEmpty
        $actual.Uri | Should -BeExactly $NormalizedUri
        $actual.Namespace | Should -BeExactly $Namespace
        $actual.Class | Should -BeExactly $Class
        Assert-MockCalled New-WebServiceProxy -Times 1 -Scope It -ParameterFilter {
#            Write-Host "$Uri -eq $NormalizedUri=$($Uri -eq $NormalizedUri)" 
#            Write-Host "$Namespace -eq $($splat.Namespace)=$($Namespace -eq $splat.Namespace)" 
#            Write-Host "$Class -eq $($splat.Class)=$($Class -eq $splat.Class)" 
            ($Uri -eq $NormalizedUri) -and
            ($Namespace -eq $splat.Namespace) -and
            ($Class -eq $splat.Class)
        }
    }
    It "[Initialized]:Initialize-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class> -PassThru" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $splat=@{
            Uri=$Uri
        }
        if($Namespace)
        {
            $splat.Add("Namespace",$Namespace)
        }
        if($Class)
        {
            $splat.Add("Class",$Class)
        }
        $actual=Initialize-SOAPProxy @splat -PassThru
        $actual | Should -Not -BeNullOrEmpty
        $actual.Uri | Should -BeExactly $NormalizedUri
        $actual.Namespace | Should -BeExactly $Namespace
        $actual.Class | Should -BeExactly $Class
        Assert-MockCalled New-WebServiceProxy -Times 0 -Scope It -ParameterFilter {
            ($Uri -eq $NormalizedUri) -and
            ($Namespace -eq $splat.Namespace) -and
            ($Class -eq $splat.Class)
        }
    }    
    It "[Initialized]:Initialize-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class>" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $splat=@{
            Uri=$Uri
        }
        if($Namespace)
        {
            $splat.Add("Namespace",$Namespace)
        }
        if($Class)
        {
            $splat.Add("Class",$Class)
        }
        $actual=Initialize-SOAPProxy @splat
        $actual | Should -BeNullOrEmpty
        Assert-MockCalled New-WebServiceProxy -Times 0 -Scope It -ParameterFilter {
            ($Uri -eq $NormalizedUri) -and
            ($Namespace -eq $splat.Namespace) -and
            ($Class -eq $splat.Class)
        }
    }    
    It "Get-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class>" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $actual=Get-SOAPProxy -Uri $Uri
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }

    It "Get-SOAPProxy Default should throw" {
        {Get-SOAPProxy} | Should -Throw
    }
    It "Initialize-SOAPProxy -Uri invaliduri should throw" {
        {Initialize-SOAPProxy -Uri invaliduri} | Should -Throw
    }

}

Describe "$prefix Initialize-SOAPProxy with default proxy" {
    BeforeEach {
        Remove-Variable -Name "SOAPProxy*" -Scope Global -ErrorAction SilentlyContinue
    }
    Mock New-WebServiceProxy {
        [PSCustomObject]@{
            Uri=[System.Uri]$Uri.AbsoluteUri
            NameSpace=$Namespace
            Class=$Class
        }
        
    }
    It "Initialize-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class> -AsDefault" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $splat=@{
            Uri=$Uri
        }
        if($Namespace)
        {
            $splat.Add("Namespace",$Namespace)
        }
        if($Class)
        {
            $splat.Add("Class",$Class)
        }
        Initialize-SOAPProxy @splat -AsDefault
        $actual=Get-SOAPProxy
        $actual | Should -Not -BeNullOrEmpty
        $actual.Uri | Should -BeExactly $NormalizedUri
        $actual.Namespace | Should -BeExactly $Namespace
        $actual.Class | Should -BeExactly $Class
        Assert-MockCalled New-WebServiceProxy -Times 1 -Scope It -ParameterFilter {
#            Write-Host "$Uri -eq $NormalizedUri=$($Uri -eq $NormalizedUri)" 
#            Write-Host "$Namespace -eq $($splat.Namespace)=$($Namespace -eq $splat.Namespace)" 
#            Write-Host "$Class -eq $($splat.Class)=$($Class -eq $splat.Class)" 
            ($Uri -eq $NormalizedUri) -and
            ($Namespace -eq $splat.Namespace) -and
            ($Class -eq $splat.Class)
        }
    }
}

Describe "$prefix Initialize-SOAPProxy mixed default proxy" {
    BeforeAll {
        Remove-Variable -Name "SOAPProxy*" -Scope Global -ErrorAction SilentlyContinue
    }
    Mock New-WebServiceProxy {
        [PSCustomObject]@{
            Uri=[System.Uri]$Uri.AbsoluteUri
            NameSpace=$Namespace
            Class=$Class
        }
        
    }
    It "Initialize-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class> -AsDefault <Default>" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class,$Default)
        $splat=@{
            Uri=$Uri
        }
        if($Namespace)
        {
            $splat.Add("Namespace",$Namespace)
        }
        if($Class)
        {
            $splat.Add("Class",$Class)
        }
        if($Default)
        {
            Initialize-SOAPProxy @splat -AsDefault
        }
        else {
            Initialize-SOAPProxy @splat
        }
    }
    It "Get-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class>" -TestCases $testCases{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $actual=Get-SOAPProxy -Uri $Uri
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Get-SOAPProxy -Uri Check DefaultProxy" -TestCases $testCases {
        param($Uri,$NormalizedUri,$Namespace,$Class,$Default)
        $actual=Get-SOAPProxy
        if($Default)
        {
            $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        }
        else {
            $actual.Uri.AbsoluteUri | Should -Not -BeExactly $NormalizedUri
        }
    }
}
$getSOAPProxyTestCase=$testCases|Select-Object -First 1
Describe "$prefix Get-SOAPProxy" {
    BeforeAll {
        Remove-Variable -Name "SOAPProxy*" -Scope Global -ErrorAction SilentlyContinue
    }
    Mock New-WebServiceProxy {
        [PSCustomObject]@{
            Uri=[System.Uri]$Uri.AbsoluteUri
            NameSpace=$Namespace
            Class=$Class
        }
        
    }
    It "Initialize-SOAPProxy -Uri <URI> -NameSpace <Namespace> -Class <Class> -AsDefault <Default>" -TestCases $getSOAPProxyTestCase {
        param($Uri,$NormalizedUri,$Namespace,$Class,$Default)
        $splat=@{
            Uri=$Uri
        }
        if($Namespace)
        {
            $splat.Add("Namespace",$Namespace)
        }
        if($Class)
        {
            $splat.Add("Class",$Class)
        }
        Initialize-SOAPProxy @splat -AsDefault
    }
    It "Get-SOAPProxy" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $actual=Get-SOAPProxy
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Get-SOAPProxy -Uri <URI>" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $actual=Get-SOAPProxy -Uri $Uri
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Get-SOAPProxy -Proxy" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $proxy=Get-SOAPProxy -Uri $Uri
        $actual=Get-SOAPProxy -Proxy $proxy
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Proxy | Get-SOAPProxy" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        
        $actual=Get-SOAPProxy -Uri $Uri | Get-SOAPProxy
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Get-SOAPProxy -Hashtable $hashTable.Uri" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $hash=@{
            Uri=$Uri
        }
        $actual=Get-SOAPProxy -Hashtable $hash
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Get-SOAPProxy -Hashtable $hashTable.Proxy" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $hash=@{
            Proxy=Get-SOAPProxy
        }
        $actual=Get-SOAPProxy -Hashtable $hash
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }
    It "Get-SOAPProxy -Hashtable $hashTable.PipedProxy" -TestCases $getSOAPProxyTestCase{
        param($Uri,$NormalizedUri,$Namespace,$Class)
        $hash=@{
            PipedProxy=Get-SOAPProxy
        }
        $actual=Get-SOAPProxy -Hashtable $hash
        $actual.Uri.AbsoluteUri | Should -BeExactly $NormalizedUri
        $actual.NameSpace | Should -BeExactly $NameSpace
        $actual.Class | Should -BeExactly $Class
    }

}
#>
Describe "$prefix Get-SOAPProxyInfo and New-SOAPProxyRequest" {
    BeforeAll {
        Remove-Variable -Name "SOAPProxy*" -Scope Global -ErrorAction SilentlyContinue
    }

    $mockMethods=@(
        @{
            Name="DoSomething1"
            Definition="System.String DoSomething1(System.Object)"
        }
        @{
            Name="DoSomething1Async"
        }
        @{
            Name="DoSomething2"
            Definition="System.Object DoSomething2(System.String)"
        }
        @{
            Name="DoSomething2Async"
        }
        @{
            Name="Cancel"
        }
        @{
            Name="CancelAsync"
        }
    )|ForEach-Object {New-Object -TypeName PSCustomObject -Property $_}

    Mock Get-SOAPProxy {
        ""
    }
    Mock Get-Member {
        if($Name -like "*Async")
        {
            $mockMethods |Where-Object -Property Name -Like $Name
        }
        else {
            $mockMethods |Where-Object -Property Name -EQ $Name
        }
    }
    $proxy="dummyProxy"
    It "Get-SOAPProxyInfo -Proxy"{
        $actual=Get-SOAPProxyInfo -Proxy $proxy
        $actual | Should -Not -BeNullOrEmpty
        $actual.Length | Should -BeExactly 2
        $actual[0].Operation | Should -BeExactly "DoSomething1"
        $actual[0].RequestType | Should -BeExactly ("System.Object" -as [type])
        $actual[0].ResponseType | Should -BeExactly ("System.String" -as [type])
        $actual[1].Operation | Should -BeExactly "DoSomething2"
        $actual[1].RequestType | Should -BeExactly ("System.String" -as [type])
        $actual[1].ResponseType | Should -BeExactly ("System.Object" -as [type])
    }
    It "Proxy | Get-SOAPProxyInfo"{
        $actual=$proxy|Get-SOAPProxyInfo
        $actual | Should -Not -BeNullOrEmpty
        $actual.Length | Should -BeExactly 2
        $actual[0].Operation | Should -BeExactly "DoSomething1"
        $actual[0].RequestType | Should -BeExactly ("System.Object" -as [type])
        $actual[0].ResponseType | Should -BeExactly ("System.String" -as [type])
        $actual[1].Operation | Should -BeExactly "DoSomething2"
        $actual[1].RequestType | Should -BeExactly ("System.String" -as [type])
        $actual[1].ResponseType | Should -BeExactly ("System.Object" -as [type])
    }
    It "New-SOAPProxyRequest -Proxy -Operation DoSomething1"{
        $actual=New-SOAPProxyRequest -Proxy $proxy -Operation DoSomething1
        $actual | Should -Not -BeNullOrEmpty
        $actual |Should -BeOfType "System.Object"
    }
    It "Proxy | New-SOAPProxyRequest -Operation DoSomething1"{
        $actual=$proxy| New-SOAPProxyRequest -Operation DoSomething1
        $actual | Should -Not -BeNullOrEmpty
        $actual |Should -BeOfType "System.Object"
    }
    It "New-SOAPProxyRequest -Proxy -Operation DoSomething2"{
        $actual=New-SOAPProxyRequest -Proxy $proxy -Operation DoSomething2
        $actual | Should -Not -BeExactly $null
        $actual |Should -BeOfType "System.String"
    }
    It "Proxy | New-SOAPProxyRequest -Operation DoSomething2"{
        $actual=$proxy | New-SOAPProxyRequest -Operation DoSomething2
        $actual | Should -Not -BeExactly $null
        $actual |Should -BeOfType "System.String"
    }

}