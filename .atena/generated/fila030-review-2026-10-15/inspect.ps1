$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$taskRoot = (Resolve-Path (Join-Path $PSScriptRoot '../../..')).Path
$sourceDir = Join-Path $taskRoot '.atena/generated/art-candidates/nevoa-mundo'
$report = @()
foreach ($code in @('NB01','NB02')) {
    $source = Join-Path $sourceDir ($code + '_v01.png')
    $bitmap = [System.Drawing.Bitmap]::new($source)
    $seam = 0.0; $maxSeam = 0
    for ($y = 0; $y -lt $bitmap.Height; $y++) {
        $delta = [Math]::Abs([int]$bitmap.GetPixel(0,$y).R - [int]$bitmap.GetPixel($bitmap.Width-1,$y).R)
        $seam += $delta
        $maxSeam = [Math]::Max($maxSeam,$delta)
    }
    $colorDeviation = 0; $topMax = 0
    for ($y = 0; $y -lt $bitmap.Height; $y += 8) {
        for ($x = 0; $x -lt $bitmap.Width; $x += 8) {
            $pixel = $bitmap.GetPixel($x,$y)
            $colorDeviation = [Math]::Max($colorDeviation, [Math]::Max([Math]::Abs([int]$pixel.R-[int]$pixel.G),[Math]::Abs([int]$pixel.R-[int]$pixel.B)))
            if ($y -lt [int]($bitmap.Height/4)) { $topMax = [Math]::Max($topMax,[int]$pixel.R) }
        }
    }
    $report += [ordered]@{code=$code; revision='v01'; width=$bitmap.Width; height=$bitmap.Height; sha256=(Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash; edge_red_mean_abs_difference=($seam/$bitmap.Height); edge_red_max_abs_difference=$maxSeam; rgb_deviation_sample_grid_8=$colorDeviation; top_quarter_max_red_sample_grid_8=$topMax; source_preserved=$true}
    if ($code -eq 'NB01') {
        $height = [int][Math]::Round($bitmap.Height * 512.0 / $bitmap.Width)
        $preview = [System.Drawing.Bitmap]::new(1536,$height)
        $graphics = [System.Drawing.Graphics]::FromImage($preview)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
        for ($tile=0;$tile -lt 3;$tile++) { $graphics.DrawImage($bitmap,[System.Drawing.Rectangle]::new($tile*512,0,512,$height)) }
        $preview.Save((Join-Path $PSScriptRoot 'NB01-repeat-3x1.png'),[System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose(); $preview.Dispose()
    } else {
        foreach ($depth in @(80,360)) {
            $preview = [System.Drawing.Bitmap]::new(1280,$depth)
            $graphics = [System.Drawing.Graphics]::FromImage($preview)
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
            $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
            $graphics.DrawImage($bitmap,[System.Drawing.Rectangle]::new(0,0,1280,$depth))
            $preview.Save((Join-Path $PSScriptRoot ('NB02-depth-'+$depth+'.png')),[System.Drawing.Imaging.ImageFormat]::Png)
            $graphics.Dispose(); $preview.Dispose()
        }
    }
    $bitmap.Dispose()
}
$report | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $PSScriptRoot 'inspection.json') -Encoding UTF8
$report | ConvertTo-Json -Depth 5
