@echo off
cd /d "%~dp0..\..\.."
set "APPDATA=%CD%\.atena\generated\hero-integration-2026-10-10\qa-user"
set "LOCALAPPDATA=%APPDATA%"
"F:\dev\nottgard-survivor\Godot_v4.7.2-stable_win64.exe" --path . res://tools/hero_art_playtest.tscn -- arlindo
