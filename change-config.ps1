#### change-config.ps1 
#### Script will check 'signature.strength' and change "LENIENT" to "AIR_GAPPED" 
#### ...in the user's config file if neccessary
####
#### Script should be executed at login as a user script.
#### ~ mdavenport ~ Delta Township ~ 4/21/25

$filePath = "C:\Users\$env:USERNAME\.example\app-data\config.json"
$jsonFile = (Get-Content $filePath).Split("`n")

#echo DEBUG $filePath

## Copy the JSON to memory and convert to PowerShell object, then make the necessary change as needed...
## NOTE THIS DID NOT WORK WITH MY SOFTWARE but might work with other JSON files in the future
#$launcherJson = Get-Content -Path $filePath | ConvertFrom-Json
#if ($launcherJson.global.'signature.strength' -eq "LENIENT") {
#    $launcherJson.global.'signature.strength'="AIR_GAPPED"
#    $launcherJson | ConvertTo-Json | Out-File $filePath
#    #echo REPLACED
#    }
#else { echo "NOT FOUND" }


## Alternative WORKING text replacement version is below:
$lineNumber=(Select-String -Path $filePath -Pattern 'signature.strength' -CaseSensitive -SimpleMatch).LineNumber #Get line number of strength value

#if strength value is LENIENT, then change to AIR_GAPPED and write back to disk
if (($jsonFile[$lineNumber-1] | Select-String -Pattern 'LENIENT' -CaseSensitive -SimpleMatch)) { 
    #echo DEBUG MATCHED 
    $jsonFile[$lineNumber-1] = ($jsonFile[$lineNumber-1]).replace('LENIENT', 'AIR_GAPPED')
    $jsonFile | Set-Content $filePath
    }
