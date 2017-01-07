# Prusa Mk2 firmware development environment for Windows
The [Prusa Mk2 firmware](https://github.com/prusa3d/Prusa-Firmware) has several requirements which must be met in order to successfully compile and deploy to your printer.  This script will download the required files and make the necessary modifications for a complete Arduino development environment on your Windows system.  

The resulting development environment will be portable and will not change or impact existing Arduino IDE installations.

## Requirements
**This script utilizes PowerShell version 5**, installed by default on Windows 10 and [available for download from Microsoft for earlier Windows versions](https://www.microsoft.com/en-us/download/details.aspx?id=50395).

## Procedure
### Step 1 - Run the script
Double-click on the .cmd file and it will call the PowerShell script to deploy the development environment into a subfolder named "Prusa-Firmware".  After deployment the IDE will be opened and shortcuts will be created for later use.

### Step 2 [Optional] - Edit the Firmware
Make some modifications to the firmware.

For example, edit the `Configuration_prusa.h` file and edit (at your own risk):

* Extruder PID tuning: `DEFAULT_Kp`, `DEFAULT_Ki` and `DEFAULT_Kd` values
* Bed PID tuning: `DEFAULT_bedKp`, `DEFAULT_bedKi`, `DEFAULT_bedKd` values
* Extruder fan noise: reduce `EXTRUDER_AUTO_FAN_SPEED` from `255` to `96` (experiment a bit)

### Step 3 - Build the Firmware
You can now build the firmware:

* Compile the firmware with `Sketch -> Build (CTRL-R)`.
* Export the compiled binary with `Sketch -> Export compiled sketch (CTRL-ALT-S)`.

The compiled firmware will be exported to `Prusa-Firmware-MK2\Firmware\Firmware.ino.with_bootloader.rambo.hex`

### Step 4 - Upload the Firmware
[Follow Prusa's official firmware upgrade guide here](http://manual.prusa3d.com/Guide/Upgrading+firmware/66).

### Credits
The script and this document were largely copied from [this excellent guide](https://github.com/prusa3d/Prusa-Firmware/issues/29#issuecomment-268985294) posted by GitHub user [pboschi](https://github.com/pboschi).
