# Get the currently logged-in user
$LoggedInUsers = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
$LoggedInUsers = $LoggedInUsers -replace '.*\\'  # Remove domain name (if any)

if (-not $LoggedInUsers) {
    Write-Host "❌ Unable to retrieve logged-in users. Exiting..." -ForegroundColor Red
    exit
}

# Display logged-in user
Write-Host "`n🔹 Currently logged-in user: $LoggedInUsers"

# Prompt user for confirmation
$SelectedUser = Read-Host "`nEnter your username to confirm (must match above)"

# Validate username
if ($LoggedInUsers -ne $SelectedUser) {
    Write-Host "❌ Invalid username. Exiting..." -ForegroundColor Red
    exit
}

Write-Host "`n✅ Access granted! Running script as $SelectedUser"

# Function to open a fast folder selection dialog
function Select-Folder {
    Add-Type -AssemblyName System.Windows.Forms
    $Dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $Dialog.Description = "Select a folder"
    $Dialog.RootFolder = [System.Environment+SpecialFolder]::Desktop
    $Dialog.ShowNewFolderButton = $false
    if ($Dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $Dialog.SelectedPath
    } else {
        return $null
    }
}

# Select source and destination directories
Write-Host "`n📂 Choose the folder where your files are located..."
$SourceDir = Select-Folder
if (-not $SourceDir) { Write-Host "⚠️ No folder selected. Exiting..." -ForegroundColor Yellow; exit }
Write-Host "🔍 Selected Source Folder: $SourceDir"

Write-Host "`n📂 Choose where to organize your files..."
$DestinationDir = Select-Folder
if (-not $DestinationDir) { Write-Host "⚠️ No destination selected. Exiting..." -ForegroundColor Yellow; exit }
Write-Host "🔍 Selected Destination Folder: $DestinationDir"

# Validate Source and Destination Paths
if ($SourceDir -eq $DestinationDir) {
    Write-Host "❌ Source and destination cannot be the same" -ForegroundColor Red
    exit
}

# Fetch files, including subfolders and hidden files
try {
    $Files = Get-ChildItem -Path $SourceDir -File -Recurse -Force -ErrorAction Stop
    $TotalFiles = $Files.Count
    Write-Host "📂 Found $TotalFiles files for organization."
    
    # Display files
    if ($TotalFiles -gt 0) {
        Write-Host "📜 List of files found:" -ForegroundColor Cyan
        $Files | ForEach-Object { Write-Host "  - $($_.FullName)" }
    }
} catch {
    Write-Host "❌ Error accessing source folder: $_" -ForegroundColor Red
    exit
}

# Check if files exist
if ($TotalFiles -eq 0) {
    Write-Host "⚠️ No files found in the source directory or its subdirectories." -ForegroundColor Yellow
    exit
}

Write-Host "`n🔄 Organizing files...`n"

# Process files efficiently
$Counter = 0
foreach ($File in $Files) {
    try {
        $Ext = $File.Extension.TrimStart('.')
        if (-not $Ext) { $Ext = "NoExtension" }
        
        # Create subfolder only if it doesn't exist
        $SubFolder = Join-Path -Path $DestinationDir -ChildPath $Ext
        if (!(Test-Path $SubFolder)) { New-Item -Path $SubFolder -ItemType Directory | Out-Null }
        
        # Move file efficiently
        Move-Item -Path $File.FullName -Destination (Join-Path -Path $SubFolder -ChildPath $File.Name) -Force
        $Counter++
        Write-Progress -Activity "Organizing files..." -Status "Processing $Counter of $TotalFiles" -PercentComplete (($Counter / $TotalFiles) * 100)
        Write-Host "✅ Moved: $($File.FullName) → $SubFolder"
    } catch {
        Write-Host "❌ Failed to move file: $($File.FullName) - Error: $_" -ForegroundColor Red
    }
}

# Completion Message
Write-Host "`n🎉 Done! Your files are now organized. Moved $Counter out of $TotalFiles files." -ForegroundColor Green
