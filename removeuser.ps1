<#Description
The Remove-ADUser cmdlet removes an Active Directory user.

The Identity parameter specifies the Active Directory user to remove. You can identify a user by its distinguished name (DN), GUID, security identifier (SID), or Security Account Manager (SAM) account name. You can also set the Identity parameter to a user object variable, such as $<localUserObject>, or you can pass a user object through the pipeline to the Identity parameter. For example, you can use the Get-ADUser cmdlet to retrieve a user object and then pass the object through the pipeline to the Remove-ADUser cmdlet.

If the ADUser is being identified by its DN, the Partition parameter will be automatically determined.

For AD LDS environments, the Partition parameter must be specified except in the following two conditions:

The cmdlet is run from an Active Directory provider drive.
A default naming context or partition is defined for the AD LDS environment. To specify a default naming context for an AD LDS environment, set the msDS-defaultNamingContext property of the Active Directory directory service agent (DSA) object (nTDSDSA) for the AD LDS instance.#>

# Remove a specified user
Remove-ADUser -Identity GlenJohn

# Remove a filtered list of users
Search-ADAccount -AccountDisabled | where {$_.ObjectClass -eq 'user'} | Remove-ADUser

#Remove a user by distinguished name
Remove-ADUser -Identity "CN=Glen John,OU=Finance,OU=UserAccounts,DC=FABRIKAM,DC=COM"

#Get a user by distinguished name and remove it
Get-ADUser -Identity "cn=glenjohn,dc=appnc" -Server Lds.Fabrikam.com:50000 | Remove-ADUser

<#Parameters
-AuthType
Specifies the authentication method to use. The acceptable values for this parameter are:

Negotiate or 0
Basic or 1
The default authentication method is Negotiate.

A Secure Sockets Layer (SSL) connection is required for the Basic authentication method.

Type:	ADAuthType
Accepted values:	Negotiate, Basic
Position:	Named
Default value:	None
Accept pipeline input:	False
Accept wildcard characters:	False
-Confirm
Prompts you for confirmation before running the cmdlet.

Type:	SwitchParameter
Aliases:	cf
Position:	Named
Default value:	False
Accept pipeline input:	False
Accept wildcard characters:	False
-Credential
Specifies the user account credentials to use to perform this task. The default credentials are the credentials of the currently logged on user unless the cmdlet is run from an Active Directory PowerShell provider drive. If the cmdlet is run from such a provider drive, the account associated with the drive is the default.

To specify this parameter, you can type a user name, such as User1 or Domain01\User01 or you can specify a PSCredential object. If you specify a user name for this parameter, the cmdlet prompts for a password.

You can also create a PSCredential object by using a script or by using the Get-Credential cmdlet. You can then set the Credential parameter to the PSCredential object.

If the acting credentials do not have directory-level permission to perform the task, Active Directory PowerShell returns a terminating error.

Type:	PSCredential
Position:	Named
Default value:	None
Accept pipeline input:	False
Accept wildcard characters:	False
-Identity
Specifies an Active Directory user object by providing one of the following property values. The identifier in parentheses is the LDAP display name for the attribute. The acceptable values for this parameter are:

A Distinguished name
A GUID (objectGUID)
A Security Identifier (objectSid)
A SAM account name (sAMAccountName)
The cmdlet searches the default naming context or partition to find the object. If two or more objects are found, the cmdlet returns a non-terminating error.

This parameter can also get this object through the pipeline or you can set this parameter to an object instance.

Type:	ADUser
Position:	0
Default value:	None
Accept pipeline input:	True
Accept wildcard characters:	False
-Partition
Specifies the distinguished name of an Active Directory partition. The distinguished name must be one of the naming contexts on the current directory server. The cmdlet searches this partition to find the object defined by the Identity parameter.

In many cases, a default value will be used for the Partition parameter if no value is specified. The rules for determining the default value are given below. Note that rules listed first are evaluated first and once a default value can be determined, no further rules will be evaluated.

In AD DS environments, a default value for Partition will be set in the following cases:

If the Identity parameter is set to a distinguished name, the default value of Partition is automatically generated from this distinguished name.
If running cmdlets from an Active Directory provider drive, the default value of Partition is automatically generated from the current path in the drive.
If none of the previous cases apply, the default value of Partition will be set to the default partition or naming context of the target domain.
In AD LDS environments, a default value for Partition will be set in the following cases:

If the Identity parameter is set to a distinguished name, the default value of Partition is automatically generated from this distinguished name.
If running cmdlets from an Active Directory provider drive, the default value of Partition is automatically generated from the current path in the drive.
If the target AD LDS instance has a default naming context, the default value of Partition will be set to the default naming context. To specify a default naming context for an AD LDS environment, set the msDS-defaultNamingContext property of the Active Directory directory service agent (DSA) object (nTDSDSA) for the AD LDS instance.
If none of the previous cases apply, the Partition parameter will not take any default value.
Type:	String
Position:	Named
Default value:	None
Accept pipeline input:	False
Accept wildcard characters:	False
-Server
Specifies the AD DS instance to connect to, by providing one of the following values for a corresponding domain name or directory server. The service may be any of the following: AD LDS, AD DS, or Active Directory snapshot instance.

Specify the AD DS instance in one of the following ways:

Domain name values:

Fully qualified domain name
NetBIOS name
Directory server values:

Fully qualified directory server name
NetBIOS name
Fully qualified directory server name and port
The default value for this parameter is determined by one of the following methods in the order that they are listed:

By using the Server value from objects passed through the pipeline
By using the server information associated with the AD DS Windows PowerShell provider drive, when the cmdlet runs in that drive
By using the domain of the computer running Windows PowerShell
Type:	String
Position:	Named
Default value:	None
Accept pipeline input:	False
Accept wildcard characters:	False
-WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

Type:	SwitchParameter
Aliases:	wi
Position:	Named
Default value:	False
Accept pipeline input:	False
Accept wildcard characters:	False
Inputs
None or Microsoft.ActiveDirectory.Management.ADUser

A user object is received by the Identity parameter.

Outputs
None

Notes
This cmdlet does not work with an Active Directory snapshot.
This cmdlet does not work with a read-only domain controller.
By default, this cmdlet prompts for confirmation as it is defined with High impact and the default value of the $ConfirmPreference variable is High. To bypass prompting for confirmation before removal, you can specify -Confirm:$False when using this cmdlet.#>