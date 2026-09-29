# Confere as candidatas de arte devolvidas pelo ChatGPT contra o manifesto.
# Somente leitura: nao move, renomeia nem apaga nada.
#
# Uso (na raiz do projeto):
#   powershell -File tools\check_candidates.ps1
#   powershell -File tools\check_candidates.ps1 -Fila 002
#   powershell -File tools\check_candidates.ps1 -Fila 001 -OnlyFound
#   powershell -File tools\check_candidates.ps1 -Inbox     # lista arquivos soltos em _inbox
param(
    [ValidateSet('all', '001', '002', '003', '004')][string]$Fila = 'all',
    [switch]$OnlyFound,
    [switch]$Inbox
)

Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $PSScriptRoot
$candRoot = Join-Path $root '.atena\generated\art-candidates'

# Manifestos: 001 = filas 001 a 003; 002 = fila 004 (piloto de animacao de inimigo).
$allItems = @()
foreach ($n in '001', '002') {
    $mp = Join-Path $root ".atena\generated\CANDIDATES-MANIFEST-$n.json"
    if (Test-Path $mp) { $allItems += (Get-Content $mp -Raw -Encoding UTF8 | ConvertFrom-Json).items }
}
if ($allItems.Count -eq 0) { Write-Error "Nenhum manifesto encontrado em .atena\generated"; exit 1 }
$manifest = [pscustomobject]@{ items = $allItems }

if ($Inbox) {
    $dir = Join-Path $candRoot '_inbox'
    if (-not (Test-Path $dir)) { Write-Host "Sem pasta _inbox."; exit 0 }
    $files = Get-ChildItem $dir -File
    Write-Host ("Arquivos soltos em _inbox: {0}" -f $files.Count)
    $files | ForEach-Object { Write-Host (" - {0} ({1} KB)" -f $_.Name, [int]($_.Length / 1KB)) }
    exit 0
}

function Get-PixelDistance($c, $hex) {
    $r = [Convert]::ToInt32($hex.Substring(1, 2), 16)
    $g = [Convert]::ToInt32($hex.Substring(3, 2), 16)
    $b = [Convert]::ToInt32($hex.Substring(5, 2), 16)
    return [Math]::Abs($c.R - $r) + [Math]::Abs($c.G - $g) + [Math]::Abs($c.B - $b)
}

$rows = @()
foreach ($it in $manifest.items) {
    if ($Fila -ne 'all' -and $it.fila -ne $Fila) { continue }
    $full = Join-Path $root ($it.path -replace '/', '\')
    $dir = Split-Path -Parent $full
    $stem = ($it.path -split '/')[-1] -replace '_v\d+\.png$', ''
    $found = @()
    if (Test-Path $dir) { $found = @(Get-ChildItem $dir -Filter "$stem`_v*.png" -File | Sort-Object Name) }
    $row = [ordered]@{ Num = $it.num; Id = $it.id; Status = 'FALTA'; Versao = ''; Tamanho = ''; Nota = '' }
    if ($found.Count -gt 0) {
        $f = $found[-1]
        $row.Versao = ($f.BaseName -split '_')[-1]
        $img = $null
        try {
            $img = [System.Drawing.Bitmap]::FromFile($f.FullName)
            $w = $img.Width; $h = $img.Height
            $row.Tamanho = "${w}x${h}"
            $notes = @()
            $ratio = $w / [double]$h
            if ($it.shape -eq '16:9' -and [Math]::Abs($ratio - 16 / 9) -gt 0.06) { $notes += 'proporcao fora de 16:9' }
            if ($it.shape -eq 'square' -and [Math]::Abs($ratio - 1) -gt 0.05) { $notes += 'nao e quadrada' }
            if ($it.shape -eq 'landscape' -and $ratio -lt 1.3) { $notes += 'nao e paisagem' }
            if ($it.shape -eq 'portrait' -and ($ratio -lt 0.5 -or $ratio -gt 0.95)) { $notes += 'nao e retrato (esperado ~2:3)' }
            if ($it.shape -eq 'strip' -and $ratio -lt 1.8) { $notes += 'nao e fileira larga' }
            if ($it.shape -ne 'strip' -and ($w -lt 512 -or $h -lt 288) -and $it.shape -ne 'portrait') { $notes += 'resolucao baixa' }
            if ($it.shape -eq 'portrait' -and $h -lt 512) { $notes += 'resolucao baixa' }
            if ($it.shape -eq 'strip' -and $w -lt 1000) { $notes += 'resolucao baixa' }
            if ($it.bg) {
                $pts = @(@(2, 2), @(($w - 3), 2), @(2, ($h - 3)), @(($w - 3), ($h - 3)))
                $bad = 0
                foreach ($p in $pts) { if ((Get-PixelDistance $img.GetPixel($p[0], $p[1]) $it.bg) -gt 90) { $bad++ } }
                if ($bad -gt 0) { $notes += "fundo fora de $($it.bg) em $bad/4 cantos" }
            }
            if ($f.Length -lt 20KB) { $notes += 'arquivo muito pequeno' }
            $row.Status = if ($notes.Count -eq 0) { 'OK' } else { 'REVISAR' }
            $row.Nota = ($notes -join '; ')
        }
        catch { $row.Status = 'ERRO'; $row.Nota = $_.Exception.Message }
        finally { if ($img) { $img.Dispose() } }
    }
    $rows += [pscustomobject]$row
}

$show = if ($OnlyFound) { $rows | Where-Object { $_.Status -ne 'FALTA' } } else { $rows }
$show | Format-Table -AutoSize | Out-String -Width 200 | Write-Host
$byStatus = $rows | Group-Object Status | ForEach-Object { "{0}={1}" -f $_.Name, $_.Count }
Write-Host ("Total: {0} | {1}" -f $rows.Count, ($byStatus -join ' | '))
Write-Host "Checagem automatica e so triagem: a aprovacao visual continua sendo do dono."
