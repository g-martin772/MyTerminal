Import-Module Terminal-Icons
Import-Module z
Import-Module PSReadLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -Function Complete

Set-Alias tt tree
Set-Alias ll ls
Set-Alias vim nvmim
Set-Alias vi nvmim
Set-Alias k kubectl

$localPsConfPath = "$env:USERPROFILE\Documents\PowerShell"
oh-my-posh init pwsh --config "$localPsConfPath\myprofile.omp.json" | Invoke-Expression