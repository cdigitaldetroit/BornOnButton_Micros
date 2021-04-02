# Author: Chris Snitchler
# Email: chris@n30.us
# Purpose: Calculates drinking age and displays it on a micros RES 3700 key

if (Test-Path -Path C:\micros) {
	$scriptsPath = "C:\micros\res\pos\scripts"
}elseif (Test-Path -Path D:\micros) {
	$scriptsPath = "D:\micros\res\pos\scripts"
}else {
	$scriptsPath = Read-Host "Please Enter MICROS Scripts Path"
}

if (Test-Path  -Path $scriptsPath\BornOn) {
}else {
	New-Item -Path $scriptsPath -Name "BornOn" -ItemType "directory"
}

$boPath = "$scriptsPath\BornOn"
$varPath = "$boPath\var.ps1"

$dbDataSource = Read-Host "Enter Database Name"
$dbUser = Read-Host "Enter Database Username"
Read-Host "Enter Database Password" -AsSecureString |  ConvertFrom-SecureString | Out-File $boPath\b1.ini
$drinkAge = Read-Host "Enter Legal Drinking Age" 
$sFile = "$boPath\b1.ini"
$sString = ConvertTo-SecureString -String (Get-Content $sFile)
$bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sString)
$dbPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
$dbCreds = '"uid=' +$dbUser +';pwd=' +$dbPass +'"'

$sql = "select ts_scrn_seq, ts_key_seq from micros.ts_key_def where legend = 'boTemp'; output to '$boPath\born.csv'"
dbisql -datasource $dbDataSource -c $dbCreds $sql


Add-Content -Path $varPath -Value "`$dbDataSource = '$dbDataSource'"
Add-Content -Path $varPath -Value "`$dbUser = '$dbUser'"
Add-Content -Path $varPath -Value "`$drinkAge = $drinkAge"
Add-Content -Path $varPath -Value "`$boPath = '$boPath'"

Copy-Item ".\files\born.ps1" -Destination "$boPath"
Copy-Item ".\files\BornOn.bat" -Destination "$boPath"

Read-Host "Please Enter Windows Password" -AsSecureString |  ConvertFrom-SecureString | Out-File $boPath\b2.ini
$sFile1 = "$boPath\b2.ini"
$sString1 = ConvertTo-SecureString -String (Get-Content $sFile1)
$bstr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sString1)
$winPwd = [Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr1)

[xml]$taskXML = Get-Content .\BornOn.xml


$taskXML.Task.Actions.Exec.WorkingDirectory = "$boTemp"
$taskXML.Save(".\BornOn.xml")

schtasks /create /tn "Born On" /xml ".\BornOn.xml" /ru $env:COMPUTERNAME\$env:UserName /rp $winPwd