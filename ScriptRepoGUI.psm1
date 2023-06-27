$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

foreach ($import in @($Public + $Private)) {
    try {
        . $import.fullname -ErrorAction Stop
    }
    catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}