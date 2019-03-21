<#  
.SYNOPSIS 
  This script will download all the required elements to modify and compile the Prusa firmware from the latest codebase on GitHub
.DESCRIPTION
  The Prusa firmware build environment is picky about Arduino versions and requires some modification to the default Arduino IDE settings before you can get started.  This script will automatically download all of the required components with the correct versions and make the necessary configuration changes to allow the user to successfully compile the Prusa firmware.  The deployed environment will be portable and will not interfere with any existing Arduino installations on your system.
  
  The downloaded environment will be placed into .\Prusa-Firmware by default.  A different folder can be provided with the -Path argument.

  This script requires PowerShell version 5, installed by default in Windows 10 and available for download from Microsoft for earlier operating systems from the following URL: https://www.microsoft.com/en-us/download/details.aspx?id=50395
.PARAMETER Path
  Specify the target folder for deploying the development environment.  Default is ".\Prusa-Firmware"
.PARAMETER RAMBo
  Specify the RAMBo Mini controller variant.  This value can be either "0" for RAMBo Mini 1.0-1.2, or "3" for RAMBo Mini 1.3a.  Default is 1.3a unless specified.
.EXAMPLE
  PS> Get-PrusaFwDevEnv.ps1 -Path PrusaDev
  
  Deploy the Prusa development environment into folder PrusaDev
.NOTES
  Author: Allen Derusha <allen@derusha.org>
#>
#Requires -Version 5.0

Param(
  [Parameter(Position=0,HelpMessage="Prusa development environment deployment path")][String]$Path=".\Prusa-Firmware",
  [Parameter(Position=1,HelpMessage="Enter RAMBo variant 1.[0] or 1.[3]")][ValidateSet('0','3')][String]$RAMBo=3
)

# Create our target path if it doesn't exist already and change our working directory
If (-Not (Test-Path -Path $Path)) {
  New-Item -Path $Path -ItemType Directory -Force | Out-Null
}
Push-Location -Path $Path

# Set this to the version of RAMBo installed in your printer.
$RAMBoVariant="1_75mm_MK2-RAMBo1${RAMBo}a-E3Dv6full"

$PrusaFwUri="https://codeload.github.com/prusa3d/Prusa-Firmware/zip/MK2"
$PrusaFwFile="Prusa-Firmware-MK2.zip"
$ArduinoIdeUri="https://downloads.arduino.cc/arduino-1.6.8-windows.zip"
$ArduinoIdeFile="arduino-1.6.8-windows.zip"
$BootloaderUri="https://raw.githubusercontent.com/arduino/ArduinoCore-avr/master/bootloaders/stk500v2/stk500boot_v2_mega2560.hex"
$BootloaderFile="stk500boot_v2_mega2560.hex"

# Notify the user what we're up to and move ourselves down a few lines so the text won't be covered by the download progress indicator
Write-Host -NoNewline -ForegroundColor Yellow "Deploying Prusa mk2 development environment to: "
Write-Host "$Path"
Write-Host "`n`n`n`n`n`n"

Write-Host "This might take a few minutes, so while it's running check and make sure that"
Write-Host "you have selected the correct RAMBo Mini controller variant for your printer.`n"
If ($RAMBo) {
  Write-Host -NoNewline "This is currently set to "
  Write-Host -NoNewline -ForegroundColor Red "RAMBo Mini variant 1.3a"
  Write-Host ", which ships with all new"
  Write-Host "Prusa mk2 printers. If this is incorrect (say, if you upgraded from a mk1),"
  Write-Host "please cancel the script now and re-run it with the `"-RAMBo 0`" parameter.`n"
}
Else {
  Write-Host -NoNewline "You have manually selected the "
  Write-Host -NoNewline -ForegroundColor Red "RAMBo Mini variant 1.0"
  Write-Host ".  If this is incorrect,"
  Write-Host "please cancel the script and run it without forcing this version."
}

Write-Host "Downloading latest Prusa firmware from GitHub"
Invoke-WebRequest -Uri $PrusaFwUri -OutFile $PrusaFwFile
Write-Host "Downloading Arduino IDE v1.6.8"
Invoke-WebRequest -Uri $ArduinoIdeUri -OutFile $ArduinoIdeFile
Write-Host "Downloading bootloader"
Invoke-WebRequest -Uri $BootloaderUri -OutFile $BootloaderFile

Write-Host "Extracting Prusa firmware bundle"
Expand-Archive -Path $PrusaFwFile -DestinationPath "." -Force

Write-Host "Extracting Arduino IDE"
Expand-Archive -Path $ArduinoIdeFile -DestinationPath "." -Force

# Set the Arduino IDE to portable per https://www.arduino.cc/en/Guide/PortableIDE
New-Item -Path ".\arduino-1.6.8\portable" -ItemType Directory -Force | Out-Null

# Delete the standard LiquidCrystal library as there is a name conflict in the Prusa FW
If (Test-Path ".\arduino-1.6.8\libraries\LiquidCrystal") {
  Remove-Item -Path ".\arduino-1.6.8\libraries\LiquidCrystal" -Recurse
}

# Copy required items to Arduino folder from Prusa repo
Copy-Item -Path ".\Prusa-Firmware-MK2\ArduinoAddons\Arduino_1.6.x\*" -Destination ".\arduino-1.6.8" -Recurse -Force
Copy-Item -Path ".\Prusa-Firmware-MK2\Firmware\variants\$RAMBoVariant.h" -Destination ".\Prusa-Firmware-MK2\Firmware\Configuration_prusa.h" -Force

# Copy bootloader to the required locations
Copy-Item -Path $BootloaderFile -Destination ".\arduino-1.6.8\hardware\arduino\avr\bootloaders\stk500v2" -Force
Copy-Item -Path $BootloaderFile -Destination ".\arduino-1.6.8\hardware\marlin\avr\bootloaders" -Force

# Set the board definition if this is a new deployment
If (-Not (Test-Path -Path ".\arduino-1.6.8\portable\preferences.txt")) {
  Set-Content -Path ".\arduino-1.6.8\portable\preferences.txt" -Value "board=rambo","target_package=marlin","update.check=false"
}

# Create shortcut to launch the firmware in the Arduino IDE
$Shell = New-Object -ComObject ("WScript.Shell")
$ShortCut = $Shell.CreateShortcut("$pwd\Prusa Firmware Development.lnk")
$ShortCut.TargetPath="$pwd\arduino-1.6.8\arduino.exe"
$ShortCut.Arguments="`"$pwd\Prusa-Firmware-MK2\Firmware\Firmware.ino`""
$ShortCut.Description = "Launch the Arduino IDE for Prusa Firmware Development";
$ShortCut.Save()

# Launch our new shortcut
& "$pwd\Prusa Firmware Development.lnk"

# Return the user from whence they came
Pop-Location
