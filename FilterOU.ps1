<#Find Distinguished Name; Filter By Two Different OUs#>

Get-ADOrganizationalUnit -Filter 'Name -like "*ABCDEF*"' |
    Where-Object {$_.DistinguishedName -match 'Navy'} |
        Select-Object -Property Name, DistinguishedName