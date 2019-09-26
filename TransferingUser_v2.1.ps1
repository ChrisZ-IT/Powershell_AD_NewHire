### Script to update existing user in AD using MS's AD cmdlts###
### Author: ChrisZ-IT ###
### Version: 2.2 ###
### Created 05.02.2019; Updated: 06.04.2019 ###

#Removes any defined variables from other scripts run before this
    clear
    Remove-Variable * -ErrorAction SilentlyContinue

#imports CSV file
Import-Csv $env:userprofile\Desktop\NewUsers.csv | ForEach-Object {
$userPrinc = $_."Username" + "domain1.com"
#Updates User info in AD
Write-Host -BackgroundColor Black -ForegroundColor Green  "Updating AD Account Info for"$_.Name
Set-ADUser -Server DC1.Domain1.com -Identity $_.'Username' `
    -Description $_.'Title' `
    -EmailAddress $_.'Email' `
    -Title $_.'Title' `
    -Department $_.'Department' `
    -Office $_.'Office' `
    -Company 'Company Name' `
    -HomePage http://domain1.com/ `

Set-ADUser -Server DC1.Domain1.com -Identity $_.'Username' `
    -Manager $_.'Manager'
   
Sleep 2

#Adds User to Groups on Domain1
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Adding user to similar user's domain1 groups (An error means similar users's name is wrong or is on domain2)"
        $existinguser = Get-ADUser -Filter "Name -like '$($_.'SimilarUser')'" -Server DC1.Domain1.com
        $newuser = Get-ADUser $_."Username" -Server DC1.Domain1.com 
        $domain1Groups = Get-ADPrincipalGroupMembership $existinguser -Server DC1.Domain1.com | Where name -ne 'domain users' | Where name -NE 'Enterprise Admins'| Where Name -NE 'Domain Admins'| Where name -NE 'Schema Admins'

    ForEach ($g in $domain1Groups){
        Add-ADPrincipalGroupMembership -Identity $newuser -MemberOf $g -Server DC1.Domain1.com -Confirm:$false > $null
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Adding" $newuser.Name "to" $g.GroupType $g.ClassName -NoNewline ; write-host -BackgroundColor white -ForegroundColor blue $g.Name ""
        

    }

#Adds User to groups on Domain2
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Adding user to similar users's domain2 groups (An error means no domain2 groups)"
        $existinguser = Get-ADUser -Filter "Name -Like '$($_.'SimilarUser')'" -Server DC1.Domain1.com
        $newuser = Get-ADUser -Identity $_."Username" -Server DC1.Domain1.com
        $domain2Groups =  Get-ADPrincipalGroupMembership $existinguser -Server DC1.Domain1.com -ResourceContextServer DC1.Domain2.com | Where name -NE 'domain users' | Where name -NE 'Enterprise Admins'| Where Name -NE 'Domain Admins'| Where name -ne 'Schema Admins'

    Foreach ($g in $domain2groups){
        Add-ADGroupMember -Identity $g  -Members $newuser -Server DC1.Domain2.com
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Adding" $newuser.Name "to" $g.GroupType $g.ClassName -NoNewline ; write-host -b white -f blue $g.Name ""
        
    }
#Sends Email to helpdesk when finished
#    Write-Host -BackgroundColor Black -ForegroundColor Green  "Updating New Hire Ticket. Ticket# "+ $_.'Request ID'

#        $From = 'admin@domain1.com'
#        $To = 'help_desk@domain1.com'
#        $Subject = ("ServiceDesk - Comment added to Request ID "+$_.'Request ID')
#        $Body = $_.'HD Info'
#        $SMTPServer = 'smtp.domain1.com'

#    Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -BodyAsHtml -SmtpServer $SMTPServer
    
#Lets admin know script is done running for selected user
    Write-host -BackgroundColor Black -ForegroundColor Green "AD account for"$_.Name "has finished updating"

#Clears defined varibals getting script ready to be run again
    Remove-Variable * -ErrorAction SilentlyContinue
}
