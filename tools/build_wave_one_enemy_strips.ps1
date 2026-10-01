param(
    [switch]$Admit
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $root ".atena\generated\art-candidates\enemies-wave-1"
$candidateRoot = Join-Path $sourceRoot "runtime-strips"
$assetRoot = Join-Path $root "assets\animations\enemies"

$targets = @(
    @{ id = "slime_corrosivo"; cell = @(256, 384); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6 }; overrides = @{ "move_03" = "slime_corrosivo_move_03_v02.png" } },
    @{ id = "cultista_arqueiro"; cell = @(256, 384); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6 }; overrides = @{ "idle_02" = "cultista_arqueiro_idle_02_v02.png" } },
    @{ id = "cultista_cajado"; cell = @(256, 384); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6 }; overrides = @{} },
    @{ id = "notivago"; cell = @(256, 384); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6 }; overrides = @{} },
    @{ id = "criatura_corrompida"; cell = @(256, 384); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6 }; overrides = @{} },
    @{ id = "arch_hag"; cell = @(256, 384); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6 }; overrides = @{} },
    @{ id = "tentaculo_kraken"; cell = @(256, 384); states = [ordered]@{ idle = 4; attack = 4; death = 6 }; overrides = @{ "death_05" = "tentaculo_kraken_death_05_v02.png" } },
    @{ id = "guardiao_verdadeiro"; cell = @(320, 480); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6; special = 6 }; overrides = @{ "death_05" = "guardiao_verdadeiro_death_05_v02.png" } },
    @{ id = "guardiao_copia"; cell = @(320, 480); states = [ordered]@{ idle = 4; move = 6; attack = 4; death = 6; special = 6 }; overrides = @{} }
)

function Get-SourcePath {
    param($Target, [string]$State, [int]$Index)
    $key = "{0}_{1:D2}" -f $State, $Index
    if ($Target.id -eq "guardiao_copia") {
        $pilot = @{ "idle_00" = "guardiao_copia_idle_00_pilot_v01.png"; "attack_02" = "guardiao_copia_attack_02_pilot_v01.png"; "death_05" = "guardiao_copia_death_05_pilot_v01.png" }
        if ($pilot.ContainsKey($key)) {
            return Join-Path $sourceRoot ("guardiao_copia\pilot\" + $pilot[$key])
        }
    }
    $file = if ($Target.overrides.ContainsKey($key)) { $Target.overrides[$key] } else { "{0}_{1}_{2:D2}_v01.png" -f $Target.id, $State, $Index }
    return Join-Path $sourceRoot ("{0}\frames\{1}" -f $Target.id, $file)
}

function Assert-Source {
    param([string]$Path, [int]$Width, [int]$Height)
    if (-not (Test-Path -LiteralPath $Path)) { throw "Fonte ausente: $Path" }
    $image = [System.Drawing.Bitmap]::new($Path)
    try {
        if ($image.Width -ne $Width -or $image.Height -ne $Height) { throw "Dimensão inválida em ${Path}: $($image.Width)x$($image.Height), esperada ${Width}x${Height}" }
        if ($image.GetPixel(0, 0).A -ne 0) { throw "Canto sem transparência em $Path" }
    } finally {
        $image.Dispose()
    }
}

function Build-Strip {
    param($Target, [string]$State, [int]$Count)
    $width = [int]$Target.cell[0]
    $height = [int]$Target.cell[1]
    $targetDir = Join-Path $candidateRoot $Target.id
    $output = Join-Path $targetDir ("$State.png")
    if (Test-Path -LiteralPath $output) { throw "Saída candidata já existe: $output" }
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    $strip = [System.Drawing.Bitmap]::new($width * $Count, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($strip)
    try {
        $graphics.Clear([System.Drawing.Color]::Transparent)
        for ($index = 0; $index -lt $Count; $index++) {
            $source = Get-SourcePath $Target $State $index
            Assert-Source $source $width $height
            $frame = [System.Drawing.Bitmap]::new($source)
            try { $graphics.DrawImageUnscaled($frame, $index * $width, 0) } finally { $frame.Dispose() }
        }
        $strip.Save($output, [System.Drawing.Imaging.ImageFormat]::Png)
    } finally {
        $graphics.Dispose()
        $strip.Dispose()
    }
    $check = [System.Drawing.Bitmap]::new($output)
    try {
        if ($check.Width -ne ($width * $Count) -or $check.Height -ne $height -or $check.GetPixel(0, 0).A -ne 0) { throw "Tira inválida: $output" }
    } finally {
        $check.Dispose()
    }
    if ($Admit) {
        $assetDir = Join-Path $assetRoot $Target.id
        $asset = Join-Path $assetDir ("$State.png")
        if (Test-Path -LiteralPath $asset) { throw "Asset oficial já existe: $asset" }
        New-Item -ItemType Directory -Force -Path $assetDir | Out-Null
        Copy-Item -LiteralPath $output -Destination $asset
    }
    return $output
}

$outputs = @()
foreach ($target in $targets) {
    foreach ($state in $target.states.Keys) {
        $outputs += Build-Strip $target $state ([int]$target.states[$state])
    }
}
$outputs
