### Credit for this script goes to David Hall over at https://www.signalwarrant.com ###
### Schdule this script to run on a regular basis ###
### My contrabution is the '$Newlyadded' section ###

Import-Module ActiveDirectory

# Get the filehash of the CurrentDomainAdmins.xml
    $CurrentAdmins = $env:userprofile\desktop\PowerShell\CurrentDomainAdmins.xml
    $CurrentAdminsHash = Get-FileHash -Path $env:userprofile\desktop\PowerShell\CurrentDomainAdmins.xml | 
      Select-Object -expandProperty Hash
      
# Get the current date
    $Date = Get-Date
    
# This is the file we're testing the CurrentDomainAdmins.xml file against
    $newAdmins = '$env:userprofile\desktop\PowerShell\NewAdmins.xml
    
# A variable we will use in the if statement below
    $Change = ''
 
# As we run the test we're going to get the contents of the Domain Admins Group
Get-ADGroupMember -Identity 'Domain Admins' -Server DC1 |
    Select-Object -ExpandProperty samaccountname, SID | 
    Export-Clixml -Path $newAdmins -Force
 
# Get the filehash of the new file 
$NewAdminsHash = Get-FileHash -Path $newAdmins | Select-Object -expandProperty Hash
 
# If the CurrentDomainAdmins.xml (our baseline file) and NewAdmins.xml do not match
If ($NewAdminsHash -ne $CurrentAdminsHash){
    
    # Do all of this if a change is detected
    $Change = 'Yes'
    $ChangesDetected = 'Domain1 Domain Admins Group changed detected on: ' + $date
    $ChangesDetected | Out-File -FilePath $env:userprofile\desktop\DA_Changes.txt -Append -Force
} else {
 
    # If no change detected just write when the script last ran
    $Change = 'No'
    $NoChangesDetected = 'No Changes detected on: ' + $Date
    $NoChangesdetected | Out-File -FilePath $env:userprofile\desktop\DA_NoChanges.txt -Append -Force
}
#This will get a list of AD accounts that have been added or removed
$Newlyadded = Compare-Object $(Get-Content $CurrentAdmins) $(Get-Content $newAdmins) | % {$_ -replace '@{InputObject=  <S>', "domain\"} | % { $_ -replace'</S>; SideIndicator==>}', "
"}

# If the test above fails and the $change = "yes" then send me an email and text message
# and attach the NewAdmins.xml
If ($Change -eq 'Yes') {
    
    $From = 'alerts@domain1.com'
    $To = 'admins@domain1.com'
    #$Cc = ''
    $Attachment = $newAdmins
    $Subject = '----Domain1 Domain Admin Members has changed----'
    $Body = ("Script detected a change in the domain1 Domain Admin Group. The Following AD accounts were added or removed(if none listed then false alarm)
    " + $Newlyadded)
    $SMTPServer = 'smtp.domain1.com'
    
Send-MailMessage -From $From -to $To -Subject $Subject `
    -Body $Body -SmtpServer $SMTPServer `
    -Attachments $Attachment
}
