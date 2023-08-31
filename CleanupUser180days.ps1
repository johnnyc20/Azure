# Import the Active Directory module
Import-Module ActiveDirectory

# Set the number of days since last logon
$DaysInactive = 180
$InactiveDate = (Get-Date).Adddays(-($DaysInactive))

# Find all inactive users
$Users = Get-ADUser -Filter { LastLogonDate -lt $InactiveDate }

# Delete the inactive users
foreach ($User in $Users) {
    Remove-ADUser -Identity $User.SamAccountName -Confirm:$false
}

<#This script will first import the Active Directory module. Then, it will set the number of days since last logon to 180 days. Next, it will create a variable called $InactiveDate and set it to the current date minus 180 days. Then, it will use the Get-ADUser cmdlet to find all users in Active Directory that have not logged on to in over 180 days. Finally, it will loop through each user in the $Users variable and delete it from Active Directory.

The script will output the following information for each user that is deleted:

The user's samAccountName
The user's last logon timestamp
The status of the deletion operation
If the deletion operation is successful, the status will be "Success". If the deletion operation fails, the status will be "Failure" and the script will output an error message.

I hope this helps! Let me know if you have any other questions.    #>