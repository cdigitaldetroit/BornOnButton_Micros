# Author: Chris Snitchler
# Email: chris@n30.us
# Purpose: Calculates drinking age and displays it on a micros RES 3700 key

#Setup File Path and Import Variables
$scriptsPath = "D:\micros\res\pos\scripts"
.$scriptsPath\BornOn\var.ps1

#Import the Micros Screen and Key Sequence Numbers from the CSV file
$header = "sSync","kSync"
$importCSV = @(Import-Csv $scriptsPath\BornOn\born.csv -Header $header)
$sFile = "$boPath\b1.ini"

#Unencrypt the Database Password
$sString = ConvertTo-SecureString -String (Get-Content $sFile)
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sString)
$dbPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

# Gets the current date and calculates the needed birth year
$currentMonth = (Get-Date).Month
$currentDay = (Get-Date).Day
$bornYear = (Get-Date).Year - $drinkAge
# Builds the needed strings
$bornDate = "$currentMonth/$currentDay/$bornYear"
$dbCreds = '"uid=' +$dbUser +';pwd=' +$dbPass +'"'


$importCSV | ForEach-Object {
   $screenSeq = $_.sSync
   $keySeq = $_.kSync
   
   $sql = "update micros.ts_key_def set legend='"+$bornDate+"' where ts_scrn_seq='"+$screenSeq+"' and ts_key_seq='"+$keySeq+"'; commit"
   dbisql -datasource $dbDataSource -c $dbCreds $sql
} 
