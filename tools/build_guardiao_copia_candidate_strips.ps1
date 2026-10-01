[CmdletBinding()]
param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [switch]$PlanOnly
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$ProjectRoot = [System.IO.Path]::GetFullPath($ProjectRoot)
$manifestRelative = '.atena/generated/CANDIDATES-MANIFEST-003.json'
$qaRelative = '.atena/evidence/EVID-136-ciclo-guardiao-copia-qa-2026-09-30.json'
$manifestPath = Join-Path $ProjectRoot $manifestRelative
$qaPath = Join-Path $ProjectRoot $qaRelative
$outputRelative = '.atena/generated/art-candidates/enemies-wave-1/guardiao_copia/strips'
$outputPath = Join-Path $ProjectRoot $outputRelative
$stagingPath = "$outputPath.__staging"
$cellWidth = 320
$cellHeight = 480
$stateOrder = @('idle', 'move', 'attack', 'death', 'special')
$expectedCounts = @{ idle = 4; move = 6; attack = 4; death = 6; special = 6 }
$stripNames = @('idle.png', 'move.png', 'attack.png', 'death.png', 'special.png')
$reportName = 'QA-guardiao_copia-strips.json'
$contactName = 'QA-guardiao_copia-contact-sheet.png'

function Get-ArgbImageData([string]$Path) {
    $bitmap = [System.Drawing.Bitmap]::FromFile($Path)
    try {
        if ($bitmap.Width -ne $cellWidth -or $bitmap.Height -ne $cellHeight) {
            throw "Dimensão fora do contrato em '$Path': $($bitmap.Width)x$($bitmap.Height)."
        }
        $rect = [System.Drawing.Rectangle]::new(0, 0, $bitmap.Width, $bitmap.Height)
        $data = $bitmap.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $rowBytes = $bitmap.Width * 4
            $bytes = New-Object byte[] ($rowBytes * $bitmap.Height)
            for ($row = 0; $row -lt $bitmap.Height; $row++) {
                $rowPointer = [System.IntPtr]::Add($data.Scan0, $row * $data.Stride)
                [System.Runtime.InteropServices.Marshal]::Copy($rowPointer, $bytes, $row * $rowBytes, $rowBytes)
            }
        }
        finally {
            $bitmap.UnlockBits($data)
        }
        $sha = [System.Security.Cryptography.SHA256]::Create()
        try {
            $pixelHash = [System.BitConverter]::ToString($sha.ComputeHash($bytes)).Replace('-', '').ToLowerInvariant()
        }
        finally {
            $sha.Dispose()
        }
        return [PSCustomObject]@{ Width = $bitmap.Width; Height = $bitmap.Height; Bytes = $bytes; PixelHash = $pixelHash }
    }
    finally {
        $bitmap.Dispose()
    }
}

function Get-ByteArraySha256([byte[]]$Bytes) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
        return [System.BitConverter]::ToString($sha.ComputeHash($Bytes)).Replace('-', '').ToLowerInvariant()
    }
    finally {
        $sha.Dispose()
    }
}

function Save-ArgbPng([byte[]]$Bytes, [int]$Width, [int]$Height, [string]$Path) {
    $bitmap = [System.Drawing.Bitmap]::new($Width, $Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    try {
        $rect = [System.Drawing.Rectangle]::new(0, 0, $Width, $Height)
        $data = $bitmap.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::WriteOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $rowBytes = $Width * 4
            for ($row = 0; $row -lt $Height; $row++) {
                $rowPointer = [System.IntPtr]::Add($data.Scan0, $row * $data.Stride)
                [System.Runtime.InteropServices.Marshal]::Copy($Bytes, $row * $rowBytes, $rowPointer, $rowBytes)
            }
        }
        finally {
            $bitmap.UnlockBits($data)
        }
        $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $bitmap.Dispose()
    }
}

function New-ContactSheet([object[]]$Frames, [string]$Path) {
    $previewCellWidth = 160
    $previewCellHeight = 240
    $labelHeight = 24
    $gutter = 8
    $rowWidth = 6 * ($previewCellWidth + $gutter) + $gutter
    $rowHeight = $previewCellHeight + $labelHeight + 2 * $gutter
    $sheetWidth = $rowWidth + 2 * $gutter
    $sheetHeight = $stateOrder.Count * $rowHeight + 2 * $gutter
    $sheet = [System.Drawing.Bitmap]::new($sheetWidth, $sheetHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($sheet)
    $font = [System.Drawing.Font]::new('Segoe UI', 10)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)
    try {
        $graphics.Clear([System.Drawing.Color]::FromArgb(32, 32, 32))
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
        $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
        $groups = @($Frames | Group-Object State)
        for ($rowIndex = 0; $rowIndex -lt $stateOrder.Count; $rowIndex++) {
            $stateName = $stateOrder[$rowIndex]
            $stateFrames = @($Frames | Where-Object { $_.State -eq $stateName } | Sort-Object Index)
            for ($frameIndex = 0; $frameIndex -lt $stateFrames.Count; $frameIndex++) {
                $frame = $stateFrames[$frameIndex]
                $x = $gutter + $frameIndex * ($previewCellWidth + $gutter)
                $y = $gutter + $rowIndex * $rowHeight
                $graphics.DrawString("$stateName $($frame.Index.ToString('00'))", $font, $brush, [float]$x, [float]$y)
                $imageX = $x
                $imageY = $y + $labelHeight
                for ($checkY = 0; $checkY -lt $previewCellHeight; $checkY += 12) {
                    for ($checkX = 0; $checkX -lt $previewCellWidth; $checkX += 12) {
                        $shade = if (([int]($checkX / 12) + [int]($checkY / 12)) % 2 -eq 0) { 68 } else { 96 }
                        $graphics.FillRectangle([System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb($shade, $shade, $shade)), $imageX + $checkX, $imageY + $checkY, 12, 12)
                    }
                }
                $source = [System.Drawing.Bitmap]::FromFile($frame.FullPath)
                try {
                    $destination = [System.Drawing.Rectangle]::new($imageX, $imageY, $previewCellWidth, $previewCellHeight)
                    $graphics.DrawImage($source, $destination, 0, 0, $cellWidth, $cellHeight, [System.Drawing.GraphicsUnit]::Pixel)
                }
                finally {
                    $source.Dispose()
                }
            }
        }
        $sheet.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $brush.Dispose()
        $font.Dispose()
        $graphics.Dispose()
        $sheet.Dispose()
    }
}

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { throw "Manifesto ausente: $manifestRelative" }
if (-not (Test-Path -LiteralPath $qaPath -PathType Leaf)) { throw "QA de origem ausente: $qaRelative" }
$manifestText = [System.IO.File]::ReadAllText($manifestPath, [System.Text.Encoding]::UTF8)
$manifest = ConvertFrom-Json -InputObject $manifestText
$target = @($manifest.targets | Where-Object { $_.id -eq 'guardiao_copia' }) | Select-Object -First 1
if ($null -eq $target) { throw 'guardiao_copia não consta no manifesto.' }
$cycle = $target.variant_cycle
if ($cycle.expected_frames -ne 26 -or $cycle.owner_approved -ne $true -or $cycle.generation_authorized -ne $true) {
    throw 'O ciclo não satisfaz os gates de contagem, geração e aprovação registrados no manifesto.'
}
$qaDocument = ConvertFrom-Json -InputObject ([System.IO.File]::ReadAllText($qaPath, [System.Text.Encoding]::UTF8))
if ($qaDocument.count -ne 26 -or @($qaDocument.frames).Count -ne 26) { throw 'EVID-136 não contém exatamente 26 registros de quadros.' }
$qaByPath = @{}
foreach ($qaFrame in @($qaDocument.frames)) {
    $qaByPath[[string]$qaFrame.path] = [string]$qaFrame.sha256
}

$frameMap = @{}
foreach ($frame in @($cycle.frames)) {
    if ($frameMap.ContainsKey([string]$frame.state)) { throw "Estado duplicado no manifesto: $($frame.state)" }
    $frameMap[[string]$frame.state] = [string]$frame.candidate
}
$pilotMap = @{}
foreach ($frame in @($target.variant_pilot.files)) {
    if ($pilotMap.ContainsKey([string]$frame.state)) { throw "Estado piloto duplicado: $($frame.state)" }
    $pilotMap[[string]$frame.state] = [string]$frame.path
}

$candidateRoot = Join-Path $ProjectRoot ([string]$manifest.root)
$frameRoster = New-Object System.Collections.Generic.List[object]
foreach ($stateName in $stateOrder) {
    $stateFrames = @($cycle.states.$stateName)
    if ($stateFrames.Count -ne $expectedCounts[$stateName]) { throw "Contagem incorreta em '$stateName': $($stateFrames.Count)." }
    for ($index = 0; $index -lt $stateFrames.Count; $index++) {
        $frameId = [string]$stateFrames[$index]
        if ($frameMap.ContainsKey($frameId)) { $relativeSource = $frameMap[$frameId] }
        elseif ($pilotMap.ContainsKey($frameId)) { $relativeSource = $pilotMap[$frameId] }
        else { throw "Fonte ausente para o quadro aprovado '$frameId'." }
        $fullSource = Join-Path $candidateRoot $relativeSource
        if (-not (Test-Path -LiteralPath $fullSource -PathType Leaf)) { throw "Fonte aprovada ausente: $relativeSource" }
        $manifestRelativeSource = ($manifest.root.TrimEnd('/') + '/' + $relativeSource.Replace('\', '/'))
        if (-not $qaByPath.ContainsKey($manifestRelativeSource)) { throw "Fonte '$manifestRelativeSource' não está registrada em EVID-136." }
        $sourceHash = (Get-FileHash -LiteralPath $fullSource -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($sourceHash -ne $qaByPath[$manifestRelativeSource].ToLowerInvariant()) { throw "Hash divergente de EVID-136 em '$manifestRelativeSource'." }
        $imageData = Get-ArgbImageData $fullSource
        $frameRoster.Add([PSCustomObject]@{
            State = $stateName
            Index = $index
            FrameId = $frameId
            RelativePath = $manifestRelativeSource
            FullPath = $fullSource
            FileSha256 = $sourceHash
            DecodedPixelSha256 = $imageData.PixelHash
            PixelBytes = $imageData.Bytes
        })
    }
}
if ($frameRoster.Count -ne 26 -or $frameMap.Count + $pilotMap.Count -ne 26) { throw 'O roster combinado não resulta em 26 quadros únicos.' }

$outputFiles = @($stripNames + $reportName + $contactName)
$existingOutputs = @()
foreach ($name in $outputFiles) {
    if (Test-Path -LiteralPath (Join-Path $outputPath $name)) { $existingOutputs += (Join-Path $outputPath $name) }
}
$existingStage = Test-Path -LiteralPath $stagingPath
$existingOutputContent = if (Test-Path -LiteralPath $outputPath -PathType Container) { @(Get-ChildItem -LiteralPath $outputPath -Force) } else { @() }
if ($existingOutputs.Count -gt 0 -or $existingStage -or ($existingOutputContent.Count -gt 0)) {
    throw "Saída ou staging já existe; nada será sobrescrito. Revise manualmente: $outputPath"
}

$plan = [PSCustomObject]@{
    mode = if ($PlanOnly) { 'read_only_plan' } else { 'generate_candidate_strips' }
    project_root = $ProjectRoot
    manifest = $manifestRelative
    manifest_sha256 = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash.ToLowerInvariant()
    source_qa = $qaRelative
    source_qa_sha256 = (Get-FileHash -LiteralPath $qaPath -Algorithm SHA256).Hash.ToLowerInvariant()
    source_frame_count = $frameRoster.Count
    state_counts = $expectedCounts
    cell = @($cellWidth, $cellHeight)
    output_directory = $outputPath
    planned_outputs = @($outputFiles | ForEach-Object { Join-Path $outputPath $_ })
    overwrite = $false
}
if ($PlanOnly) {
    $plan | ConvertTo-Json -Depth 8
    return
}

[System.IO.Directory]::CreateDirectory($stagingPath) | Out-Null
$outputReportFrames = New-Object System.Collections.Generic.List[object]
$outputReportStrips = New-Object System.Collections.Generic.List[object]
foreach ($stateName in $stateOrder) {
    $stateFrames = @($frameRoster | Where-Object { $_.State -eq $stateName } | Sort-Object Index)
    $stripWidth = $cellWidth * $stateFrames.Count
    $stripBytes = New-Object byte[] ($stripWidth * $cellHeight * 4)
    $rowBytes = $cellWidth * 4
    for ($frameIndex = 0; $frameIndex -lt $stateFrames.Count; $frameIndex++) {
        $frame = $stateFrames[$frameIndex]
        for ($row = 0; $row -lt $cellHeight; $row++) {
            $sourceOffset = $row * $rowBytes
            $destinationOffset = ($row * $stripWidth * 4) + ($frameIndex * $rowBytes)
            [Array]::Copy($frame.PixelBytes, $sourceOffset, $stripBytes, $destinationOffset, $rowBytes)
        }
    }
    $stripPath = Join-Path $stagingPath "$stateName.png"
    Save-ArgbPng $stripBytes $stripWidth $cellHeight $stripPath
    $savedImage = [System.Drawing.Bitmap]::FromFile($stripPath)
    try {
        $savedRect = [System.Drawing.Rectangle]::new(0, 0, $savedImage.Width, $savedImage.Height)
        $savedData = $savedImage.LockBits($savedRect, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $savedBytes = New-Object byte[] ($stripWidth * $cellHeight * 4)
            for ($row = 0; $row -lt $cellHeight; $row++) {
                $rowPointer = [System.IntPtr]::Add($savedData.Scan0, $row * $savedData.Stride)
                [System.Runtime.InteropServices.Marshal]::Copy($rowPointer, $savedBytes, $row * $stripWidth * 4, $stripWidth * 4)
            }
        }
        finally {
            $savedImage.UnlockBits($savedData)
        }
    }
    finally {
        $savedImage.Dispose()
    }
    if ($savedImage.Width -ne $stripWidth -or $savedImage.Height -ne $cellHeight) { throw "Dimensão errada na tira '$stateName'." }
    for ($frameIndex = 0; $frameIndex -lt $stateFrames.Count; $frameIndex++) {
        $frame = $stateFrames[$frameIndex]
        $cellBytes = New-Object byte[] ($cellWidth * $cellHeight * 4)
        for ($row = 0; $row -lt $cellHeight; $row++) {
            $sourceOffset = ($row * $stripWidth * 4) + ($frameIndex * $rowBytes)
            $destinationOffset = $row * $rowBytes
            [Array]::Copy($savedBytes, $sourceOffset, $cellBytes, $destinationOffset, $rowBytes)
        }
        $cellHash = Get-ByteArraySha256 $cellBytes
        if ($cellHash -ne $frame.DecodedPixelSha256) { throw "Pixels decodificados divergentes na célula $($frame.FrameId)." }
        $outputReportFrames.Add([PSCustomObject]@{
            state = $stateName
            index = $frame.Index
            frame_id = $frame.FrameId
            source_path = $frame.RelativePath
            source_file_sha256 = $frame.FileSha256
            source_decoded_pixel_sha256 = $frame.DecodedPixelSha256
            output_cell_decoded_pixel_sha256 = $cellHash
            decoded_pixels_identical = $true
        })
    }
    $stripFileHash = (Get-FileHash -LiteralPath $stripPath -Algorithm SHA256).Hash.ToLowerInvariant()
    $outputReportStrips.Add([PSCustomObject]@{
        state = $stateName
        frame_count = $stateFrames.Count
        width = $stripWidth
        height = $cellHeight
        path = "$outputRelative/$stateName.png"
        sha256 = $stripFileHash
        all_cells_pixel_identical = $true
    })
}

$contactPath = Join-Path $stagingPath $contactName
New-ContactSheet $frameRoster.ToArray() $contactPath
$report = [PSCustomObject]@{
    id = 'QA-guardiao-copia-strips-001'
    generated_utc = [DateTime]::UtcNow.ToString('o')
    source_manifest = $manifestRelative
    source_manifest_sha256 = $plan.manifest_sha256
    source_evidence = $qaRelative
    source_evidence_sha256 = $plan.source_qa_sha256
    enemy_id = 'guardiao_copia'
    cell = @($cellWidth, $cellHeight)
    source_frame_count = $frameRoster.Count
    method = 'byte-row copy of decoded Format32bppArgb cells; no crop, scale, reposition, flip, recolor, or redraw'
    strips = $outputReportStrips.ToArray()
    frames = $outputReportFrames.ToArray()
    visual_contact_sheet = "$outputRelative/$contactName"
    status = 'all 26 output cells match their approved source pixels'
}
$reportPath = Join-Path $stagingPath $reportName
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($reportPath, ($report | ConvertTo-Json -Depth 8), $utf8NoBom)

[System.IO.Directory]::Move($stagingPath, $outputPath)
$finalSummary = [PSCustomObject]@{
    status = 'candidate_strips_created_and_pixel_verified'
    output_directory = $outputPath
    strips = $outputReportStrips.ToArray()
    source_frames = $frameRoster.Count
    report = (Join-Path $outputPath $reportName)
    contact_sheet = (Join-Path $outputPath $contactName)
}
$finalSummary | ConvertTo-Json -Depth 8
