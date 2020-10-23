### Script to convert a txt file to csv files to that can be imported by AD ###
### Author: Chris-Z-IT ###
### Version: 1.0 ###
### Created 10.26.2016 ###


$userObj = [pscustomobject] ((Get-Content -Raw $env:userprofile\Desktop\newhire.txt) -replace ':', '=' |
ConvertFrom-StringData)
$userObj | Select-Object Username, Title, Department, Manager, 'Similar User' | ConvertTo-Csv -NoTypeInformation | % {$_ -replace '"', ""} | Out-File $env:userprofile\Desktop\NewHireConvert.csv -Force -Encoding ascii -Append
