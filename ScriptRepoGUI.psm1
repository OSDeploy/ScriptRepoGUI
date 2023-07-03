function Start-ScriptRepoGUI {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateScript({Test-Path -Path $_ -PathType Container})]
        [string]$Path = "$env:Temp\ScriptRepo\ScriptRepo-main"
    )
    #================================================
    #   Set Global Variables
    #================================================
    $Global:OSDPadBranding = @{
        Title = 'ScriptRepoGUI'
        Color = '#01786A'
    }
    #=================================================
    #   Parameters
    #=================================================
    $ScriptFiles = Get-ChildItem -Path $Path -Recurse -File
    $ScriptFiles = $ScriptFiles | Where-Object {$_.Name -notlike '.git*'}
    #$ScriptFiles = $ScriptFiles | Where-Object {($_.Name -match '.ps1') -or ($_.Name -match '.md') -or ($_.Name -match '.json')}
    #=================================================
    #   Create Object
    #=================================================
    $Global:ScriptRepoGUI = foreach ($Item in $ScriptFiles) {
        $FullName = $Item.FullName
        $DirectoryName = $Item.DirectoryName
        $RelativePath = $Item.FullName -replace [regex]::Escape("$Path\"), ''

        if ($DirectoryName -eq $Path) {
            $Category = ''
            $Script = $RelativePath
        }
        else {
            $Category = $Item.DirectoryName -replace [regex]::Escape("$Path\"), ''
            $Script = $RelativePath
        }

        # Category is the first part of the path
        # $Category = $RelativePath.Split('\')[0]
        # $Category = $RelativePath.Split('\')[0..1] -join '\'

        $ObjectProperties = [ordered]@{
            Category = $Category
            Script = $Script
            Content = Get-Content -Path $Item.FullName -Raw -Encoding utf8
            DirectoryName = $DirectoryName
            RelativePath = $RelativePath
            Name = $Item.Name
            FullName = $FullName
            LocalRepository = $Path
        }
        New-Object -TypeName PSObject -Property $ObjectProperties
    }
    #=================================================
    #   ScriptRepoGUI.ps1
    #=================================================
    & "$($MyInvocation.MyCommand.Module.ModuleBase)\Project\MainWindow.ps1"
    #=================================================
}
Export-ModuleMember -Function Start-ScriptRepoGUI