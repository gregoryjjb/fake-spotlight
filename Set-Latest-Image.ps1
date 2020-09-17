

$Url = "https://windows10spotlight.com"

$Driver = Start-SeFirefox

Write-Output "Starting driver"
Enter-SeUrl $Url -Driver $Driver

$h2 = Find-SeElement -XPath "//main[1]/article[1]/h2" -Driver $Driver
$LatestId = $h2.Text
Write-Output "Latest ID: $LatestId"

$ImagesDir = "$PSScriptRoot\Images"
$LocalImagePath = "$ImagesDir\$LatestId.jpg"

# Create images folder if not exists
if (!(Test-Path $ImagesDir)) {
    New-Item -ItemType directory -Path $ImagesDir
}

if (Test-Path $LocalImagePath) {
    Write-Output "File already exists locally, not downloading"
}
else {
    Write-Output "File not found locally, downloading"

    $img = Find-SeElement -XPath "//main[1]/article[1]/div/a/img" -Driver $Driver
    $src = $img.GetAttribute("src")
    $FullSizeUrl = $src -replace "\-\d+x\d+"
    Write-Output "Image URL: $FullSizeUrl"

    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($FullSizeUrl, $LocalImagePath)
}

if (Test-Path $LocalImagePath) {
    Write-Output "File found"
    Write-Output "Setting lock screen"
    & "$PSScriptRoot\Set-Screen.ps1" -LockScreenSource $LocalImagePath
}
else {
    Write-Error "Could not find an image\nPath was $LocalImagePath"
}


Write-Output "Stopping driver"
Stop-SeDriver $Driver
