##Created by ChrisZ-IT, 06.08.16##

Add-PSSnapin -Name Quest.ActiveRoles.ADManagement
#imports CSV file
Import-Csv $env:userprofile\Desktop\NewUsers.csv | ForEach-Object {
#Checks if User already Exists
if (Get-QADUser -Identity $_.Username -Service DC1.doman_name.com)
{
    Write-Host -ForegroundColor Red "Script Stopped.
    User" $_.Username "already Exists! User is either a rehire, transfering departments or has the same name as an existing user.
    Hire Status:" $_.'Hire Status'
    Break
}
Else
{
 $userPrinc = $_."Username" + "@domain_name.com"
#Creates NewUser Account and Fills in details
Write-Host -BackgroundColor Black -ForegroundColor Green  "Creating AD Account"
New-QADUser -Service DC1.domain_name.com -Name $_.Name `
    -ParentContainer $_."OU" `
    -SamAccountName $_."Username" `
    -UserPassword "Set_AD_Password_Here" `
    -FirstName $_."First Name" `
    -LastName $_."Last Name" `
    -Description $_."Title" `
    -UserPrincipalName $userPrinc `
    -DisplayName $_."Name" ; `
Set-QADUser -Service DC1.domain_name.com -Identity $_."Username" `
    -UserMustChangePassword $true `
    -Email $_."Email" `
    -Title $_."Title" `
    -Department $_."Department" `
    -Office $_."Office" `
    -Company "Mood:" `
    -WebPage "http://us.moodmedia.com/"
Set-QADUser -Service DC1.domain_name.com -Identity $_."Username" `
    -Manager $_."Manager"
}
#Adds New User to Groups on Domain 1
Write-Host -BackgroundColor Black -ForegroundColor Green  "Adding New user to similar user's groups on domain 1"
Import-Csv $env:userprofile\Desktop\NewUsers.csv" | ForEach-Object {
  $existinguser = Get-QADUser $_."SimilarUser" -Service DC1.domain_name.com
  $newuser = Get-QADUser $_."Username" -Service DC1.domain_name.com 
    Get-QADUser -Identity $existinguser|
    Get-QADMemberOf |
    where name -ne 'domain users' |
    Add-QADGroupMember -Member $newuser
}
#Adds new User to groups on Domain 2
Write-Host -BackgroundColor Black -ForegroundColor Green  "Adding New user to similar users's groups on domain 2"
Import-Csv $env:userprofile\Desktop\NewUsers.csv" | ForEach-Object {
  $existinguser = Get-QADUser $_."SimilarUser" -Service DC1.domain_name.com
  $newuser = Get-QADUser $_."Username" -Service DC1.domain_name.com
 Get-QADMemberOf -Service DC1.domain_2_name.com $existinguser.sid | where name -ne 'domain users' | Add-QADGroupMember -Member $newuser.Sid
}
#Logs newly created user to network logfile
Write-Host -BackgroundColor Black -ForegroundColor Green  "Logging New user creation"
Import-Csv $env:userprofile\Desktop\NewUsers.csv" |ForEach-Object {
    Get-QADUser $_."Username" -service DC1.domain_name.com | select-object -property @{N='Date Created';E={$_.whenCreated}}, @{N='Name';E={$_.Name}}, @{N='Username';E={$_.Samaccountname}}, @{N='Domain';E={"Domain_1"}}| Export-Csv -path '\\fileserver\SysAdmins\AD Logs\NewUser.csv' -NoTypeInformation -Append
    }}
