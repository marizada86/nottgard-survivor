param(
    [string]$OutputPath = ".atena/generated/ASSET-PRODUCTION-MANIFEST-001.json"
)

$ErrorActionPreference = "Stop"

function Read-Json([string]$Path) {
    Get-Content -LiteralPath $Path -Raw -Encoding UTF8 | ConvertFrom-Json
}

$entries = [System.Collections.Generic.List[object]]::new()

function Add-Generated {
    param([string]$Id, [string]$Family, [string]$FinalPath, [string]$PromptId, [string]$Dimensions, [bool]$Alpha = $true, [string[]]$References = @())
    $entries.Add([ordered]@{
        asset_id = $Id
        family = $Family
        generation_mode = "imagegen"
        final_path = $FinalPath
        candidate_path = ".atena/generated/art-candidates/$Family/${Id}_vNN.png"
        prompt_id = $PromptId
        dimensions = $Dimensions
        alpha = $Alpha
        references = $References
        status = "prompt_ready"
        selected_version = $null
        sha256 = $null
        qa_notes = @()
    })
}

function Add-Alias {
    param([string]$Id, [string]$Family, [string]$FinalPath, [string]$SourcePath)
    $entries.Add([ordered]@{
        asset_id = $Id
        family = $Family
        generation_mode = "alias"
        final_path = $FinalPath
        source_path = $SourcePath
        status = "source_pending"
        selected_version = $null
        sha256 = $null
        qa_notes = @()
    })
}

$heroes = Read-Json "data/heroes.json"
$enemies = Read-Json "data/enemies.json"
$weapons = Read-Json "data/weapons.json"
$passives = Read-Json "data/passives.json"
$boons = Read-Json "data/boons.json"
$abilities = Read-Json "data/abilities.json"
$stages = Read-Json "data/stages.json"
$items = Read-Json "data/items.json"

$heroRefs = @{
    durvall = @(".atena/evidence/reference-staging/durvall.png")
    brook = @(".atena/evidence/reference-staging/brook.png")
    maelor = @(".atena/evidence/reference-staging/maelor.png")
    sylas = @(".atena/evidence/reference-staging/sylas.png")
    kayron = @(".atena/evidence/reference-staging/kayron.png")
    korrak = @(".atena/evidence/reference-staging/korrak.png", ".atena/evidence/reference-staging/korrak_gigante.png")
    leoric = @(".atena/evidence/reference-staging/leoric.png")
    nyrelia = @()
    zynara = @(".atena/evidence/reference-staging/zynara.png")
    bromnor = @(".atena/evidence/reference-staging/bromnor.png")
}

foreach ($id in @($heroes.PSObject.Properties.Name)) {
    Add-Generated $id "portraits" "assets/portraits/$id.png" "ART-PROMPTS-002" "640x427" $false $heroRefs[$id]
    Add-Generated $id "heroes" "assets/heroes/$id.png" "ART-PROMPTS-011" "256x384" $true $heroRefs[$id]
}

$legacyEnemies = @("zumbi", "slime_corrosivo", "cultista_adaga", "cultista_arqueiro", "cultista_cajado", "criatura_corrompida", "guardiao_copia", "guardiao_verdadeiro", "mimico", "sacerdote_mente_derretida")
$p003 = @("notivago", "arch_hag", "tentaculo_kraken", "gargula", "cogumelo_fungico", "servo_de_zuggtmoy", "esporo_voador", "pudim_negro", "slime_de_juiblex", "zuggtmoy")
$p004 = @("bolha_de_slime", "cultista_thullgrime", "receptaculo_de_juiblex", "blogbog", "alma_penada", "demonio_de_gehenna", "carcereiro_de_pedra", "molydeus_menor", "molydeus_chefe", "aberracao_shu", "ezro")
$p005 = @("larva_de_lu_yueh", "cultista_de_feng_tu", "estatua_do_templo", "discipulo_pestilento", "lu_yueh", "cultista_ghaunadaur", "escravo_de_rivenheart", "sucubo", "ilusao_de_sucubo", "guarda_do_castelo", "master_of_cruelties", "malcanthet")

foreach ($id in @($enemies.PSObject.Properties.Name)) {
    $prompt = if ($legacyEnemies -contains $id) { "ART-PROMPTS-011" } elseif ($p003 -contains $id) { "ART-PROMPTS-003" } elseif ($p004 -contains $id) { "ART-PROMPTS-004" } elseif ($p005 -contains $id) { "ART-PROMPTS-005" } else { "ART-PROMPTS-006" }
    $refs = if ($legacyEnemies -contains $id) { @("assets/enemies/$id.png") } else { @() }
    Add-Generated $id "enemies" "assets/enemies/$id.png" $prompt "320x480" $true $refs
}

$propKinds = @("pilar", "cogumelo", "bolha", "rocha", "torii", "cristal", "cachoeira", "pilar_abissal")
foreach ($stageId in @($stages.PSObject.Properties.Name)) {
    Add-Generated "${stageId}_ground" "tiles" "assets/tiles/${stageId}_ground.png" "ART-PROMPTS-007" "128x64" $false
    Add-Generated "${stageId}_thumb" "stages" "assets/stages/${stageId}_thumb.png" "ART-PROMPTS-007" "480x320" $false
}
foreach ($kind in $propKinds) {
    1..3 | ForEach-Object { $id = "{0}_{1:d2}" -f $kind, $_; Add-Generated $id "props" "assets/props/$id.png" "ART-PROMPTS-007" "256x256" $true }
}

foreach ($id in @("chest_closed", "chest_open", "fountain_active", "fountain_spent", "altar_active", "altar_spent", "ritual", "portal")) {
    Add-Generated $id "interactions" "assets/interactions/$id.png" "ART-PROMPTS-008" "192x192" $true
}

foreach ($id in @($weapons.PSObject.Properties.Name)) {
    Add-Generated $id "icons/weapons" "assets/icons/weapons/$id.png" "ART-PROMPTS-009" "128x128" $true
}

foreach ($category in @($items.bases.PSObject.Properties)) {
    foreach ($base in @($category.Value)) {
        Add-Generated $base.id "icons/items" "assets/icons/items/$($base.id).png" "ART-PROMPTS-009" "128x128" $true
    }
}

$sharedUnique = @("machado_de_xargath", "martelo_da_gloria", "lamina_da_digestao", "chicote_avarento", "cajado_dos_desejos", "colar_dos_tentaculos", "sopro_de_estrela", "ampulheta")
foreach ($item in @($items.uniques)) {
    if ($sharedUnique -contains $item.id) {
        Add-Alias $item.id "icons/items" "assets/icons/items/$($item.id).png" "assets/icons/weapons/$($item.id).png"
    } else {
        Add-Generated $item.id "icons/items" "assets/icons/items/$($item.id).png" "ART-PROMPTS-009" "128x128" $true
    }
}

foreach ($id in @($passives.PSObject.Properties.Name)) {
    Add-Generated $id "icons/passives" "assets/icons/passives/$id.png" "ART-PROMPTS-010" "128x128" $true
}
foreach ($boon in @($boons.boons)) {
    Add-Generated $boon.id "icons/boons" "assets/icons/boons/$($boon.id).png" "ART-PROMPTS-010" "128x128" $true
}
foreach ($hero in @($abilities.PSObject.Properties)) {
    Add-Generated $hero.Value.id "icons/abilities" "assets/icons/abilities/$($hero.Value.id).png" "ART-PROMPTS-012" "128x128" $true
}

$stageRules = [ordered]@{ dagruve="rituals"; shedaklah="puddles"; molor="bubbles"; durao="current"; feng_tu="strikes"; shendilavri="illusions"; goranthis="sanctuary"; pilares="rotation" }
foreach ($stageId in $stageRules.Keys) {
    $id = "${stageId}_$($stageRules[$stageId])"
    Add-Generated $id "icons/stages" "assets/icons/stages/$id.png" "ART-PROMPTS-012" "128x128" $true
}
foreach ($id in @("coin", "kill", "ca", "cam", "health", "xp", "target", "essence")) {
    Add-Generated $id "icons/ui" "assets/icons/ui/$id.png" "ART-PROMPTS-010" "128x128" $true
}
foreach ($id in @("xp_shard", "gold_coin", "health_potion")) {
    Add-Generated $id "pickups" "assets/pickups/$id.png" "ART-PROMPTS-012" "64x64" $true
}

$screenRefs = @{ quartel_background=@(".atena/evidence/reference-staging/menu.png"); victory_background=@(".atena/evidence/reference-staging/vitoria.png"); defeat_background=@(".atena/evidence/reference-staging/game_over.png") }
foreach ($id in $screenRefs.Keys) {
    Add-Generated $id "ui/backgrounds" "assets/ui/backgrounds/$id.png" "ART-PROMPTS-013" "1920x1080" $false $screenRefs[$id]
}

$manifest = [ordered]@{
    schema_version = 1
    project = "Nottgard Survivors"
    generated_at = "2026-09-22"
    specification = "SPEC-015-producao-total-de-assets-visuais"
    expected_png_files = 236
    expected_imagegen_calls = 228
    entries = @($entries | Sort-Object family, asset_id)
    logical_reuse = [ordered]@{
        achievements = "18 IDs resolve through icon_ref; no additional PNG"
        upgrades = "12 IDs resolve through icon_ref or procedural pictogram; no additional generated PNG"
        app_icon = "icon.svg is vector/code-native"
    }
}

$dir = Split-Path -Parent $OutputPath
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$json = $manifest | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $OutputPath), $json, [System.Text.UTF8Encoding]::new($false))
Write-Output $OutputPath

