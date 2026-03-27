oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\star.omp.json" | Invoke-Expression
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\sonicboom_dark.omp.json" | Invoke-Expression

Import-Module "Terminal-Icons"

# Alias

function CDAPPS {Set-Location -Path c:\_Projekte\Edna-apps-dev-skeleton\}
Set-Alias -Name apps -Value CDAPPS

function CDALIB {Set-Location -Path c:\_Projekte\Edna-apps-libraries\}
Set-Alias -Name alib -Value CDALIB

function CDLIB {Set-Location -Path c:\_Projekte\Edna-libraries\}
Set-Alias -Name lib -Value CDLIB

function CDWEB {Set-Location -Path c:\_Projekte\Edna-web\}
Set-Alias -Name web -Value CDWEB

# Git-Hub Functions
function GSWITCH {
    param (
        [string]$Filter,
        [bool]$repeat
    )

    $branches = git branch --list --remote | Where-Object { $_ -match $Filter -and $_ -notmatch "origin/HEAD"  }

    if ($branches.Count -eq 1) {
        $branch = $branches -replace "origin/", ""
        $branch = $branch.Trim()
        Write-Output "branch found: $branch"
        git switch $branch
    } elseif ($branches.Count -gt 1) {
        Write-Output "multiple branches found:"
        $branches | ForEach-Object { Write-Output $_ }
    } else {
        if ($repeat -ne 1) {
            $response = Read-Host "no branch found for '$Filter'. run 'git fetch'? (y)"
            if ($response -eq "y") {                
                Write-Output "start fetch..."
                git fetch
                GSWITCH $Filter 1
            } else {
                Write-Output "cancelled."
            }
        }
        else {
            Write-Output "still no branch found for '$Filter' after fetch -> cancelled."
        }
    }
}
Set-Alias -Name sw -Value GSWITCH

function GSTAT {git status}
Set-Alias -Name stat -Value GSTAT

function DHUBS {c:\_Projekte\datahub_runtime\Edna.Datahub_Siemens\deployment\run.bat}
Set-Alias -Name datahubS -Value DHUBS

function DHUBF {c:\_Projekte\datahub_runtime\Edna.Datahub_Fanuc\deployment\run.bat}
Set-Alias -Name datahubF -Value DHUBF

function CLOG {
    $repo = Get-Location | Split-Path -Leaf
    $log = git log --author="mhommel@emag.com" --since="1 week ago" --pretty=format:"%D %n - [%s](https://github.com/emag-com/$repo/commit/%H) (%ad)" --date=format:"%Y-%m-%d %H:%M"
    echo $log
    Set-Clipboard $log
    }
Set-Alias -Name cl -Value CLOG

function FETCHMERGE {
    $currentBranch = git branch --show-current
    git fetch
    sw develop
    git pull
    sw $currentBranch
    git merge develop
}
Set-Alias -Name fm -Value FETCHMERGE