# Get current user SID
$userSID = ([Security.Principal.WindowsIdentity]::GetCurrent()).User.Value

# Location of current lockscreen from Spotlight
$currentLockscreenRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\$userSID"

# Get all Spotlight images
$spotlightImages = Get-ChildItem -Path $currentLockscreenRegPath -Recurse:$false | Select-Object Name

# Get the latest image (They are datestamped, so the last registry Key is the latest image)
$latestImage = (Get-ItemProperty -Path $spotlightImages[$spotlightImages.Count-1].Name.Replace("HKEY_LOCAL_MACHINE","HKLM:") | Select-Object landscapeImage).landscapeImage

# Check if wallpaper quality is set to 100, if not correct it
if(-not (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -ErrorAction SilentlyContinue))
{
  New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100
}
elseif ((Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality).JPEGImportQuality -ne 100)
{
  Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -Value 100
}

# Check if the current wallpaper is identical to the current Spotlight image
if((Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallPaper).WallPaper -eq $latestImage)
{
  # We already have the current Spotlight image set as a wallpaper. Terminate the script with success code 0
  return 0
}

# Set the value of the desktop wallpaper to the value of the current Spotlight image
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallPaper -Value $latestImage

# Trigger a refresh of the desktop wallpaper. It won't trigger every time, so we need to loop it a few times to ensure the switch takes place
for($i = 0; $i -lt 60; $i++)
{
  & RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
  Start-Sleep -Seconds 1
}