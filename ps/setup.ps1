Write-Host "Installing winget packages"
winget install Microsoft.WindowsTerminal
winget install Microsoft.PowerShell
winget install Neovim.Neovim
winget install Git.Git
winget install OpenJS.NodeJS
winget install JanDeDobbeleer.OhMyPosh

Install-Module Terminal-Icons -Repository PSGallery -Force
Install-Module z
Install-Module PSReadLine -AllowPrerelease -Force - SkipPublisherCheck

choco install nvm

Write-Host "Installing Fonts"
$fontFolderPath = "../JetBrainsMono"
$fontFiles = Get-ChildItem -Path $fontFolderPath -Filter "*.ttf"
$fontRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
foreach ($fontFile in $fontFiles) {
    $fontName = [System.IO.Path]::GetFileNameWithoutExtension($fontFile.Name)
    $fontFullName = "$fontName ($($fontFile.Name))"
    $fontRegistryKey = "$fontRegistryPath\$fontFullName"
    if (-not (Test-Path $fontRegistryKey)) {
        Copy-Item -Path $fontFile.FullName -Destination "C:\Windows\Fonts" -Force
        New-ItemProperty -Path $fontRegistryPath -Name $fontFullName -PropertyType String -Value $fontFile.Name -Force
        Write-Host "Installed font: $fontFullName"
    } else {
        Write-Host "Font already installed: $fontFullName"
    }
}


$newSettingsFilePath = "./settings.json"
$localSettingsFilePath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item -Path $newSettingsFilePath -Destination $localSettingsFilePath -Force
Write-Host "New terminal settings.json file applied."

$newVimInitPath = "../nvim/init.vim"
$localVimInitPath = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim"
if (-not (Test-Path -Path $localVimInitPath)) { mkdir $localVimInitPath }
Copy-Item -Path $newSettingsFilePath -Destination $localSettingsFilePath -Force
Write-Host "Vim config applied."

Write-Host "Installing vim-plug"
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

Write-Host "Configuring OhMyPosh"
$newPsConfPath = "./Microsoft.PowerShell_profile.ps1"
$newPoshConfPath = "./myprofile.omp.json"
$localPsConfPath = "$env:USERPROFILE\Documents\PowerShell"
if (-not (Test-Path -Path $localPsConfPath)) { mkdir $localPsConfPath }
Copy-Item -Path $newPsConfPath -Destination $localPsConfPath -Force
Copy-Item -Path $newPoshConfPath -Destination $localPsConfPath -Force
