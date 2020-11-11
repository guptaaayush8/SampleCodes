$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -WorkingDirectory "D:\Personal\Desktop_Wallpaper\SpotlightWallpaper.ps1"

$trigger =  New-ScheduledTaskTrigger -RandomDelay (New-TimeSpan -Minutes 30) -AtLogOn 

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Change Desktop Wallpaper" -Description "Changes Desktop Wallpaper to latest Spotlight Wallpaper"