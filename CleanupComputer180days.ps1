# Import the Active Directory module
Import-Module ActiveDirectory

# Set the number of days since last logon
$DaysInactive = 180
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))

# Find all inactive computers
$Computers = Get-ADComputer -Filter { LastLogonDate -lt $InactiveDate }

# Export the list of inactive computers to a CSV file
$Computers | Export-Csv C:\Temp\InactiveComputers.csv -NoTypeInformation

# Delete the inactive computers
foreach ($Computer in $Computers) {
    Remove-ADComputer -Identity $Computer.Name -Confirm:$false
}

<#This script will first import the Active Directory module. Then, it will set the number of days since last logon to 180 days. Next, it will create a variable called $InactiveDate and set it to the current date minus 180 days. Then, it will use the Get-ADComputer cmdlet to find all computers in Active Directory that have not been logged on to in over 180 days. Finally, it will loop through each computer in the $Computers variable and delete it from Active Directory.

The script will also export the list of inactive computers to a CSV file called C:\Temp\InactiveComputers.csv. This file can be used to track the inactive computers and to manually delete them if necessary.

I hope this helps! Let me know if you have any other questions.#>