Add-Type -AssemblyName System.Windows.Forms
$Host.UI.RawUI.WindowTitle = "Teto Icons Installer - by MalikHw47"

$Url = "https://github.com/MalikHw/teto-icons/releases/latest/download/teto-icons.zip"
$ZipName = "teto-cube.zip"
$RelativePath = "geode\config\geode.texture-loader\packs"

# 1. Path Finding Logic
$DefaultPath = "C:\Program Files (x86)\Steam\steamapps\common\Geometry Dash"
$InstallPath = ""

if (Test-Path "$DefaultPath\GeometryDash.exe") {
    $InstallPath = $DefaultPath
} else {
    Write-Host "Geometry Dash not found in default folder. Please select it manually." -ForegroundColor Yellow
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = "Select your Geometry Dash installation folder"
    $Result = $FolderBrowser.ShowDialog()
    
    if ($Result -eq "OK") {
        $SelectedPath = $FolderBrowser.SelectedPath
        if (!(Test-Path "$SelectedPath\GeometryDash.exe")) {
            [System.Windows.Forms.MessageBox]::Show("Error: GeometryDash.exe not found.", "Invalid Folder", "OK", "Error")
            exit
        }
        $InstallPath = $SelectedPath
    } else {
        exit
    }
}

# 2. Prepare Destination
$DestinationFolder = Join-Path -Path $InstallPath -ChildPath $RelativePath
if (!(Test-Path $DestinationFolder)) {
    New-Item -ItemType Directory -Force -Path $DestinationFolder | Out-Null
}

# --- NUKE AND REPLACE LOGIC ---
$FinalZipPath = Join-Path -Path $DestinationFolder -ChildPath $ZipName
$ExtractedFolder = Join-Path -Path $DestinationFolder -ChildPath "teto-cube"

if (Test-Path $FinalZipPath) {
    Write-Host "Old zip found. Nuking it..." -ForegroundColor DarkRed
    Remove-Item -Path $FinalZipPath -Force
}
if (Test-Path $ExtractedFolder) {
    Write-Host "Old folder found. Nuking it..." -ForegroundColor DarkRed
    Remove-Item -Path $ExtractedFolder -Recurse -Force
}
# ------------------------------

# 3. Download directly to destination
Write-Host "Downloading fresh Teto Icons..." -ForegroundColor Green
try {
    Invoke-WebRequest -Uri $Url -OutFile $FinalZipPath
    
    # Optional: If Geode requires it to be unzipped manually
    # Write-Host "Extracting..." -ForegroundColor Green
    # Expand-Archive -Path $FinalZipPath -DestinationPath $DestinationFolder -Force
    
    [System.Windows.Forms.MessageBox]::Show("Teto Cube has been successfully replaced!", "Success")
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

Pause
