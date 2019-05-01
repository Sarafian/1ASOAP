$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
Import-Module $here\..\Modules\1ASOAP\1ASOAP.psm1 -Force
Import-Module $here\..\..\SOAPProxy\Modules\SOAPProxy\SOAPProxy.psm1 -Force

$prefix=($sut -replace '\.ps1','')+" Tests:"

. $here\Cmdlets-Helpers\Get-RandomValue.ps1
. $here\Cmdlets-Helpers\New-1ASOAPProxyMock.ps1

