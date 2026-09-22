param(
    [string]$ManifestPath = ".atena/generated/ASSET-PRODUCTION-MANIFEST-001.json",
    [string]$IconPath = "icon.svg"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

function Get-Sha256([string]$Path) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $stream = [System.IO.File]::OpenRead((Resolve-Path -LiteralPath $Path).Path)
    try {
        return ([System.BitConverter]::ToString($sha.ComputeHash($stream))).Replace("-", "").ToLowerInvariant()
    } finally {
        $stream.Dispose()
        $sha.Dispose()
    }
}

$manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()
$checked = 0
$alphaChecked = 0

foreach ($entry in $manifest.entries) {
    $label = "$($entry.family)/$($entry.asset_id)"
    if ($entry.status -ne "integrated") {
        $errors.Add("$label status=$($entry.status)")
        continue
    }
    if (-not (Test-Path -LiteralPath $entry.final_path)) {
        $errors.Add("$label missing $($entry.final_path)")
        continue
    }

    $expectedDimensions = [string]$entry.dimensions
    $expectsAlpha = [bool]$entry.alpha
    if ([string]::IsNullOrWhiteSpace($expectedDimensions) -and $entry.generation_mode -eq "alias") {
        $sourceEntry = @($manifest.entries | Where-Object { $_.final_path -eq $entry.source_path }) | Select-Object -First 1
        if ($null -ne $sourceEntry) {
            $expectedDimensions = [string]$sourceEntry.dimensions
            $expectsAlpha = [bool]$sourceEntry.alpha
        }
    }
    $expected = $expectedDimensions.Split("x")
    $resolvedImagePath = (Resolve-Path -LiteralPath $entry.final_path).Path
    $image = [System.Drawing.Bitmap]::new($resolvedImagePath)
    try {
        if ($expected.Count -ne 2) {
            $errors.Add("$label has no usable dimensions metadata")
        } elseif ($image.Width -ne [int]$expected[0] -or $image.Height -ne [int]$expected[1]) {
            $errors.Add("$label dimensions=$($image.Width)x$($image.Height), expected=$expectedDimensions")
        }

        $stepX = [Math]::Max(1, [int][Math]::Floor($image.Width / 64.0))
        $stepY = [Math]::Max(1, [int][Math]::Floor($image.Height / 64.0))
        $transparent = $false
        $visible = $false
        $minLuma = 255
        $maxLuma = 0
        for ($y = 0; $y -lt $image.Height; $y += $stepY) {
            for ($x = 0; $x -lt $image.Width; $x += $stepX) {
                $pixel = $image.GetPixel($x, $y)
                if ($pixel.A -eq 0) { $transparent = $true }
                if ($pixel.A -gt 8) {
                    $visible = $true
                    $luma = [int](0.2126 * $pixel.R + 0.7152 * $pixel.G + 0.0722 * $pixel.B)
                    $minLuma = [Math]::Min($minLuma, $luma)
                    $maxLuma = [Math]::Max($maxLuma, $luma)
                }
            }
        }
        if (-not $visible) { $errors.Add("$label has no visible sampled pixels") }
        if ($visible -and ($maxLuma - $minLuma) -lt 4) { $warnings.Add("$label has very low sampled contrast") }
        if ($expectsAlpha) {
            $alphaChecked++
            if (-not $transparent) { $errors.Add("$label requires alpha but no transparent sampled pixel was found") }
        }
    } finally {
        $image.Dispose()
    }

    $actualHash = Get-Sha256 $entry.final_path
    if ($actualHash -ne [string]$entry.sha256) {
        $errors.Add("$label sha256 mismatch")
    }
    $checked++
}

$aliasIds = @(
    "machado_de_xargath", "martelo_da_gloria", "lamina_da_digestao", "chicote_avarento",
    "cajado_dos_desejos", "colar_dos_tentaculos", "sopro_de_estrela", "ampulheta"
)
foreach ($id in $aliasIds) {
    $weaponPath = "assets/icons/weapons/$id.png"
    $itemPath = "assets/icons/items/$id.png"
    if (-not (Test-Path -LiteralPath $weaponPath) -or -not (Test-Path -LiteralPath $itemPath)) {
        $errors.Add("alias $id is missing one or both files")
        continue
    }
    $resolvedWeaponPath = (Resolve-Path -LiteralPath $weaponPath).Path
    $resolvedItemPath = (Resolve-Path -LiteralPath $itemPath).Path
    $a = [System.Drawing.Bitmap]::new($resolvedWeaponPath)
    $b = [System.Drawing.Bitmap]::new($resolvedItemPath)
    try {
        $equal = $a.Width -eq $b.Width -and $a.Height -eq $b.Height
        if ($equal) {
            for ($y = 0; $y -lt $a.Height -and $equal; $y++) {
                for ($x = 0; $x -lt $a.Width; $x++) {
                    if ($a.GetPixel($x, $y).ToArgb() -ne $b.GetPixel($x, $y).ToArgb()) {
                        $equal = $false
                        break
                    }
                }
            }
        }
        if (-not $equal) { $errors.Add("alias $id is not pixel-identical") }
    } finally {
        $a.Dispose()
        $b.Dispose()
    }
}

if (-not (Test-Path -LiteralPath $IconPath)) {
    $errors.Add("missing $IconPath")
} else {
    try {
        [xml]$svg = Get-Content -LiteralPath $IconPath -Raw -Encoding UTF8
        if ($svg.svg.viewBox -ne "0 0 128 128") { $errors.Add("icon.svg has unexpected viewBox") }
        if ($svg.SelectNodes("//*[local-name()='text']").Count -gt 0) { $errors.Add("icon.svg contains text") }
    } catch {
        $errors.Add("icon.svg is invalid XML: $($_.Exception.Message)")
    }
}

$result = [PSCustomObject]@{
    manifest_total = @($manifest.entries).Count
    files_checked = $checked
    alpha_assets_checked = $alphaChecked
    aliases_checked = $aliasIds.Count
    svg_checked = (Test-Path -LiteralPath $IconPath)
    warnings = @($warnings)
    errors = @($errors)
    passed = $errors.Count -eq 0
}
$result | ConvertTo-Json -Depth 6
if ($errors.Count -gt 0) { exit 1 }
