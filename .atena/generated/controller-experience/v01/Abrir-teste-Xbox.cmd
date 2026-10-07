@echo off
setlocal
set "CONTROLLER_PROJECT=D:\dev\nottgard\games\godot\nottgard-survivors"
if not exist "D:\Godot\godot.exe" (
  echo Godot nao encontrado em D:\Godot\godot.exe
  pause
  exit /b 1
)
start "" "D:\Godot\godot.exe" --path "%CONTROLLER_PROJECT%" res://tools/controller_preview.tscn --log-file "%CONTROLLER_PROJECT%\.atena\generated\controller-experience\v01\pilot.log" -- --controller-profile res://.atena/generated/controller-experience/v01/pilot-profile.json
endlocal
