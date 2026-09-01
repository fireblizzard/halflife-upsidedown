param(
  [Parameter(Mandatory = $true)]
  [string]$WorkDir,

  [Parameter(Mandatory = $true)]
  [string]$Makefile,

  [Parameter(Mandatory = $true)]
  [string]$Config,

  [Parameter(Mandatory = $true)]
  [string]$Target,

  [Parameter(Mandatory = $false)]
  [string]$ToolchainBat
)

function Get-ModernToolchainCmd {
  param(
    [switch]$AllowMissing
  )

  $vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
  if (-not (Test-Path $vswhere)) {
    if ($AllowMissing) {
      return $null
    }

    Write-Error "vswhere.exe was not found. Install Visual Studio Build Tools with C++ workload or set HL_TOOLCHAIN_BAT."
    exit 1
  }

  $vsInstallPath = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  if (-not $vsInstallPath) {
    if ($AllowMissing) {
      return $null
    }

    Write-Error "No Visual Studio C++ toolchain installation was found. Install Build Tools or set HL_TOOLCHAIN_BAT."
    exit 1
  }

  $devCmd = Join-Path $vsInstallPath "Common7\Tools\VsDevCmd.bat"
  if (-not (Test-Path $devCmd)) {
    if ($AllowMissing) {
      return $null
    }

    Write-Error "VsDevCmd.bat was not found at $devCmd"
    exit 1
  }

  return "call `"$devCmd`" -host_arch=x64 -arch=x86"
}

$toolchainCmd = ""
$defaultLegacyToolchain = Join-Path $PSScriptRoot "legacy-msvc.bat"
$preferLegacyDefault = $false
$chosenToolchain = ""

if ($ToolchainBat) {
  $chosenToolchain = $ToolchainBat
}
elseif ($env:HL_TOOLCHAIN_BAT) {
  $chosenToolchain = $env:HL_TOOLCHAIN_BAT
}
elseif (Test-Path $defaultLegacyToolchain) {
  $chosenToolchain = $defaultLegacyToolchain
  $preferLegacyDefault = $true
}

if ($chosenToolchain) {
  if (-not (Test-Path $chosenToolchain)) {
    Write-Error "Configured toolchain batch file was not found: $chosenToolchain"
    exit 1
  }

  if ($preferLegacyDefault) {
    $modernCmd = Get-ModernToolchainCmd -AllowMissing
    if ($modernCmd) {
      $toolchainCmd = "call `"$chosenToolchain`" || $modernCmd"
    }
    else {
      $toolchainCmd = "call `"$chosenToolchain`""
    }
  }
  else {
    $toolchainCmd = "call `"$chosenToolchain`""
  }
}
else {
  $toolchainCmd = Get-ModernToolchainCmd
}

$cmd = "($toolchainCmd) && cd /d `"$WorkDir`" && nmake /f `"$Makefile`" CFG=`"$Config`" $Target"
Write-Host "[invoke-nmake] WorkDir: $WorkDir"
Write-Host "[invoke-nmake] Makefile: $Makefile"
Write-Host "[invoke-nmake] Config: $Config"
Write-Host "[invoke-nmake] Target: $Target"

$startTime = Get-Date
$targetPath = $null
$beforeWriteTimeUtc = $null

if ($Target -notmatch '^(CLEAN|clean)$') {
  $targetPath = Join-Path $WorkDir $Target
  if (Test-Path $targetPath) {
    $beforeWriteTimeUtc = (Get-Item $targetPath).LastWriteTimeUtc
  }
}

# Run cmd/nmake with live output so VS Code terminal shows progress immediately.
& cmd.exe /d /c $cmd
$exitCode = $LASTEXITCODE

$duration = (Get-Date) - $startTime
Write-Host ("[invoke-nmake] ExitCode: {0} (elapsed {1}s)" -f $exitCode, [int]$duration.TotalSeconds)

if ($exitCode -eq -1073741515) {
  Write-Warning "[invoke-nmake] A tool failed to start (Windows STATUS_DLL_NOT_FOUND). Check PATH and required legacy VC runtime DLLs in your selected toolchain."
}

if ($exitCode -eq 0 -and $Target -notmatch '^(CLEAN|clean)$') {
  if (Test-Path $targetPath) {
    $artifact = Get-Item $targetPath
    Write-Host ("[invoke-nmake] Artifact: {0} ({1} bytes, modified {2})" -f $artifact.FullName, $artifact.Length, $artifact.LastWriteTime)

    if ($beforeWriteTimeUtc -and $artifact.LastWriteTimeUtc -eq $beforeWriteTimeUtc) {
      Write-Host "[invoke-nmake] Artifact timestamp unchanged; target was already up to date."
    }
    elseif ($beforeWriteTimeUtc) {
      Write-Host "[invoke-nmake] Artifact timestamp changed; target was rebuilt."
    }
  }
  else {
    Write-Warning "[invoke-nmake] Build returned success but target artifact was not found at $targetPath"
  }
}

exit $exitCode
