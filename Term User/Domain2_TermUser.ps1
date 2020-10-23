### Script to term a user on the domain2 domain in a multi domain environment Using MS's AD cmdlts###
### Author: ChrisZ-IT ###
### Version: 2.8 ###
### Created 05.09.2019; Updated: 05.31.2019 ###

Import-Module ActiveDirectory

#Removes any defined variables from other scripts before script runs.
Remove-Variable * -ErrorAction SilentlyContinue

#GUI for entering termed user's Name
[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
[string]$TermUser = [Microsoft.VisualBasic.Interaction]::InputBox("Enter User to Term:", "Term User", "Username")

$TargetOU = "ou=Disabled,ou=Users,dc=domain2,dc=com"
$Date = Get-Date -Format MM/dd/yyyy
$DN = Get-ADUser -Filter "Name -eq '$($TermUser)'" -Properties * -Server dc1.domain2.com
$DN2 = Get-ADUser -Filter "Name -eq '$($TermUser)'" -Properties * -Server dc1.domain1.com
$CN = $DN.HomeDirectory.lastindexof('\')
$HomeDirectory = $DN.HomeDirectory.substring(0,$CN)

#Checks if User has an account on both domain1 and domain2.

#if user only has an account on domain1 it lets the admin know
if($DN2 -ne $null -and $DN -eq $null)
{
cls
sleep 1
Write-Host -BackgroundColor Black -ForegroundColor Yellow $DN2.Name "is an domain1 user"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Domain1 username:"$DN2.Samaccountname
}

#if user does not exist on domain1 script continues
Elseif ($DN -ne $null -and $DN2 -eq $null)
{

cls
sleep 1

Write-Host -BackgroundColor Black -ForegroundColor Green "Terming" $DN.Name

#Removing User from all groups on Domain2 Domain
Write-Host -BackgroundColor Black -ForegroundColor Green  "Removing" $DN.Name "from domain2 Groups"
        $domain2Groups = Get-ADPrincipalGroupMembership $DN -Server dc1.domain2.com | Where name -ne 'domain users' 

    ForEach ($g in $domain2Groups){
        Remove-ADPrincipalGroupMembership -Identity $DN.SID -MemberOf $g.SID -Server dc1.domain2.com -Confirm:$false > $null
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Removing from" $g.GroupType $g.ClassName -NoNewline ; write-host -BackgroundColor white -ForegroundColor blue $g.Name ""
        

    }

#Removing User from all groups on domain1 Domain
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Removing" $DN.Name "from domain1 Groups"
    Sleep 2
        $domain1Groups = Get-ADPrincipalGroupMembership -Identity $DN.SID -Server dc1.domain2.com -ResourceContextServer dc1.domain1.com

    Foreach ($g in $domain1Groups){
        Remove-ADGroupMember -Members $DN -Identity $g.SamAccountName -Server dc1.domain1.com -Confirm:$false > $null
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Removing from" $g.GroupType $g.ClassName -NoNewline ; write-host -BackgroundColor white -ForegroundColor blue $g.Name ""
        
    }

Write-Host -BackgroundColor Black -ForegroundColor Green "Setting Term Date"
    Set-ADUser -Identity $DN.SamAccountName -Description "Termed $Date" -Server dc1.domain2.com
    Sleep 1
Write-Host -BackgroundColor Black -ForegroundColor Green  "Disableing Account"
    Disable-ADAccount -Identity $DN -Server dc1.domain2.com
    Sleep 1
Write-Host -BackgroundColor Black -ForegroundColor Green  "Moving to Termed OU"
    Get-ADUser $DN | Move-ADObject -TargetPath $TargetOU
    Sleep 1

#Moves Users H:\ Drive to "Former Employee" folder 
Write-Host -BackgroundColor Black -ForegroundColor Green  "Backing up Home Directory"

if ($HomeDirectory -eq "\\DFSShare\users\aus")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Austin. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\aus\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\atl")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Atlanta. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\atl\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\Char")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Charlotte. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\Charlotte\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\den")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Denver. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\den\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\SanD")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in San Diego. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\SanD\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\sea")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Seattle. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\sea\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\Remote")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Remote. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\Remote\Former Employees"
}

else
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "User does not have an H:\ drive"
}
Write-Host -BackgroundColor Black -ForegroundColor Green  "Logging Termed status to csv file"
Get-ADUser -Filter "Name -eq '$($TermUser)'" -Server dc1.domain2.com -Properties *| select-object -property @{N='Date Termed';E={$Date}}, @{N='Name';E={$_.Name}}, @{N='Username';E={$_.Samaccountname}}, @{N='Account is Enabled';E={$_.Enabled}},@{N='Domain';E={'Domain2'}}| Export-Csv -path '\\Fileserver\Share\AD Logs\TermUser.csv' -NoTypeInformation -Append
Write-Host -BackgroundColor Black -ForegroundColor Green $DN.Name "has been termed."
}

#If user has an AD account on both domain1 & domain2 it proceeds here
Elseif ($DN2 -ne $null -and $DN -ne $null)
{

cls
sleep 1
Write-Host -BackgroundColor Yellow -ForegroundColor Black $DN2.Name "also has an domain1 account"
Write-Host -BackgroundColor Yellow -ForegroundColor Black "domain1 username:"$DN2.Samaccountname

Write-Host -BackgroundColor Black -ForegroundColor Green "Terming" $DN.Name

#Removing User from all groups on Domain2 Domain
Write-Host -BackgroundColor Black -ForegroundColor Green  "Removing" $DN.Name "from Domain2 Groups"
        $domain2Groups = Get-ADPrincipalGroupMembership $DN -Server dc1.domain2.com | Where name -ne 'domain users' 

    ForEach ($g in $domain2Groups){
        Remove-ADPrincipalGroupMembership -Identity $DN -MemberOf $g.SID -Server dc1.domain2.com -Confirm:$false > $null
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Removing from" $g.GroupType $g.ClassName -NoNewline ; write-host -BackgroundColor white -ForegroundColor blue $g.Name ""
        

    }

#Removing User from all groups on domain1 Domain
    Write-Host -BackgroundColor Black -ForegroundColor Green  "Removing" $DN.Name "from domain1 Groups"
    Sleep 2
        $domain1Groups = Get-ADPrincipalGroupMembership $DN -Server dc1.domain2.com -ResourceContextServer dc1.domain1.com

    Foreach ($g in $domain1Groups){
        Remove-ADPrincipalGroupMembership -Identity $DN -MemberOf $g.SID -Server dc1.domain1.com -Confirm:$false > $null
        Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "Removing from" $g.GroupType $g.ClassName -NoNewline ; write-host -BackgroundColor white -ForegroundColor blue $g.Name ""
        
    }

Write-Host -BackgroundColor Black -ForegroundColor Green "Setting Term Date"
    Set-ADUser -Identity $DN.SamAccountName -Description "Termed $Date" -Server dc1.domain2.com
    Sleep 1
Write-Host -BackgroundColor Black -ForegroundColor Green  "Disableing Account"
    Disable-ADAccount -Identity $DN -Server dc1.domain2.com
    Sleep 1
Write-Host -BackgroundColor Black -ForegroundColor Green  "Moving to Termed OU"
    Get-ADUser $DN | Move-ADObject -TargetPath $TargetOU
    Sleep 1

#Moves Users H:\ Drive to "Former Employee" folder 
Write-Host -BackgroundColor Black -ForegroundColor Green  "Backing up Home Directory"

if ($HomeDirectory -eq "\\DFSShare\users\aus")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Austin. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\aus\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\atl")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Atlanta. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\atl\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\Char")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Charlotte. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\Charlotte\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\den")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Denver. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\den\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\SanD")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in San Diego. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\SanD\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\sea")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Seattle. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\sea\Former Employees"
}

Elseif ($HomeDirectory -eq "\\DFSShare\users\Remote")
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "H:\ drive is in Remote. Backing it up now." 
Move-Item -Path $DN.HomeDirectory -Destination "\\DFSShare\users\Remote\Former Employees"
}

Else
{
Write-Host "     " -NoNewline; Write-Host -BackgroundColor White -ForegroundColor Black  "User does not have an H:\ drive"
}
Write-Host -BackgroundColor Black -ForegroundColor Green  "Logging Termed status to csv file"
Get-ADUser -Filter "Name -eq '$($TermUser)'" -Server dc1.domain2.com -Properties *| select-object -property @{N='Date Termed';E={$Date}}, @{N='Name';E={$_.Name}}, @{N='Username';E={$_.Samaccountname}}, @{N='Account is Enabled';E={$_.Enabled}},@{N='Domain';E={'Domain2'}}| Export-Csv -path '\\Fileserver\Share\AD Logs\TermUser.csv' -NoTypeInformation -Append
Write-Host -BackgroundColor Black -ForegroundColor Green $DN.Name "has been termed."
}

#Runs this part if User is not found in either domain
Else
{
cls
sleep 1
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Cant Find User in AD. Check the spelling"
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Running sanity checks just to make sure." 
Write-Host -BackgroundColor Black -ForegroundColor Yellow "Domain2 sanity check: (Blank means name was really not found)"$DN2.Name ":" $DN2.Samaccountname
Write-Host -BackgroundColor Black -ForegroundColor Yellow "domain1 sanity check: (Blank means name was really not found)"$DN.Name ":" $DN.Samaccountname
}
PAUSE

#Removes all defined variables
Remove-Variable * -ErrorAction SilentlyContinue
