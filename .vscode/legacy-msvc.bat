@echo off

REM Preferred legacy toolchain discovery order: VS2008 -> VS2005 -> VS2003.
REM Edit this file if your legacy compiler is installed in a custom location.

if defined VS90COMNTOOLS (
  if exist "%VS90COMNTOOLS%..\..\VC\vcvarsall.bat" (
    call "%VS90COMNTOOLS%..\..\VC\vcvarsall.bat" x86
    goto :eof
  )
)

if defined VS80COMNTOOLS (
  if exist "%VS80COMNTOOLS%..\..\VC\vcvarsall.bat" (
    call "%VS80COMNTOOLS%..\..\VC\vcvarsall.bat" x86
    goto :eof
  )
)

if exist "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" (
  call "C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86
  goto :eof
)

if exist "C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall.bat" (
  call "C:\Program Files (x86)\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
  goto :eof
)

if exist "C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Vc7\bin\cl.exe" (
  if exist "C:\Program Files\Microsoft Platform SDK\Include\windows.h" (
    set "PATH=C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Vc7\bin;C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Common7\IDE;C:\Program Files\Microsoft Platform SDK\Bin;C:\Program Files (x86)\Microsoft Visual C++ Toolkit 2003\bin;%PATH%"
    set "INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Vc7\include;C:\Program Files\Microsoft Platform SDK\Include;%INCLUDE%"
    set "LIB=C:\Program Files (x86)\Microsoft Visual Studio .NET 2003\Vc7\lib;C:\Program Files\Microsoft Platform SDK\Lib;%LIB%"
    goto :eof
  )
)

set "VCTOOLKIT=C:\Program Files (x86)\Microsoft Visual C++ Toolkit 2003"
set "SDK71A=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A"
set "SAL_INCLUDE="

if exist "%SDK71A%\Include\sal.h" set "SAL_INCLUDE=%SDK71A%\Include"
if not defined SAL_INCLUDE if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133\include\sal.h" set "SAL_INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133\include"
if not defined SAL_INCLUDE if exist "C:\Program Files (x86)\Windows Kits\10\Include\10.0.22000.0\shared\sal.h" set "SAL_INCLUDE=C:\Program Files (x86)\Windows Kits\10\Include\10.0.22000.0\shared"
if not defined SAL_INCLUDE if exist "C:\Program Files (x86)\Windows Kits\10\Include\10.0.19041.0\shared\sal.h" set "SAL_INCLUDE=C:\Program Files (x86)\Windows Kits\10\Include\10.0.19041.0\shared"

if exist "%VCTOOLKIT%\bin\cl.exe" (
  if exist "%SDK71A%\Include\Windows.h" (
    set "PATH=%VCTOOLKIT%\bin;%SDK71A%\Bin;%PATH%"
    if defined SAL_INCLUDE (
      set "INCLUDE=%VCTOOLKIT%\include;%SDK71A%\Include;%SAL_INCLUDE%;%INCLUDE%"
    ) else (
      set "INCLUDE=%VCTOOLKIT%\include;%SDK71A%\Include;%INCLUDE%"
    )
    set "LIB=%VCTOOLKIT%\lib;%SDK71A%\Lib;%LIB%"

    where nmake.exe >nul 2>nul
    if errorlevel 1 (
      for /f "delims=" %%I in ('where /r "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC" nmake.exe 2^>nul') do (
        set "NMAKE_EXE=%%I"
        goto :found_nmake
      )
    )

:found_nmake
    if defined NMAKE_EXE (
      for %%D in ("%NMAKE_EXE%") do set "PATH=%PATH%;%%~dpD"
    )

    where nmake.exe >nul 2>nul
    if errorlevel 1 (
      echo nmake.exe was not found. Install Build Tools or add nmake.exe to PATH.
      exit /b 1
    )

    goto :eof
  )
)

echo Legacy MSVC environment script was not found.
echo Update .vscode\legacy-msvc.bat or set HL_TOOLCHAIN_BAT to your toolchain batch file.
exit /b 1
