Param(
  [string]$version,
  [string]$runservice,
  [string]$minion,
  [string]$master
)

# Constants
$ServiceName = "salt-minion"
$startupType = "Manual"

# Version to install - default to latest if there is an issue
If ($version -notmatch "201[0-9]\.[0-9]\.[0-9](\-\d{1})?"){
  $version = '2015.5.2'
}

If ($runservice.ToLower() -eq "true"){
  Write-Host "Service is set to run."
  [bool]$runservice = $True
}
ElseIf ($runservice.ToLower() -eq "false"){
  Write-Host "Service will be stopped and set to manual."
  [bool]$runservice = $False
}
Else {
  # Param passed in wasn't clear so defaulting to true.
   Write-Host "Service defaulting to run."
  [bool]$runservice = $True
}


# Create C:\tmp\ - if Vagrant doesn't upload keys and/or config it might not exist
New-Item C:\tmp\ -ItemType directory -force | out-null

# Copy minion keys & config to correct location
New-Item C:\salt\conf\pki\minion\ -ItemType directory -force | out-null

# Check if minion keys have been uploaded
If (Test-Path C:\tmp\minion.pem) {
  cp C:\tmp\minion.pem C:\salt\conf\pki\minion\
  cp C:\tmp\minion.pub C:\salt\conf\pki\minion\
}

# Detect architecture
If ([IntPtr]::Size -eq 4) {
  $arch = "x86"
} Else {
  $arch = "AMD64"
}

# Download minion setup file
Write-Host "Downloading Salt minion installer Salt-Minion-$version-$arch-Setup.exe"
$webclient = New-Object System.Net.WebClient
$url = "https://docs.saltstack.com/downloads/Salt-Minion-$version-$arch-Setup.exe"
$file = "C:\tmp\salt.exe"
$webclient.DownloadFile($url, $file)


# Install minion silently
Write-Host "Installing Salt minion..."
#Wait for process to exit before continuing...
If($PSBoundParameters.ContainsKey('minion') -and $PSBoundParameters.ContainsKey('master')) {
  C:\tmp\salt.exe /S /minion-name=$minion /master=$master | Out-Null
  Write-Host C:\tmp\salt.exe /S /minion-name=$minion /master=$master | Out-Null
}
ElseIf($PSBoundParameters.ContainsKey('minion') -and !$PSBoundParameters.ContainsKey('master')) {
  C:\tmp\salt.exe /S /minion-name=$minion | Out-Null
  Write-Host C:\tmp\salt.exe /S /minion-name=$minion | Out-Null
}
ElseIf(!$PSBoundParameters.ContainsKey('minion') -and $PSBoundParameters.ContainsKey('master')) {
  C:\tmp\salt.exe /S /master=$master | Out-Null
  Write-Host C:\tmp\salt.exe /S /master=$master | Out-Null
}
Else {
  C:\tmp\salt.exe /S | Out-Null
  Write-Host C:\tmp\salt.exe /S | Out-Null 
}

# Check if minion config has been uploaded
If (Test-Path C:\tmp\minion) {
  cp C:\tmp\minion C:\salt\conf\
}

# Wait for salt-minion service to be registered before trying to start it
$service = Get-Service salt-minion -ErrorAction SilentlyContinue
While (!$service) {
  Start-Sleep -s 2
  $service = Get-Service salt-minion -ErrorAction SilentlyContinue
}

If($runservice) {
  # Start service
  Start-Service -Name "salt-minion" -ErrorAction SilentlyContinue

  # Check if service is started, otherwise retry starting the 
  # service 4 times.
  $try = 0
  While (($service.Status -ne "Running") -and ($try -ne 4)) {
    Start-Service -Name "salt-minion" -ErrorAction SilentlyContinue
    $service = Get-Service salt-minion -ErrorAction SilentlyContinue
    Start-Sleep -s 2
    $try += 1
  }

  # If the salt-minion service is still not running, something probably
  # went wrong and user intervention is required - report failure.
  If ($service.Status -eq "Stopped") {
    Write-Host "Failed to start Salt minion"
    exit 1
  }
}
Else {
  Write-Host "Stopping salt minion"
  Set-Service "$ServiceName" -startupType "$startupType"
  Stop-Service "$ServiceName"
}

Write-Host "Salt minion successfully installed"