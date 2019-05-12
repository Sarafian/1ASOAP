#Requires -Modules SOAPProxy

$public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -Exclude @("*NotReady*","*.Tests.ps1"))
$private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -Exclude @("*NotReady*","*.Tests.ps1"))

Foreach($import in @($public + $private))
{
	. $import.FullName
}

Export-ModuleMember -Function $public.BaseName
#Export-ModuleMember -Function $private.BaseName