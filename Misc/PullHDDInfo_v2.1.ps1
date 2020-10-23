### Script to pull HDD space of servers and emails to admins ###
### Author: ChrisZ-IT ###
### Version: 2.1 ###

## Imports list of servers from txt file ##
$servers = Get-Content $env:userprofile\desktop\PowerShell\serverlist.txt

## Clears Objects from cache ##
$compinfo = @()

## Runs commands for each server in list ##
Foreach ($s in $servers)
{
## Pings to see if Server is up ##
If ((Test-Connection -Count 1 -Quiet -ComputerName $s) -eq "True"){
$computerHDD = Get-WmiObject Win32_LogicalDisk -Filter drivetype=3 -ComputerName $s 

## Builds object (pulls HDD info) list for servers that are up ##
ForEach($HDD in $computerHDD){
    $compinfo += New-Object PSObject -property @{ 
        PCName = $s 
        HDDDriveLetter = ($HDD.DeviceID)
        HDDSize = "{0:N2}" -f ($HDD.Size/1GB)
        HDDFree = "{0:N2}" -f ($HDD.FreeSpace /1GB) 
        HDDFreePercentage = "{0:P2}" -f ($HDD.FreeSpace/$HDD.Size)
        Is_Up = "True"
                                                 }
                              }
                                                                    }
## Builds Object list for servers that are down ##
Else{
    $compinfo += New-Object PSObject -property @{ 
        PCName = $s
        HDDDriveLetter = "N/A"
        HDDSize = "N/A"
        HDDFree = "N/A" 
        HDDFreePercentage = "N/A"
        Is_Up = "False"
                                                 }
    }
}
## Compiles both object lists and exports it to CSV file. ##
    $compinfo | select -Property PCName, Is_Up, HDDDriveLetter, HDDSize, HDDFree, HDDFreePercentage | Sort HDDFreePercentage | Export-Csv -path $env:userprofile\desktop\PowerShell\Server_Drive_Space_$((Get-Date).ToString('MM-dd-yyyy')).csv -NoTypeInformation -Append

## Emails CSV to admins ##
    $To = admins@domain1.com 
    $From = alerts@domain1.com
    $Subject = $((Get-Date).ToString('MM-dd-yyyy')+" Windows Hard Drive Usage report")
    $Body = $((Get-Date).ToString('MM-dd-yyyy')+" Windows Hard Drive Usage report")
    $SMTPServer = smtp.domain1.com

    Send-MailMessage -to $To -from $From -Subject $Subject -Body $Body -BodyAsHtml -Attachments $env:userprofile\desktop\PowerShell\Server_Drive_Space_$((Get-Date).ToString('MM-dd-yyyy')).csv -SmtpServer $SMTPServer

## Backs up csv file ##
    #Archives a copy of the csv to a network share.
    Copy-Item -Path $env:userprofile\desktop\PowerShell\Server_Drive_Space_$((Get-Date).ToString('MM-dd-yyyy')).csv -Destination "\\fileserver\share\Server HDD Space Info"
    #Archives a copy locally
    Move-Item -path $env:userprofile\desktop\PowerShell\Server_Drive_Space_$((Get-Date).ToString('MM-dd-yyyy')).csv -Destination $env:userprofile\desktop\PowerShell\PowerShell\YEAR\
