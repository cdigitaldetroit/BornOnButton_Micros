# Author: Chris Snitchler
# Email: chris.snitchler@bowlluckystike.com
# Purpose: Calculates drinking age and displays it on a micros 3700 key

$drinkAge = 21				#Set Drinking age here
$screenSeq = 6				#Set Micros Screen Sequence here
$keySeq = 159				#Set Micros Key Sequence here

$datasource = 'Micros'		#Set sql datasource here
$user = 'msd'				#Set database username here
$pass = 'august27'			#Set database password here


# ----!!!DO NOT EDIT BELOW THIS LINE!!!----

# Gets the current date and calculates the needed birth year
$currentMonth = (Get-Date).Month
$currentDay = (Get-Date).Day
$bornYear = (Get-Date).Year - $drinkAge
# Builds the needed strings
$bornDate = "$currentMonth/$currentDay/$bornYear"
$credentials = '"uid=' +$user +';pwd=' +$pass +'"'
# Builds the sql statment
$sql = "update micros.ts_key_def set legend='"+$bornDate+"' where ts_scrn_seq='"+$screenSeq+"' and ts_key_seq='"+$keySeq+"'; commit"

dbisql -datasource $datasource -c $credentials $sql
