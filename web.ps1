#Requires -RunAsAdministrator

[CmdletBinding()]
param()
$ScriptName = 'scriptrepo.osdcloud.com'
$ScriptVersion = '23.7.8.1'

# ScriptRepo
$FileName = 'ScriptRepo.zip'
$Url = 'https://github.com/OSDeploy/ScriptRepo/archive/refs/heads/main.zip'

# ScriptRepoGUI
$GUIFileName = 'ScriptRepoGUI.zip'
$GUIUrl = 'https://github.com/OSDeploy/ScriptRepoGUI/archive/refs/heads/main.zip'

#region ScriptRepo
    $OutFile = Join-Path $env:TEMP $FileName
    # Remove existing Zip file
    if (Test-Path $OutFile) {
        Remove-Item $OutFile -Force
    }

    # Download Zip file
    Invoke-WebRequest -Uri $Url -OutFile $OutFile

    if (Test-Path $OutFile) {
        Write-Host -ForegroundColor Green "[+] ScriptRepo downloaded to $OutFile"
    }
    else {
        Write-Host -ForegroundColor Red "[!] ScriptRepo could not be downloaded"
        Break
    }

    # Expand Zip file
    $CurrentFile = Get-Item -Path $OutFile
    $DestinationPath = Join-Path $CurrentFile.DirectoryName $CurrentFile.BaseName
    if (Test-Path $DestinationPath) {
        Remove-Item $DestinationPath -Force -Recurse
    }
    Expand-Archive -Path $OutFile -DestinationPath $DestinationPath -Force
    if (Test-Path $DestinationPath) {
        Write-Host -ForegroundColor Green "[+] ScriptRepo expanded to $DestinationPath"
    }
    else {
        Write-Host -ForegroundColor Red "[!] ScriptRepo could not be expanded to $DestinationPath"
        Break
    }

    # Set Scripts Path
    $ScriptRepository = Get-ChildItem -Path $DestinationPath -Directory | Select-Object -First 1 -ExpandProperty FullName
    if (Test-Path $ScriptRepository) {
        Write-Host -ForegroundColor Green "[+] ScriptRepo is set to $ScriptRepository"
    }
    else {
        Write-Host -ForegroundColor Red "[!] ScriptRepo could not be created at $ScriptRepository"
        Break
    }
#endregion

#region ScriptRepoGUI
    $GUIOutFile = Join-Path $env:TEMP $GUIFileName
    # Remove existing Zip file
    if (Test-Path $GUIOutFile) {
        Remove-Item $GUIOutFile -Force
    }

    # Download Zip file
    Invoke-WebRequest -Uri $GUIUrl -OutFile $GUIOutFile

    if (Test-Path $GUIOutFile) {
        Write-Host -ForegroundColor Green "[+] ScriptRepoGUI downloaded to $GUIOutFile"
    }
    else {
        Write-Host -ForegroundColor Red "[!] ScriptRepoGUI could not be downloaded"
        Break
    }

    # Expand Zip file
    $CurrentFile = Get-Item -Path $GUIOutFile
    $DestinationPath = Join-Path $CurrentFile.DirectoryName $CurrentFile.BaseName
    if (Test-Path $DestinationPath) {
        Remove-Item $DestinationPath -Force -Recurse
    }
    Expand-Archive -Path $GUIOutFile -DestinationPath $DestinationPath -Force
    if (Test-Path $DestinationPath) {
        Write-Host -ForegroundColor Green "[+] ScriptRepoGUI expanded to $DestinationPath"
    }
    else {
        Write-Host -ForegroundColor Red "[!] ScriptRepoGUI could not be expanded to $DestinationPath"
        Break
    }

    # PowerShell Module
    $ModulePath = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules\ScriptRepoGUI"
    if (Test-Path $ModulePath) {
        Remove-Item $ModulePath -Recurse -Force
    }

    # Copy Module
    $SourceModuleRoot = Get-ChildItem -Path $DestinationPath -Directory | Select-Object -First 1 -ExpandProperty FullName
    Copy-Item -Path $SourceModuleRoot -Destination $ModulePath -Recurse -Force -ErrorAction SilentlyContinue
    if (Test-Path $ModulePath) {
        Write-Host -ForegroundColor Green "[+] ScriptRepoGUI Module copied to $ModulePath"
    }
    else {
        Write-Host -ForegroundColor Red "[!] ScriptRepoGUI Module could not be copied to $ModulePath"
        Break
    }
    Import-Module ScriptRepoGUI -Force
    Write-Host -ForegroundColor Green "[+] Start-ScriptRepoGUI -Path $ScriptRepository"
#endregion

Write-Host -ForegroundColor Cyan "To start a new PowerShell session, type 'start powershell' and press enter"
Write-Host -ForegroundColor Cyan "Start-ScriptRepoGUI can be run in the new PowerShell window"

Start-ScriptRepoGUI -Path $ScriptRepository