param(
    [string]$ProjectRoot = (Get-Location).Path,
    [string]$OutputPath = '.atena/evidence/EVID-103-zumbi-animacoes-candidatas-2026-09-29.png'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$groups = @(
    @{ Name = 'IDLE'; Frames = @(
        'candidates/idle/zumbi_idle_00_identity_v01.png',
        'candidates/idle/zumbi_idle_01_v01.png',
        'candidates/idle/zumbi_idle_02_v01.png',
        'candidates/idle/zumbi_idle_03_v01.png'
    ) },
    @{ Name = 'CAMINHADA'; Frames = @(
        'candidates/move/zumbi_move_00_v02.png',
        'candidates/move/zumbi_move_01_v02.png',
        'candidates/move/zumbi_move_02_v02.png',
        'candidates/move/zumbi_move_03_v02.png',
        'candidates/move/zumbi_move_04_v02.png',
        'candidates/move/zumbi_move_05_v02.png'
    ) },
    @{ Name = 'ATAQUE'; Frames = @(
        'candidates/attack/zumbi_attack_00_v01.png',
        'candidates/attack/zumbi_attack_01_v01.png',
        'candidates/attack/zumbi_attack_02_v01.png',
        'candidates/attack/zumbi_attack_03_v01.png'
    ) },
    @{ Name = 'MORTE'; Frames = @(
        'candidates/death/zumbi_death_00_v01.png',
        'candidates/death/zumbi_death_01_v01.png',
        'candidates/death/zumbi_death_02_v01.png',
        'candidates/death/zumbi_death_03_v01.png',
        'candidates/death/zumbi_death_04_v02.png',
        'candidates/death/zumbi_death_05_v01.png'
    ) }
)

$columns = 6; $cellWidth = 256; $cellHeight = 268; $headerHeight = 72
$canvas = [System.Drawing.Bitmap]::new($columns * $cellWidth, $headerHeight + $groups.Count * $cellHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.Clear([System.Drawing.Color]::FromArgb(21, 24, 31))
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::None
$titleFont = [System.Drawing.Font]::new('Segoe UI', 18, [System.Drawing.FontStyle]::Bold)
$groupFont = [System.Drawing.Font]::new('Consolas', 9, [System.Drawing.FontStyle]::Bold)
$frameFont = [System.Drawing.Font]::new('Consolas', 8)
$titleBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(239, 232, 219))
$groupBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(175, 199, 230))
$frameBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(222, 225, 232))
$cardBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(36, 43, 55))
$checkA = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(52, 59, 71))
$checkB = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(43, 49, 59))

try {
    $graphics.DrawString('ZUMBI v01 / candidatos de animacao - revisao humana', $titleFont, $titleBrush, 18, 16)
    for ($row = 0; $row -lt $groups.Count; $row++) {
        $group = $groups[$row]
        for ($column = 0; $column -lt $columns; $column++) {
            $x = $column * $cellWidth; $y = $headerHeight + $row * $cellHeight
            $graphics.FillRectangle($cardBrush, $x + 4, $y + 4, $cellWidth - 8, $cellHeight - 8)
            if ($column -eq 0) { $graphics.DrawString($group.Name, $groupFont, $groupBrush, $x + 10, $y + 9) }
            if ($column -ge $group.Frames.Count) { continue }
            $frame = $group.Frames[$column]
            $graphics.DrawString(('frame {0}' -f $column), $frameFont, $frameBrush, $x + 10, $y + 31)
            $area = [System.Drawing.Rectangle]::new($x + 10, $y + 49, $cellWidth - 20, $cellHeight - 60)
            for ($cy = $area.Y; $cy -lt $area.Bottom; $cy += 16) { for ($cx = $area.X; $cx -lt $area.Right; $cx += 16) {
                $brush = if (((([int](($cx - $area.X) / 16)) + ([int](($cy - $area.Y) / 16))) % 2) -eq 0) { $checkA } else { $checkB }
                $graphics.FillRectangle($brush, $cx, $cy, 16, 16)
            } }
            $image = [System.Drawing.Image]::FromFile((Join-Path $ProjectRoot (Join-Path '.atena/generated/zumbi-regeneration/v01' $frame)))
            try {
                $scale = [Math]::Min($area.Width / [double]$image.Width, $area.Height / [double]$image.Height)
                $width = [int]($image.Width * $scale); $height = [int]($image.Height * $scale)
                $graphics.DrawImage($image, $area.X + [int](($area.Width - $width) / 2), $area.Y + [int](($area.Height - $height) / 2), $width, $height)
            } finally { $image.Dispose() }
        }
    }
    $target = Join-Path $ProjectRoot $OutputPath
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
    $canvas.Save($target, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Output "board=$target"
}
finally {
    $checkB.Dispose(); $checkA.Dispose(); $cardBrush.Dispose(); $frameBrush.Dispose(); $groupBrush.Dispose(); $titleBrush.Dispose()
    $frameFont.Dispose(); $groupFont.Dispose(); $titleFont.Dispose(); $graphics.Dispose(); $canvas.Dispose()
}
