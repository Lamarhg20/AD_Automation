# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the path to the CSV file
$csvPath = "C:\path\to\yourcsv\Sample_Data1.csv"

# Read the CSV file
$users = Import-csv $csvPath

# Loop through each user in the csv and create the corresponding AD account
foreach ($user in $users) {
    $username = $user.Username
    $password = ConvertTo-SecureString -String "Password1" -AsPlainText -Force
    $fullname = $user.FullName
    $email = $user.Email
    $jobTitle = $user.JobTitle

    # Check if the OU exists, and create it if it doesn't
    $ouPath = "OU=$jobTitle,DC=yourdomain,DC=com"
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$jobTitle'")) {
        New-ADOrganizationalUnit -Name $jobTitle -Path "DC=yourdomain,DC=com"
    }

    # Create a new user in Active Directory
    New-ADUser -SamAccountName $username -UserPrincipalName "$username @yourdomain.com" -Name $fullname -GivenName $fullname.Split(" ")[0] -Surname $fullname.Split(" ")[1] -EmailAddress $email -Enabled $true -AccountPassword $password -ChangePasswordAtLogon $true -city $_.location -department $_.JobTitle -PassThru | Move-ADObject -TargetPath $ouPath
}