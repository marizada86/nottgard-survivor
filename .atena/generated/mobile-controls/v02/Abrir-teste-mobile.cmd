@echo off
setlocal
cd /d "%~dp0..\..\..\.."
set "APPDATA=%CD%\.atena\generated\mobile-controls\v02\test-profile"
"D:\Godot\godot.exe" --path "%CD%" res://tools/mobile_preview.tscn --log-file "%CD%\.atena\generated\mobile-controls\v02\preview.log" -- --mobile-controls
endlocal
