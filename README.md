# Prusa Mk2 firmware development environment for Windows
The [Prusa Mk2 firmware](https://github.com/prusa3d/Prusa-Firmware) has several requirements which must be met in order to successfully compile and deploy to your printer.  This script will download the required files and make the necessary modifications for a complete Arduino development environment on your Windows system.  

The resulting development environment will be portable and will not change or impact existing Arduino IDE installations.

### Requirements
This script utilizes PowerShell version 5, installed by default on Windows 10 and [available for download from Microsoft for earlier Windows versions](https://www.microsoft.com/en-us/download/details.aspx?id=50395).

### Procedure
Double-click on the .cmd file and it will call the PowerShell script to deploy the development environment into a subfolder named "Prusa-Firmware".  After deployment the IDE will be opened and shortcuts will be created for later use.
