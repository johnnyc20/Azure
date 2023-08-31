<#It seems like you’re looking for a PowerShell script that will remove an Active Directory computer after 180 days of login. Here’s an example of a PowerShell script that removes an Active Directory computer using the Remove-ADComputer cmdlet1:#>
$DaysInactive = 180
$time = (Get-Date).Adddays(-($DaysInactive))
Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} | Remove-ADComputer -Confirm:$false
<#This script will remove all computers that have not logged in for 180 days. You can modify the $DaysInactive variable to change the number of days before a computer is removed.#>

<#To run a PowerShell script, you can follow these steps1:

Open PowerShell by searching for it in the Start menu.
Navigate to the directory where your script is located using the cd command.
Type the name of your script followed by .ps1 and press Enter.
For example, if your script is named myscript.ps1, you would type:

.\myscript.ps1

If you get an error message saying that running scripts is disabled on your system, you can change the execution policy by running the following command in an elevated PowerShell prompt:

Set-ExecutionPolicy RemoteSigned

#>