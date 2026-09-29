param(
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$OutputDir = '.atena/generated/zumbi-regeneration/v01/strips',
    [int]$CellWidth = 256,
    [int]$CellHeight = 384,
    [int]$Padding = 8
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$states = [ordered]@{
    idle = @('candidates/idle/zumbi_idle_00_identity_v01.png', 'candidates/idle/zumbi_idle_01_v01.png', 'candidates/idle/zumbi_idle_02_v01.png', 'candidates/idle/zumbi_idle_03_v01.png')
    move = @('candidates/move/zumbi_move_00_v02.png', 'candidates/move/zumbi_move_01_v02.png', 'candidates/move/zumbi_move_02_v02.png', 'candidates/move/zumbi_move_03_v02.png', 'candidates/move/zumbi_move_04_v02.png', 'candidates/move/zumbi_move_05_v02.png')
    attack = @('candidates/attack/zumbi_attack_00_v01.png', 'candidates/attack/zumbi_attack_01_v01.png', 'candidates/attack/zumbi_attack_02_v01.png', 'candidates/attack/zumbi_attack_03_v01.png')
    death = @('candidates/death/zumbi_death_00_v01.png', 'candidates/death/zumbi_death_01_v01.png', 'candidates/death/zumbi_death_02_v01.png', 'candidates/death/zumbi_death_03_v01.png', 'candidates/death/zumbi_death_04_v02.png', 'candidates/death/zumbi_death_05_v01.png')
}

function Get-AlphaBounds([System.Drawing.Bitmap]$Bitmap) {
    $rect = [System.Drawing.Rectangle]::new(0, 0, $Bitmap.Width, $Bitmap.Height)
    $data = $Bitmap.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        $bytes = New-Object byte[] ([Math]::Abs($data.Stride) * $Bitmap.Height)
        [System.Runtime.InteropServices.Marshal]::Copy($data.Scan0, $bytes, 0, $bytes.Length)
        $minX = $Bitmap.Width; $minY = $Bitmap.Height; $maxX = -1; $maxY = -1
        for ($y = 0; $y -lt $Bitmap.Height; $y++) {
            for ($x = 0; $x -lt $Bitmap.Width; $x++) {
                if ($bytes[$y * [Math]::Abs($data.Stride) + $x * 4 + 3] -gt 8) {
                    if ($x -lt $minX) { $minX = $x }; if ($x -gt $maxX) { $maxX = $x }
                    if ($y -lt $minY) { $minY = $y }; if ($y -gt $maxY) { $maxY = $y }
                }
            }
        }
        if ($maxX -lt $minX -or $maxY -lt $minY) { throw 'candidate has no opaque pixels' }
        return [System.Drawing.Rectangle]::new($minX, $minY, $maxX - $minX + 1, $maxY - $minY + 1)
    }
    finally { $Bitmap.UnlockBits($data) }
}

$candidateRoot = Join-Path $ProjectRoot '.atena/generated/zumbi-regeneration/v01'
$targetRoot = Join-Path $ProjectRoot $OutputDir
New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null
$report = @()
foreach ($state in $states.Keys) {
    $frames = $states[$state]
    $strip = [System.Drawing.Bitmap]::new($CellWidth * $frames.Count, $CellHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($strip)
    try {
        $graphics.Clear([System.Drawing.Color]::Transparent)
        $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
        for ($index = 0; $index -lt $frames.Count; $index++) {
            $sourcePath = Join-Path $candidateRoot $frames[$index]
            $source = [System.Drawing.Bitmap]::FromFile($sourcePath)
            try {
                $bounds = Get-AlphaBounds $source
                $availableWidth = $CellWidth - 2 * $Padding; $availableHeight = $CellHeight - 2 * $Padding
                $scale = [Math]::Min($availableWidth / [double]$bounds.Width, $availableHeight / [double]$bounds.Height)
                $width = [int][Math]::Round($bounds.Width * $scale); $height = [int][Math]::Round($bounds.Height * $scale)
                $x = $index * $CellWidth + [int][Math]::Floor(($CellWidth - $width) / 2)
                $y = $CellHeight - $Padding - $height
                $graphics.DrawImage($source, [System.Drawing.Rectangle]::new($x, $y, $width, $height), $bounds, [System.Drawing.GraphicsUnit]::Pixel)
            }
            finally { $source.Dispose() }
        }
        $outputPath = Join-Path $targetRoot "$state.png"
        $strip.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $report += [PSCustomObject]@{ state = $state; frames = $frames.Count; path = $outputPath; dimensions = "$( $strip.Width )x$( $strip.Height )" }
    }
    finally { $graphics.Dispose(); $strip.Dispose() }
}
$report
