$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$candidateRoot = (Resolve-Path ".atena/generated/art-candidates/enemies-wave-1").Path
$evidenceRoot = (Resolve-Path ".atena/evidence").Path
$targets = @(
    @{
        id = "tentaculo_kraken"
        title = "TENTACULO KRAKEN - LOTE C"
        rows = @(@{ state = "IDLE"; count = 4 }, @{ state = "ATTACK"; count = 4 }, @{ state = "DEATH"; count = 6 })
    },
    @{
        id = "guardiao_verdadeiro"
        title = "GUARDIAO VERDADEIRO - LOTE C"
        rows = @(@{ state = "IDLE"; count = 4 }, @{ state = "MOVE"; count = 6 }, @{ state = "ATTACK"; count = 4 }, @{ state = "DEATH"; count = 6 }, @{ state = "SPECIAL"; count = 6 })
    }
)

foreach ($target in $targets) {
    $width = 1380
    $headerHeight = 82
    $rowHeight = 310
    $height = $headerHeight + $rowHeight * $target.rows.Count + 4
    $board = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($board)
    $graphics.Clear([System.Drawing.Color]::FromArgb(22, 23, 30))
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $titleFont = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
    $stateFont = New-Object System.Drawing.Font("Segoe UI", 15, [System.Drawing.FontStyle]::Bold)
    $cellFont = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $graphics.DrawString($target.title, $titleFont, [System.Drawing.Brushes]::White, 22, 18)
    $graphics.DrawString("Quadros individuais - identidade aprovada incluida - transparencia em xadrez", $cellFont, [System.Drawing.Brushes]::Gainsboro, 24, 53)

    for ($rowIndex = 0; $rowIndex -lt $target.rows.Count; $rowIndex++) {
        $row = $target.rows[$rowIndex]
        $rowTop = $headerHeight + $rowIndex * $rowHeight
        $graphics.FillRectangle([System.Drawing.Brushes]::DimGray, 0, $rowTop, $width, 24)
        $graphics.DrawString($row.state, $stateFont, [System.Drawing.Brushes]::White, 20, $rowTop + 2)

        for ($frameIndex = 0; $frameIndex -lt 6; $frameIndex++) {
            $cellX = 10 + $frameIndex * 228
            $cellY = $rowTop + 25
            for ($checkY = 0; $checkY -lt 270; $checkY += 16) {
                for ($checkX = 0; $checkX -lt 204; $checkX += 16) {
                    if (([int]($checkX / 16) + [int]($checkY / 16)) % 2 -eq 0) {
                        $color = [System.Drawing.Color]::FromArgb(48, 49, 59)
                    } else {
                        $color = [System.Drawing.Color]::FromArgb(70, 71, 82)
                    }
                    $checkerBrush = New-Object System.Drawing.SolidBrush($color)
                    $graphics.FillRectangle($checkerBrush, $cellX + $checkX, $cellY + $checkY, 16, 16)
                    $checkerBrush.Dispose()
                }
            }

            if ($frameIndex -lt $row.count) {
                $indexText = "{0:D2}" -f $frameIndex
                $version = if ($row.state -eq "DEATH" -and $frameIndex -eq 5) { "v02" } else { "v01" }
                $frameName = $target.id + "_" + $row.state.ToLowerInvariant() + "_" + $indexText + "_" + $version + ".png"
                $framePath = Join-Path $candidateRoot (Join-Path $target.id (Join-Path "frames" $frameName))
                if (-not (Test-Path $framePath)) { throw "Missing frame: $framePath" }

                $sprite = [System.Drawing.Image]::FromFile($framePath)
                $scale = [Math]::Min(180.0 / $sprite.Width, 270.0 / $sprite.Height)
                $drawWidth = [Math]::Max(1, [int][Math]::Round($sprite.Width * $scale))
                $drawHeight = [Math]::Max(1, [int][Math]::Round($sprite.Height * $scale))
                $drawX = $cellX + [int]((204 - $drawWidth) / 2)
                $drawY = $cellY + [int]((270 - $drawHeight) / 2)
                $graphics.DrawImage($sprite, $drawX, $drawY, $drawWidth, $drawHeight)
                $sprite.Dispose()
                $graphics.DrawString($row.state.ToLowerInvariant() + "_" + $indexText, $cellFont, [System.Drawing.Brushes]::White, $cellX + 8, $rowTop + 294)
            }
        }
    }

    $outputPath = Join-Path $evidenceRoot ("EVID-134-lote-c-" + $target.id + "-2026-09-30.png")
    $board.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $board.Dispose()
    $titleFont.Dispose()
    $stateFont.Dispose()
    $cellFont.Dispose()
    Write-Output ($outputPath + " " + (Get-Item $outputPath).Length + " bytes " + $width + "x" + $height)
}
