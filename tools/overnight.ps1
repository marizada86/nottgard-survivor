<#
Varredura longa e segura (só lê o projeto e grava relatórios; não altera código nem arte):
  1. testes (tests/run_all.gd)
  2. auditoria de proporções dos sprites (tools/audit_hero_motion.gd)
  3. bot de balanceamento: todos os heróis x Dagruve e Docas (mapas de 5 min, BAL-011) x N sementes
Saída: .atena/generated/overnight/<data-hora>/  (RESUMO.md, bot-resumo.csv, logs brutos)
Uso (na raiz do projeto):  powershell -ExecutionPolicy Bypass -File tools/overnight.ps1
Opções: -Seeds 30 (padrão, ~1h30)   -Quick (1 herói, 1 semente, para testar o script)
#>
param([int]$Seeds = 30, [switch]$Quick)

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
$godot = Join-Path $root "Godot_v4.7.2-stable_win64.exe"
if (-not (Test-Path $godot)) { Write-Host "Godot não encontrado em $godot"; exit 1 }

$stamp = Get-Date -Format "yyyy-MM-dd_HHmm"
$out = Join-Path $root ".atena/generated/overnight/$stamp"
New-Item -ItemType Directory -Force -Path $out | Out-Null
$heroes = @("durvall", "brook", "maelor", "sylas", "kayron", "korrak", "leoric", "nyrelia", "zynara", "bromnor")
$stages = @("dagruve", "docas")
if ($Quick) { $heroes = @("sylas"); $Seeds = 1; $stages = @("dagruve") }
$started = Get-Date

function Log($msg) { $line = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $msg; Write-Host $line; Add-Content -Path (Join-Path $out "progresso.log") -Value $line }

# Executa o Godot esperando terminar e grava stdout+stderr no log (Start-Process evita as armadilhas de redirecionamento do PowerShell 5.1)
function Run-Godot([string[]]$GodotArgs, [string]$LogPath) {
    $errPath = "$LogPath.err"
    Start-Process -FilePath $godot -ArgumentList $GodotArgs -WorkingDirectory $root -NoNewWindow -Wait -RedirectStandardOutput $LogPath -RedirectStandardError $errPath
    if (Test-Path $errPath) { Add-Content -Path $LogPath -Value (Get-Content $errPath -Raw); Remove-Item $errPath }
}

Log "Início. Heróis: $($heroes.Count), fases: $($stages -join ', '), sementes: $Seeds. Saída: $out"

# 1) testes
Log "1/3 testes"
Run-Godot @("--headless", "--path", ".", "--script", "tests/run_all.gd") (Join-Path $out "testes.log")
$testLine = (Select-String -Path (Join-Path $out "testes.log") -Pattern "testes:" | Select-Object -Last 1).Line
Log "testes: $testLine"

# 2) auditoria dos sprites
Log "2/3 auditoria de sprites"
Run-Godot @("--headless", "--path", ".", "--script", "tools/audit_hero_motion.gd") (Join-Path $out "sprites-audit.log")
Select-String -Path (Join-Path $out "sprites-audit.log") -Pattern "^[a-z]+," | ForEach-Object { $_.Line } | Set-Content -Path (Join-Path $out "sprites-audit.csv") -Encoding utf8

# 3) bot
Log "3/3 bot de balanceamento"
$csv = Join-Path $out "bot-resumo.csv"
Set-Content -Path $csv -Value "heroi;fase_inicial;linha" -Encoding utf8
foreach ($stage in $stages) {
    foreach ($hero in $heroes) {
        $t0 = Get-Date
        $log = Join-Path $out ("bot-{0}-{1}.log" -f $hero, $stage)
        Run-Godot @("--headless", "--path", ".", "-s", "tools/bot.gd", "--", $hero, "$Seeds", $stage, "0.05", "3") $log
        $lines = Select-String -Path $log -Pattern "^seed " | ForEach-Object { $_.Line }
        foreach ($l in $lines) { Add-Content -Path $csv -Value ("{0};{1};{2}" -f $hero, $stage, ($l -replace ";", ",")) -Encoding utf8 }
        $reached = (Select-String -Path $log -Pattern "^chegaram" | Select-Object -Last 1).Line
        Log ("{0} em {1}: {2} s | {3}" -f $hero, $stage, [int]((Get-Date) - $t0).TotalSeconds, $reached)
    }
}

# resumo em Markdown
$elapsed = (Get-Date) - $started
$md = @()
$md += "# Varredura noturna $stamp"
$md += ""
$md += "- Duração: $([int]$elapsed.TotalMinutes) min · sementes por herói e fase: $Seeds"
$md += "- Testes: $testLine"
$md += "- Arquivos: bot-resumo.csv (uma linha por semente), bot-<heroi>-<fase>.log, sprites-audit.csv, testes.log"
$md += ""
$md += "## Bot: níveis por herói e fase (média das sementes)"
$md += ""
$md += "| Herói | Fase | Níveis (por semente) | Média |"
$md += "|---|---|---|---|"
foreach ($stage in $stages) {
    foreach ($hero in $heroes) {
        $lv = @()
        foreach ($row in (Import-Csv -Path $csv -Delimiter ";" | Where-Object { $_.heroi -eq $hero -and $_.fase_inicial -eq $stage })) {
            if ($row.linha -match "nv=(\d+)") { $lv += [int]$Matches[1] }
        }
        if ($lv.Count -gt 0) {
            $avg = [math]::Round((($lv | Measure-Object -Average).Average), 1)
            $md += "| $hero | $stage | $($lv -join ', ') | $avg |"
        } else {
            $md += "| $hero | $stage | sem dados | - |"
        }
    }
}
Set-Content -Path (Join-Path $out "RESUMO.md") -Value $md -Encoding utf8
Log "Fim em $([int]$elapsed.TotalMinutes) min. Resumo: $(Join-Path $out 'RESUMO.md')"
