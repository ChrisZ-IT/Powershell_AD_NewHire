### Script to create new user in AD from converted csv file Using MS's AD cmdlts ###
### Author: ChrisZ-IT ###
### Version: 2.2 ###
### Created 05.02.2019; Updated: 06.04.2019 ###

#Imports MS's AD cmdlets
    Import-Module ActiveDirectory

#Removes any defined variables from other scripts run before this
    Remove-Variable * -ErrorAction SilentlyContinue

#Imports CSV file
Import-Csv $env:userprofile\Desktop\NewUsers.csv | ForEach-Object {

#Checks if User already Exists

$userobj = $(try {Get-ADUser $_.username} catch {$Null})
If ($userobj -ne $Null) {
    Write-Host -ForegroundColor Red "Script Stopped."
    Write-Host -ForegroundColor Red "User" $_.Username "already Exists! User is either a rehire, transfering departments or has the same name as an existing user."
    Write-Host -ForegroundColor Red "Hire Status:" $_.'Hire Status'
    Break
}
Else
{
$userPrinc = $_."Username" + "@domain1.com"
$Secure_String_Pwd = ConvertTo-SecureString "Temp_AD_Password_Here" -AsPlainText -Force

#Creates NewUser Account and Fills in details
Write-Host -BackgroundColor Black -ForegroundColor Green  "Creating AD Account For"$_.Name

New-ADUser -Server DC1.domain1.com -Name $_.'Name' `
    -SamAccountName $_.'Username' `
    -Path $_.'OU' `
    -AccountPassword $Secure_String_Pwd `
    -GivenName $_.'First Name' `
    -Surname $_.'Last Name' `
    -Description $_.'Title' `
    -UserPrincipalName $userPrinc `
    -DisplayName $_.'Name' `

Set-ADUser -Server DC1.domain1.com -Identity $_.'Username' `
    -ChangePasswordAtLogon $true `
    -EmailAddress $_.'Email' `
    -Title $_.'Title' `
    -Department $_.'Department' `
    -Office $_.'Office' `
    -Company 'CompanyName' `
    -Enabled $true `
    -HomePage http://domain1.com/ `

Set-ADUser -Server DC1.domain1.com -Identity $_.'Username' `
    -Manager $_.'Manager'
   

Sleep 5

#Adds New User to Groups on domain1 Domain
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Adding user to similar user's domain1 groups (An error means similar users's name is wrong or is a domain2 user)"
        $existinguser = Get-ADUser -Filter "Name -like '$($_.'SimilarUser')'" -Server DC1.domain1.com
        $newuser = Get-ADUser $_."Username" -Server DC1.domain1.com 
        $domain1Groups = Get-ADPrincipalGroupMembership $existinguser -Server DC1.domain1.com | Where name -ne 'domain users' | Where name -NE 'Enterprise Admins'| Where Name -NE 'Domain Admins'| Where name -NE 'Schema Admins'

    ForEach ($g in $domain1Groups){
        Add-ADPrincipalGroupMembership -Identity $newuser -MemberOf $g -Server DC1.domain1.com -Confirm:$false > $null
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Adding" $newuser.Name "to" $g.GroupType $g.ClassName -NoNewline ; write-host -BackgroundColor white -ForegroundColor blue $g.Name ""
        

    }

#Adds new User to groups on domain2 Domain
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Adding user to similar users's domain2 groups (An error means no domain2 groups)"
        $existinguser = Get-ADUser -Filter "Name -like '$($_.'SimilarUser')'" -Server DC1.domain1.com
        $newuser = Get-ADUser -Identity $_."Username" -Server DC1.domain1.com
        $domain2Groups =  Get-ADPrincipalGroupMembership $existinguser -Server DC1.domain1.com -ResourceContextServer DC1.domain2.com | Where name -NE 'domain users' | Where name -NE 'Enterprise Admins'| Where Name -NE 'Domain Admins'| Where name -ne 'Schema Admins'

    Foreach ($g in $domain2Groups){
        Add-ADGroupMember -Identity $g  -Members $newuser -Server DDC1.domain2.com
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Adding" $newuser.Name "to" $g.GroupType $g.ClassName -NoNewline ; write-host -b white -f blue $g.Name ""
        
    }

#Sends Email to helpdesk when finished
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Updating New Hire Ticket. Ticket#"$_.'Request ID'

    $From = 'Admin@domain1.com'
    $To = 'help_desk@domain1.com'
    $Subject = ("ServiceDesk - Comment added to Request ID "+$_.'Request ID')
    $Body = $_.'HD Info'
    $SMTPServer = 'smtp.domain1.com'

    Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer


#Logs newly created user to network logfile
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Logging New user creation"
    Get-ADUser $_."Username" -Server DC1.domain1.com -Properties *|
    Select-Object -property @{N='Date Created';E={$_.whenCreated}}, @{N='Name';E={$_.Name}}, @{N='Username';E={$_.Samaccountname}}, @{N='Domain';E={"domain1"}}|
    Export-Csv -path '\\fileserver\share\AD Logs\NewUser.csv' -NoTypeInformation -Append
    

#Lets admin know script is done running for selected user
    Write-host -BackgroundColor Black -ForegroundColor Green "AD account for"$_.Name "has been created"

#Clears defined varibals getting script ready to be run again
Remove-Variable * -ErrorAction SilentlyContinue
    }
}
