### Script to pull a list of domain admins ###
### Author: ChrisZ-IT ###
### This script needs to be run at least once and any time you add or remove any account from the 'Domain Admin' Group ###
### This could also be applied to any group you want to monitor ###
### Version: 1.1 ###

#imports AD Powershell Module
Import-Module ActiveDirectory

#Pulls list of users in 'Domain Admins' group & exports them to an xml file.
Get-ADGroupMember -Identity "Domain Admins" -Server DC1  |
Select-Object -ExpandProperty samaccountname |
Export-Clixml -Path $env:userprofile\desktop\CurrentDomainAdmins.xml

