### Script for finding finding and then disabling stale Domain2 domain computers using Quest's AD cmdlts###
### Author: ChrisZ-IT ###
### Version: 1.1 ###
### Created 06.09.2016 ###

#imports Quest cmdlets
Add-PSSnapin -Name Quest.ActiveRoles.ADManagement

$TargetOU = "ou=Disabled,ou=Users,dc=domain2,dc=com"
$Date = Get-Date -Format MM/dd/yyyy

#Manually update script with users first and last name or their SamAccountname
$DN = Get-QADUser -Identity 'Test User' -Service DC1.domain2.com

#Sets user's description
Set-QADUser -Identity $DN.SamAccountName -Description "Termed $Date" -service dc1.domain2.com

#Disables their account
disable-qaduser -Identity $DN.SamAccountName -service dc1.domain2.com

#Moves them to the Termed user OU
Move-QADObject -Identity $DN.SamAccountName -NewParentContainer $TargetOU -service dc1.domain2.com

#Removes them from all AD groups on domain2
Remove-QADMemberOf $DN.SamAccountName -RemoveAll -Service dc1.domain2.com

#Removes them from all AD group on domain1
Remove-QADMemberOf -Service dc1.domain2.com $DN.Sid -RemoveAll
