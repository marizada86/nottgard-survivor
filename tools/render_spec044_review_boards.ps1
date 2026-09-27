param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$assetAuditPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/ASSET-AUDIT-001.json'
$heroAuditPath = Join-Path $ProjectRoot '.atena/generated/asset-audit/HERO-ANIMATION-AUDIT-001.json'
$outputDirectory = Join-Path $ProjectRoot '.atena/evidence/asset-review-boards'
New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

function New-Board([object[]]$Records, [string]$Title, [string]$OutputPath, [int]$Columns, [int]$CardWidth, [int]$CardHeight) {
    $rows = [int][Math]::Ceiling($Records.Count / $Columns)
    $headerHeight = 76
    $bitmap = New-Object System.Drawing.Bitmap ($Columns * $CardWidth), ($headerHeight + $rows * $CardHeight)
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
        $graphics.DrawString($Title, $titleFont, $labelBrush, 18, 12)
        $graphics.DrawString('Arquivo final atual - revisao humana pendente; integridade tecnica nao e aprovacao artistica.', $metaFont, $mutedBrush, 20, 47)
        for ($index = 0; $index -lt $Records.Count; $index++) {
            $record = $Records[$index]
            $column = $index % $Columns
            $row = [int][Math]::Floor($index / $Columns)
            $x = $column * $CardWidth
            $y = $headerHeight + $row * $CardHeight
            $graphics.FillRectangle($cardBrush, $x + 6, $y + 6, $CardWidth - 12, $CardHeight - 12)
            $label = if ($record.asset_id) { $record.asset_id } else { $record.final_path }
            $graphics.DrawString($label, $cardTitleFont, $labelBrush, $x + 16, $y + 15)
            $hash = if ($record.actual_sha256) { $record.actual_sha256.Substring(0, 12) } else { $record.final_sha256.Substring(0, 12) }
            $dimensions = if ($record.actual_dimensions) { $record.actual_dimensions } else { $record.dimensions }
            $graphics.DrawString("$dimensions | sha256:$hash", $metaFont, $mutedBrush, $x + 16, $y + 40)

            $imagePath = Join-Path $ProjectRoot $record.final_path
            $image = [System.Drawing.Image]::FromFile($imagePath)
            try {
                $area = [System.Drawing.Rectangle]::new($x + 16, $y + 62, $CardWidth - 32, $CardHeight - 78)
                $checker = 16
                for ($cy = $area.Y; $cy -lt $area.Bottom; $cy += $checker) {
                    for ($cx = $area.X; $cx -lt $area.Right; $cx += $checker) {
                        $isLight = (([int](($cx - $area.X) / $checker) + [int](($cy - $area.Y) / $checker)) % 2) -eq 0
                        $graphics.FillRectangle($(if ($isLight) { $checkA } else { $checkB }), $cx, $cy, $checker, $checker)
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
        $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $checkB.Dispose(); $checkA.Dispose(); $cardBrush.Dispose(); $mutedBrush.Dispose(); $labelBrush.Dispose()
        $cardTitleFont.Dispose(); $metaFont.Dispose(); $titleFont.Dispose(); $graphics.Dispose(); $bitmap.Dispose()
    }
}

$assetAudit = Get-Content -Raw -LiteralPath $assetAuditPath | ConvertFrom-Json
$heroAudit = Get-Content -Raw -LiteralPath $heroAuditPath | ConvertFrom-Json
$nyreliaOrder = @('idle', 'move_n', 'move_ne', 'move_e', 'move_se', 'move_s', 'attack', 'active', 'death')
$nyrelia = @($heroAudit.nyrelia_critical_review | Sort-Object { $nyreliaOrder.IndexOf($_.sequence) })
$propsOrder = @('rocha_01', 'rocha_02', 'rocha_03', 'pilar_abissal_01', 'pilar_abissal_02', 'pilar_abissal_03')
$props = @($assetAudit.critical_review | Sort-Object { $propsOrder.IndexOf($_.asset_id) })

$nyreliaPath = Join-Path $outputDirectory 'SPEC-044-nyrelia-final-review.png'
$propsPath = Join-Path $outputDirectory 'SPEC-044-props-abissais-final-review.png'
New-Board $nyrelia 'SPEC-044 / Nyrelia - 9 strips finais' $nyreliaPath 3 640 300
New-Board $props 'SPEC-044 / Props abissais - 6 arquivos finais' $propsPath 3 460 440

Write-Output "nyrelia=$nyreliaPath"
Write-Output "props=$propsPath"
