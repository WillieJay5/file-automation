# === CONFIGURATION ===
$folder = "$env:USERPROFILE\Downloads"
$filter = '*.*'
$organizerScript = "$env:USERPROFILE\.scripts\auto-organize-downloads.py"
$watcherName = "AutoDownloadsWatcher"

# === KILL OLD WATCHER (based on script name or process name) ===
# Looks for previously registered events and removes them
Get-EventSubscriber | Where-Object { $_.SourceIdentifier -eq $watcherName } | Unregister-Event -Force | Out-Null
Get-Job | Where-Object { $_.Name -eq $watcherName } | Remove-Job -Force | Out-Null

# === KILL OTHER INSTANCES (if script is running in another PowerShell window) ===
Get-Process powershell,pwsh -ErrorAction SilentlyContinue | Where-Object {
    $_.MainWindowTitle -match "watch_downloads.ps1" -or $_.Path -match "watch_downloads.ps1"
} | ForEach-Object {
    try { $_.Kill() } catch {}
}

# === SET UP WATCHER ===
$fsw = New-Object System.IO.FileSystemWatcher
$fsw.Path = $folder
$fsw.Filter = $filter
$fsw.IncludeSubdirectories = $false
$fsw.EnableRaisingEvents = $true

# === REGISTER EVENT ===
Register-ObjectEvent -InputObject $fsw -EventName "Created" -SourceIdentifier $watcherName -Action {
    Start-Process "pythonw.exe" -ArgumentList "`"$using:organizerScript`"" -WindowStyle Hidden
}

# === KEEP SCRIPT RUNNING ===
while ($true) { Start-Sleep -Seconds 5 }
