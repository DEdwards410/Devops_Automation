<#
Get-GithubLatestRelease.ps1

.SYNOPSIS

Gets the latest release from a github repository.

.DESCRIPTION

Checks the github repository, and downloads the latest release from repo in a zip format.

.PARAMETER RepoOwner

Repository Owner name.

.PARAMETER RepoName

name of the repository

.PARAMETER TagName

Optional: Tag for the latest release.
If this is not specified, the script will try to get the latest release and get the Tag Name.

.PARAMETER OutputFolder

Optional: Output folder where the release zip file will be stored.
If not specified, a folder with repository name will be created in the script directory and the release zip will be stored there.

.EXAMPLE

To execute the script, open a powershell window in the same folder where script is located

Execute the script by below syntax

.\Get-GithublatestRelease.ps1 -RepoOwner dotnet -RepoName codeformatter -OutputFolder C:\Temp
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]$RepoOwner,
    [Parameter(Mandatory)]
    [string]$RepoName,
    [Parameter(Mandatory = $false)]
    [string]$TagName,
    [Parameter(Mandatory = $false)]
    [System.IO.DirectoryInfo]$OutputFolder
)

$repo = "$RepoOwner/$RepoName"

$releases = "https://api.github.com/repos/$repo/releases"

if (!($TagName)) {
    try {
        Write-Host "Determining latest release tag.."
        $TagName = (Invoke-WebRequest $releases -ErrorAction Stop | ConvertFrom-Json)[0].tag_name
    }
    catch {
        Write-Error "Failed getting the latest release tag: $($_.Exception.Message)"
    }
}
$file = "$RepoName.zip"
$download = "https://github.com/$repo/releases/download/$TagName/$file"
$zip = "$RepoName-$TagName.zip"

#If the Outputfolder not specified or doesnot exist, try creating the folder
if (!($OutputFolder) -or !(Test-Path $OutputFolder)) {
    #If Outputfolder not specified, Outputfolder will be created inside current script directory
    try {
        $dir = New-Item -ItemType Directory -Path "$PSScriptRoot\$RepoName" -Force -ErrorAction Stop
        $OutFile = "$($dir.FullName)\$zip"
    }
    catch {
        Write-Error "Failed Creating the folder for repository: $($_.Exception.Message)"
    }
}
else {
    $OutFile = "$OutputFolder\$zip"
}


try {
    Write-Host "Dowloading latest release....."
    Invoke-WebRequest $download -OutFile $OutFile -ErrorAction Stop
}
catch {
    Write-Error "Failed downloading the latest release : $($_.Exception.Message)"
}

<#Write-Host Extracting release files
Expand-Archive $zip -Force

# Cleaning up target dir
Remove-Item $name -Recurse -Force -ErrorAction SilentlyContinue 

# Moving from temp dir to target dir
Move-Item $dir\$name -Destination $name -Force

# Removing temp files
Remove-Item $zip -Force
Remove-Item $dir -Recurse -Force#>