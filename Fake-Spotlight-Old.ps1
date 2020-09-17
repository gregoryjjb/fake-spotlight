##
# I stopped trying to get this one working, 

# Directory where Windows stores Spotlight images
$source_dir = "C:\Users\Greg\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

# Directoy where we store images
$staging_dir = "$PSScriptRoot\.staging"

# Images smaller than this will not be considered
$min_image_width = 1920

# How many images to keep (sorts by newest)
$num_images = 3

# Copied from https://social.technet.microsoft.com/Forums/lync/en-US/c4d8409d-64ca-487d-b25c-7443ad370657/getting-dimensions-of-images-in-a-folder-using-power-shell?forum=ITCG
Function Get-Image {
	begin {        
		Add-Type -assembly System.Drawing
	} 
	process {
		$fi = [System.IO.FileInfo]$_           
		if ( $fi.Exists) {
			$img = [System.Drawing.Image]::FromFile($_)
			$img.Clone()
			$img.Dispose()       
		}
		else {
			Write-Host "File not found: $_" -fore yellow       
		}   
	}    
}

# Reset staging directory
if (Test-Path $staging_dir) { Remove-Item -LiteralPath $staging_dir -Force -Recurse }
New-Item -ItemType directory -Path $staging_dir

# Copy all files from Spotlight
Get-ChildItem $source_dir -File |
ForEach-Object {
	$basename = $_.BaseName
	$name = "$staging_dir\$basename.jpg"

	Write-Output "Copying $basename"
	Copy-Item -Force $_.FullName -Destination $name
	Set-ItemProperty -Path $name -Name LastWriteTime -Value $_.LastWriteTime
}

# Delete anything smaller than $min_image_width
Get-ChildItem $staging_dir -File |
ForEach-Object {
	$image = New-Object -ComObject Wia.ImageFile
	$image.loadfile($_.FullName)

	if ($image.Width -lt $min_image_width) {
		Remove-Item -Path $_.FullName -Force
	}
}

# Delete the oldest, keep $num_images
Get-ChildItem $staging_dir -File |
Sort-Object LastWriteTime -Descending |
Select-Object -Skip $num_images |
Remove-Item -Force

# Pick a random 
Get-ChildItem $staging_dir |
Get-Random -Count 1 |
ForEach-Object {
	& "$PSScriptRoot\Set-Screen.ps1" -LockScreenSource $_.FullName
}
