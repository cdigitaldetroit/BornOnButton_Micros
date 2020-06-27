# Author: Chris Snitchler
# Email: chris@n30.us
# Purpose: Calculates drinking age and displays it on a micros 3700 key

$drinkAge =				#Set Drinking age here
$screenSeq1 = 			#Set Micros Screen Sequence here (micros.ts_key_def.ts_scrn_seq)
$keySeq1 = 				#Set Micros Key Sequence here (micros.ts_key_def.ts_key_seq)
$screenSeq2 =
$keySeq2 =

$datasource = ''		#Set sql datasource here
$user = ''			#Set database username here
$pass = ''			#Set database password here


# ----!!!DO NOT EDIT BELOW THIS LINE!!!----

# Gets the current date and calculates the needed birth year
$currentMonth = (Get-Date).Month
$currentDay = (Get-Date).Day
$bornYear = (Get-Date).Year - $drinkAge
# Builds the needed strings
$bornDate = "$currentMonth/$currentDay/$bornYear"
$credentials = '"uid=' +$user +';pwd=' +$pass +'"'
# Builds the sql statment
$sql1 = "update micros.ts_key_def set legend='"+$bornDate+"' where ts_scrn_seq='"+$screenSeq1+"' and ts_key_seq='"+$keySeq1+"'; commit"
$sql2 = "update micros.ts_key_def set legend='"+$bornDate+"' where ts_scrn_seq='"+$screenSeq2+"' and ts_key_seq='"+$keySeq2+"'; commit"

dbisql -datasource $datasource -c $credentials $sql1
dbisql -datasource $datasource -c $credentials $sql2
