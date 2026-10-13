@echo off
setlocal
cd /d "%~dp0..\..\.."
set "APPDATA=%~dp0qa-playtest-arlindo"
echo Local playtest build: 0.4.0/hero-admission-v01/2ae8c48+local-27698ca26839
"C:\Users\Higor Rossini\Desktop\Nottcard\Godot_v4.7.2-stable_win64.exe" --path . --log-file ".atena/generated/hero-admission-2026-10-13/playtest-arlindo.log" res://tools/hero_art_playtest.tscn -- arlindo
endlocal
