param(
    [Parameter(Mandatory = $true)]
    [string]$HeroId,
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$SpecId = 'SPEC-044'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$auditPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/HERO-ANIMATION-AUDIT-001.json'
$outputDirectory = Join-Path $ProjectRoot '.atena/evidence/asset-review-boards'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

$audit = Get-Content -Raw -LiteralPath $auditPath | ConvertFrom-Json
$headerSpec = "SPEC-" + ($SpecId -replace '^SPEC-', '')
$order = @('idle', 'move_n', 'move_ne', 'move_e', 'move_se', 'move_s', 'attack', 'active', 'death')
$records = @($audit.records | Where-Object { $_.hero_id -eq $HeroId } | Sort-Object { $order.IndexOf($_.sequence) })
if ($records.Count -ne 9) { throw "Expected 9 source sequences for $HeroId, got $($records.Count)" }

$columns = 3
$cardWidth = 640
$cardHeight = 300
$headerHeight = 76
$rows = 3
$bitmap = New-Object System.Drawing.Bitmap ($columns * $cardWidth), ($headerHeight + $rows * $cardHeight)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.Clear([System.Drawing.Color]::FromArgb(21, 24, 31))
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
$titleFont = New-Object System.Drawing.Font 'Segoe UI', 20, ([System.Drawing.FontStyle]::Bold)
$metaFont = New-Object System.Drawing.Font 'Consolas', 9
$cardTitleFont = New-Object System.Drawing.Font 'Segoe UI', 12, ([System.Drawing.FontStyle]::Bold)
$labelBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(239, 232, 219))
$mutedBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(174, 187, 204))
$cardBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(36, 43, 55))
$checkA = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(52, 59, 71))
$checkB = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(43, 49, 59))
try {
    $graphics.DrawString("$headerSpec / $HeroId - 9 strips finais", $titleFont, $labelBrush, 18, 12)
    $graphics.DrawString('Arquivo final atual - revisao humana pendente; integridade tecnica nao e aprovacao artistica.', $metaFont, $mutedBrush, 20, 47)
    for ($index = 0; $index -lt $records.Count; $index++) {
        $record = $records[$index]
        $column = $index % $columns
        $row = [int][Math]::Floor($index / $columns)
        $x = $column * $cardWidth
        $y = $headerHeight + $row * $cardHeight
        $graphics.FillRectangle($cardBrush, $x + 6, $y + 6, $cardWidth - 12, $cardHeight - 12)
        $graphics.DrawString($record.asset_id, $cardTitleFont, $labelBrush, $x + 16, $y + 15)
        $graphics.DrawString("$($record.dimensions) | sha256:$($record.final_sha256.Substring(0, 12))", $metaFont, $mutedBrush, $x + 16, $y + 40)
        $image = [System.Drawing.Image]::FromFile((Join-Path $ProjectRoot $record.final_path))
        try {
            $area = [System.Drawing.Rectangle]::new($x + 16, $y + 62, $cardWidth - 32, $cardHeight - 78)
            $checker = 16
            for ($cy = $area.Y; $cy -lt $area.Bottom; $cy += $checker) {
                for ($cx = $area.X; $cx -lt $area.Right; $cx += $checker) {
                    $brush = if (((([int](($cx - $area.X) / $checker)) + ([int](($cy - $area.Y) / $checker))) % 2) -eq 0) { $checkA } else { $checkB }
                    $graphics.FillRectangle($brush, $cx, $cy, $checker, $checker)
                }
            }
            $scale = [Math]::Min($area.Width / $image.Width, $area.Height / $image.Height)
            $width = [int]($image.Width * $scale)
            $height = [int]($image.Height * $scale)
            $drawX = $area.X + [int](($area.Width - $width) / 2)
            $drawY = $area.Y + [int](($area.Height - $height) / 2)
            $graphics.DrawImage($image, $drawX, $drawY, $width, $height)
        }
        finally { $image.Dispose() }
    }
    $outputPath = Join-Path $outputDirectory "$SpecId-$HeroId-final-review.png"
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Output "board=$outputPath"
}
finally {
    $checkB.Dispose(); $checkA.Dispose(); $cardBrush.Dispose(); $mutedBrush.Dispose(); $labelBrush.Dispose()
    $cardTitleFont.Dispose(); $metaFont.Dispose(); $titleFont.Dispose(); $graphics.Dispose(); $bitmap.Dispose()
}
