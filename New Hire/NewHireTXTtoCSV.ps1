### Script to convert txt email to csv files to imported by gmail(bettercloud) and AD ###
### Author: ChrisZ-IT ###
### Version: 4.1 ###
### Created 10.03.2018; Updated: 05.15.2019 ###

Remove-Variable * -ErrorAction SilentlyContinue

#imports Text file and converts it to CSV
$userObj = [pscustomobject] ((Get-Content -Raw '$env:userprofile\Desktop\newhire.txt') -replace ':', '=' |
  ConvertFrom-StringData)
$userObj | Select-Object Username, Title, Department, Manager, 'Similar User', 'Office Location', 'Hire Status', 'Position Status' | ConvertTo-Csv -NoTypeInformation | % {$_ -replace '"', ""} | Out-File $env:userprofile\Desktop\NewHireConvert.csv -Force -Encoding ascii

#Imports New CSV File and Formats it for use in AD
Import-csv $env:userprofile\Desktop\NewHireConvert.csv| Select-Object -Property @{N='Name';E={$_.Username}},
@{N='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{l="Manager";E={$_.Manager –replace “ “,”.” }},
@{N='SimilarUser';E={$_.'Similar User'}},
@{l='HD Info';E={"
Windows Username: " + ($_.Username –replace “ “,”.”) + "
Windows Password: Enter_Password_Here" + "
Gmail Username: " + ($_.Username –replace “ “,”.” ) + "@domain_Name.com" + "
Gmail Password: Enter_Password_Here"}},
@{l='Email';E={($_.Username –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Blank';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l="Username";E={$_.Username –replace “ “,”.” }},
@{l="Similar User Username";E={$_.'Similar User' –replace “ “,”.” }},
@{l='Similar User FirstName';E={$_.'Similar User'.Split(' ')[0]}},
@{l='SimilarUser LastName';E={$_.'Similar User'.Split(' ')[1]}},
@{l="OU";E={"OU=Users,DC=domain1,DC=com"}},
@{N="Office";E={$_.'Office Location'}},
@{N="Hire Status";E={$_."Hire Status"}},
@{N="Position Status";E={$_."Position Status"}}|
Export-Csv $env:userprofile\Desktop\NewUsers.csv -append

#Exports CSV Formatted for Bettercould for Austin Contrators or Temp users
Import-csv $env:userprofile\Desktop\NewHireConvert.csv | ForEach-Object {
if (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Austin"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"austin@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Austin"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"123 fake st Austin, TX 99999"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Austin Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Austin"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|austinhq@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Austin"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"123 fake st Austin, TX 99999"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Charlotte Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Fort Mill"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"charlotte@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Charlotte"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"123 Faker st, Charlotte, SC 88888"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Charlotte Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Fort Mill"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|charlotte@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Charlotte"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"123 Faker st, Charlotte, SC 88888"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Atlanta Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Atlanta"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"Atlanta@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Atlanta"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"1234 Cat RD, STE 100, Atlanta, GA 33333"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Atlanta Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Atlanta"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|Atlanta@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Atlanta"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"1234 Cat RD, STE 100, Atlanta, GA 33333"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Denver Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Denver"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"Denver@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Denver"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"5549er E Avs ave, Denver, CO 81009"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Denver Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Denver"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|Denver@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Denver"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"5549er E Avs ave, Denver, CO 81009"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for San Diego Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "San Diego"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"San_Diego@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"San Diego"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"Platform 9 & 3 quarters, San Diego, CA 92123"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for San Diego Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "San Diego"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|San_Diego@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"San Diego"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"Platform 9 & 3 quarters, San Diego, CA 92123"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Seattle Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Seattle"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"seattle@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Seattle"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"LV-426, STE 501, Seattle, WA 98104"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Seattle Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Seattle"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|seattle@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Seattle"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={"LV-426, STE 501, Seattle, WA 98104"}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Remote Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Remote"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"vpn_users@domain_name.com"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Remote"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={$_.'Office Location'}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Remote Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Remote"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|vpn_users@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Remote"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={$_.'Office Location'}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Other Contrators or Temp users
elseif (($_."Position Status" -eq "Contractor") -or ($_."Position Status" -eq "Temporary") -and ($_.'Office Location' -eq "Other"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={""}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Other Users"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={$_.'Office Location'}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}

#Exports CSV Formatted for Bettercould for Other Permanent users
elseif (($_."Position Status" -eq "Permanent") -and ($_.'Office Location' -eq "Other"))
{Import-Csv $env:userprofile\Desktop\NewHireConvert.csv|Select-Object -Property @{N='Type';E={"NEW"}},
@{N='ID';E={($_.Username.ToLower() –replace “ “,”.” ) + "@domain_Name.com"}},
@{l='Change Email';E={""}},
@{l='First Name';E={$_.Username.Split(' ')[0]}},
@{l='Last Name';E={$_.Username.Split(' ')[1]}},
@{l='Password';E={"Enter_Password_Here"}},
@{l='Hashed Password';E={""}},
@{N='Requires password change';E={"YES"}},
@{l='Suspend/Restore';E={""}},
@{l='HIDE/SHOW';E={"SHOW"}},
@{l='Blank1';E={""}},
@{l='Add to Group';E={"north_america@domain_Name.com|"}},
@{l='Remove From Group';E={""}},
@{l='Blank2';E={""}},
@{l='OrgUnit';E={"Other Users"}},
@{l='Blank3';E={""}},
@{l='Photo URL';E={""}},
@{l='AKA';E={""}},
@{l='Title';E={$_.Title}},
@{N='Department';E={$_.Department}},
@{N='Manager';E={($_.Manager –replace “ “,”.” ) + "@domain_Name.com"}},
@{N='Company';E={"Compay_Name"}},
@{l='Work Phone';E={""}},
@{l='Main Phone';E={""}},
@{l='Work Fax';E={""}},
@{l='Cell Phone';E={""}},
@{l='Home Phone';E={""}},
@{N="Office";E={$_.'Office Location'}}|
Export-Csv $env:userprofile\Desktop\BettercloudNewUsers.csv -append
}
else {
Write-Host "No Position status found. Make sure there are no commas "," in any of the fields"
}
}

#Exports HD info to Paste into the NewHire Ticket
Import-Csv $env:userprofile\Desktop\NewUsers.csv|
Select-Object "HD Info" | % {$_ -replace '"', ""} | % { $_ -replace'@{HD Info=', ""}|% {$_ -replace "}", ''}| Out-File $env:userprofile\Desktop\NewHireHelpDeskinfo.txt

#Clears defined varibals getting script ready to be run again
    Remove-Variable * -ErrorAction SilentlyContinue
