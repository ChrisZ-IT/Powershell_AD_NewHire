### Script for finding finding and then disabling stale domain computers using MS's AD cmdlts###
### Author: ChrisZ-IT ###
### Version: 2.1 ###
### Created 05.09.2016; Updated: 05.09.2019 ###

#Imports MS's AD cmdlets
Import-Module ActiveDirectory

#Number of days since last login. (-90) is 90 days.
$Date = (Get-Date).AddDays(-90)

#Finds all Computers that have not logged into AD in X days(See $date for # of days)
    Get-ADComputer -Property Name,lastLogonDate,OperatingSystem -Filter {lastLogonDate -lt $Date}  -server DC1 |

#Filters out computers that are already disabled
    Where Enabled -ne $false |

#Filters out Computers that are also already in disabled computers OU
    Where-Object {$_.DistinguishedName -NotLike '*OU=Disabled_Workstations,DC=domain1,DC=com'}|

#Selects Computer's Hostname, it's OS, Last time it logged into AD, Description and Sends a test ping to see if it's really down.
    Select-Object Name, OperatingSystem,lastLogonDate,DistinguishedName,Description,@{N='Is UP';E={Test-Connection -Count 1 -Quiet -computer $_.name}}|

#Exports csv of found PCs to desktop.
    Export-Csv $env:userprofile\desktop\ADPCs_$((Get-Date).ToString('MM-dd-yyyy')).csv -NoTypeInformation -Encoding UTF8 -Append
    

#Stops the script while Admin verivies CSV file.
Write-Host -BackgroundColor Black -ForegroundColor Green "List of Computers has been exported. Please open and verify the new CSV file to make sure only the computers you want to disable remain on it. ### Dont forget to Save and close the csv file before continuing. ###" 
PAUSE
Write-Host -BackgroundColor Black -ForegroundColor Green "Are you sure you removed any computer from the CSV you dont want disabled and saved and closed the file?"
PAUSE

Write-Host -BackgroundColor Black -ForegroundColor Green "Importing csv file now."
    Import-Csv $env:userprofile\desktop\ADPCs_$((Get-Date).ToString('MM-dd-yyyy')).csv | ForEach-Object {

Write-Host -BackgroundColor Black -ForegroundColor Green "Moving" $_.Name "to the disabled computers OU"
    Move-ADObject $_.'DistinguishedName' -TargetPath 'OU=Disabled_Workstations,DC=domain1,DC=com' -Server DC1

Write-Host -BackgroundColor Black -ForegroundColor Green "Disabling" $_."Name" "now."
    Set-ADComputer $_.Name -Enabled $false -Server DC1
