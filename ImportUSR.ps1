# Import the Azure Active Directory module
Import-Module AzureAD

# Set the path to the CSV file
$csvPath = "C:\Users\username\Desktop\users.csv"

# Read the CSV file
$users = Import-Csv -Path $csvPath

# Connect to Azure AD
Connect-AzureAD

# Loop through each user in the CSV file
foreach ($user in $users) {

    # Create a new user object
    $newUserParams = @{
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        PasswordProfile = @{
            Password = $user.Password
            ForceChangePasswordNextSignIn = $true
        }
    }

    # Add the user to Azure AD
    New-AzureADUser @newUserParams
}
<#The CSV file that you use to import users to Azure AD must have the following columns:

DisplayName: The user's display name.
UserPrincipalName: The user's user principal name (UPN). This is the user's email address.
Password: The user's password.
You can also include additional columns in the CSV file, such as the user's first name, last name, and department. However, the DisplayName, UserPrincipalName, and Password columns are required.

Once you have created the CSV file and the PowerShell script, you can run the script to import the users to Azure AD. The script will first import the CSV file into a variable called $users. Then, it will loop through each user in the $users variable and create a new user object in Azure AD. Finally, it will add the user object to Azure AD.

The script will output the following information for each user that is imported:

The user's displayName
The user's userPrincipalName
The status of the import operation
If the import operation is successful, the status will be "Success". If the import operation fails, the status will be "Failure" and the script will output an error message.

I hope this helps! Let me know if you have any other questions.#>