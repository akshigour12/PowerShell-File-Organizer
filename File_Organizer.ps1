# Get the currently logged-in user using a more reliable method
$LoggedInUsers = whoami
$LoggedInUsers = $LoggedInUsers -replace '.*\\'

if (-not $LoggedInUsers) {
    Write-Host "❌ Unable to retrieve logged-in users. Exiting..."
    exit
}

# Display logged-in user
Write-Host "`n🔹 Currently logged-in user: $LoggedInUsers"

# Prompt user for confirmation
$SelectedUser = Read-Host "`nEnter your username to confirm (must match above)"

# Validate username
if ($LoggedInUsers -ne $SelectedUser) {
    Write-Host "❌ Invalid username. Exiting..."
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
    $Dialog.ShowDialog() | Out-Null
    return $Dialog.SelectedPath
}

# Select source and destination directories
Write-Host "`n📂 Choose the folder where your files are located..."
$SourceDir = Select-Folder
if (-not $SourceDir) { Write-Host "⚠️ No folder selected. Exiting..." ; exit }

Write-Host "`n📂 Choose where to organize your files..."
$DestinationDir = Select-Folder
if (-not $DestinationDir) { Write-Host "⚠️ No destination selected. Exiting..." ; exit }

# Ensure source and destination are different
if ($SourceDir -eq $DestinationDir) {
    Write-Host "❌ Source and destination cannot be the same. Exiting..."
    exit
}

# Fetch files with error handling
try {
    $Files = Get-ChildItem -Path $SourceDir -File -ErrorAction Stop
} catch {
    Write-Host "❌ Error accessing source folder: $_"
    exit
}

if (-not $Files) {
    Write-Host "📁 No files found in the source folder. Nothing to organize!"
    exit
}

Write-Host "`n🔄 Organizing files...`n"

# Process files efficiently
$TotalFiles = $Files.Count
$ProcessedFiles = 0

$Files | ForEach-Object {
    $Ext = $_.Extension.TrimStart('.')
    if (-not $Ext) { $Ext = "NoExtension" }

    # Create subfolder only if it doesn't exist
    $SubFolder = Join-Path -Path $DestinationDir -ChildPath $Ext
    if (!(Test-Path $SubFolder)) { New-Item -Path $SubFolder -ItemType Directory | Out-Null }

    # Move file efficiently
    Move-Item -Path $_.FullName -Destination (Join-Path -Path $SubFolder -ChildPath $_.Name) -Force
    $ProcessedFiles++
    Write-Host "✅ Moved: $($_.Name) → $SubFolder ($ProcessedFiles/$TotalFiles)"
}

Write-Host "`n🎉 Done! Your files are now organized. Total files moved: $ProcessedFiles"
