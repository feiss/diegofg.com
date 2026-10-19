$directory = "W:\sites\diegofg.com"
$debounceMs = 500

$watcher = [System.IO.FileSystemWatcher]::new($directory)
$watcher.IncludeSubdirectories = $true
$watcher.Filter = "*"
$watcher.NotifyFilter = (
    [System.IO.NotifyFilters]::FileName -bor
    [System.IO.NotifyFilters]::LastWrite -bor
    [System.IO.NotifyFilters]::DirectoryName
)

Write-Host "Watching $directory recursively..."
Write-Host "Press Ctrl+C to stop."

while ($true) {
    # Wait for the first change
    $change = $watcher.WaitForChanged(
        [System.IO.WatcherChangeTypes]::All
    )

    Write-Host "$(Get-Date -Format 'HH:mm:ss') - Change detected: $($change.Name)"

    # Keep waiting while changes continue arriving.
    # The build starts only after 500ms of silence.
    while ($true) {
        $next = $watcher.WaitForChanged(
            [System.IO.WatcherChangeTypes]::All,
            $debounceMs
        )

        if (-not $next.TimedOut) {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') - Another change: $($next.Name)"
            continue
        }

        break
    }

    Write-Host "$(Get-Date -Format 'HH:mm:ss') - Running build..."

    Push-Location $directory
    try {
        & python build.py

        if ($LASTEXITCODE -eq 0) {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') - Build succeeded."
        }
        else {
            Write-Host "$(Get-Date -Format 'HH:mm:ss') - Build failed (exit code $LASTEXITCODE)."
        }
    }
    finally {
        Pop-Location
    }
}
