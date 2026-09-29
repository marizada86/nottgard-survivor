# Confere o backlog em .atena/backlog: IDs duplicados, links quebrados, proximos numeros
# livres e bugs P0/P1 abertos. Uso: powershell -File tools/backlog_check.ps1 [-Brief]
# Somente leitura. Nunca falha o processo (codigo de saida 0).
param([switch]$Brief)
$root = Split-Path -Parent $PSScriptRoot
$dir = Join-Path $root '.atena/backlog'
$alerts = New-Object System.Collections.ArrayList
$maxId = @{}

foreach ($f in Get-ChildItem $dir -Filter *.md) {
  $lines = Get-Content $f.FullName -Encoding UTF8
  $seen = @{}
  foreach ($l in $lines) {
    if ($l -match '^\|\s*((BUG|MEC|ART|BAL|TOOL|IN)-(\d+))\s*\|') {
      $id = $Matches[1]; $pre = $Matches[2]; $n = [int]$Matches[3]
      if ($seen.ContainsKey($id)) { [void]$alerts.Add("ID duplicado em $($f.Name): $id") } else { $seen[$id] = 1 }
      if (-not $maxId.ContainsKey($pre) -or $maxId[$pre] -lt $n) { $maxId[$pre] = $n }
    }
  }
  $text = $lines -join "`n"
  foreach ($m in [regex]::Matches($text, '\]\(([^)\s#]+)(?:#[^)]*)?\)')) {
    $t = $m.Groups[1].Value
    if ($t -match '^(https?:|mailto:)') { continue }
    $p = Join-Path $f.DirectoryName ([uri]::UnescapeDataString($t))
    if (-not (Test-Path -LiteralPath $p)) { [void]$alerts.Add("Link quebrado em $($f.Name): $t") }
  }
}

# proximos livres declarados no README x o maior ID encontrado
$readme = Get-Content (Join-Path $dir 'README.md') -Raw -Encoding UTF8
foreach ($pre in $maxId.Keys) {
  $next = $maxId[$pre] + 1
  $ms = [regex]::Matches($readme, "\b$pre-(\d+)\b")
  $declared = 0
  foreach ($m in $ms) { $declared = [Math]::Max($declared, [int]$m.Groups[1].Value) }
  # o README so cita o proximo livre de cada prefixo na secao Numeracao
  $sec = ($readme -split '## Numera')[-1]
  $dm = [regex]::Match($sec, "\b$pre-(\d+)\b")
  if ($dm.Success -and [int]$dm.Groups[1].Value -lt $next) {
    [void]$alerts.Add("README diz proximo livre $pre-$($dm.Groups[1].Value), mas ja existe $pre-$($next - 1)")
  }
}

# bugs P0/P1 abertos (antes da secao Fechados)
$open = 0; $waiting = 0; $debt = 0; $p0 = 0; $stale = New-Object System.Collections.ArrayList
$inOpen = $false
foreach ($l in (Get-Content (Join-Path $dir 'BUGS.md') -Encoding UTF8)) {
  if ($l -match '^## Abertos') { $inOpen = $true; continue }
  if ($l -match '^## Fechados') { $inOpen = $false }
  if ($inOpen -and $l -match '^\|\s*(BUG-\d+)\s*\|\s*(P[0-2])\s*\|') {
    $id = $Matches[1]; $sev = $Matches[2]
    if ($sev -eq 'P0') { $p0++ }
    if ((($l -split '\|').Count) -le 6) { $debt++ }
    elseif ($sev -eq "P0" -or $sev -eq "P1") {
      if ($l -match 'IMPLEMENTADO|aguarda playtest|Reclassificado como mec') { $waiting++ } else { $open++; [void]$stale.Add($id) }
    }
  }
}

$summary = "Bugs: P0=$p0, P1 abertos=$open, P1 implementados aguardando playtest=$waiting, verificacoes manuais pendentes=$debt. Alertas de organizacao: $($alerts.Count)."
if ($p0 -gt 0) { $summary = "ATENCAO P0 aberto! " + $summary }
if ($open -ge 5) { $summary += " Gatilho de lote de bugs (5 ou mais P1) atingido." }
Write-Output $summary
if (-not $Brief) {
  if ($stale.Count) { Write-Output ("P1 sem implementacao: " + ($stale -join ', ')) }
  foreach ($a in $alerts) { Write-Output "  - $a" }
  foreach ($k in ($maxId.Keys | Sort-Object)) { Write-Output ("  proximo livre {0}-{1}" -f $k, ($maxId[$k] + 1)) }
}
exit 0
