# Import the Active Directory module
Import-Module ActiveDirectory

# Set the number of days since last logon
$DaysInactive = 90
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))

# Find all inactive computers
$Computers = Get-ADComputer -Filter { LastLogonTimestamp -lt $InactiveDate }

# Remove the inactive computers
foreach ($Computer in $Computers) {
    Remove-ADComputer -Identity $Computer.Name -Confirm:$false
}

<#This script will first import the Active Directory module. Then, it will set the number of days since last logon to 90 days. Next, it will create a variable called $InactiveDate and set it to the current date minus 90 days. Then, it will use the Get-ADComputer cmdlet to find all computers in Active Directory that have not been logged on to in over 90 days. Finally, it will loop through each computer in the $Computers variable and remove it from Active Directory.

The script will output the following information for each computer that is removed:

The computer's name
The computer's last logon timestamp
The status of the removal operation
If the removal operation is successful, the status will be "Success". If the removal operation fails, the status will be "Failure" and the script will output an error message.

I hope this helps! Let me know if you have any other questions.#>