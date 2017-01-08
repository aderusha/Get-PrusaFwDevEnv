@echo off
title Deploying Prusa Firmware Development Environment
PowerShell.exe -ExecutionPolicy Bypass -Command "& '.\Get-PrusaFwDevEnv.ps1'" "-Path .\Prusa-Firmware" "-RAMBo 3"
if errorlevel 1 (
  echo Powershell returned an error, likely due to an outdated version.
  echo Download the latest release of Powershell for your system here:
  echo https://www.microsoft.com/en-us/download/details.aspx?id=50395
  pause
)
