param([switch]$VerifyOnly)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $projectRoot
$delivery = '.atena/generated/art-candidates/claude-handoff-v01'
function Read-Json($path) { Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json }
function Relative-Path($path) { [IO.Path]::GetRelativePath($projectRoot, $path).Replace('\','/') }
function Hash($path) { (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() }
function Save-Json($value, $path) { $value | ConvertTo-Json -Depth 25 | Set-Content -LiteralPath $path -Encoding utf8 }
if ($VerifyOnly) {
    $manifest = Read-Json "$delivery/manifest.json"
    foreach ($entry in @($manifest.entries) + @($manifest.support_files)) {
        if ((Hash $entry.path) -ne $entry.sha256) { throw "Hash mismatch: $($entry.path)" }
        if ((Hash $entry.source) -ne $entry.sha256) { throw "Source changed: $($entry.source)" }
        foreach ($record in $entry.records) {
            if (-not (Test-Path -LiteralPath $record -PathType Leaf)) { throw "Missing record: $record" }
        }
    }
    foreach ($entry in $manifest.entries) {
        if ($entry.runtime_destination -and (Test-Path -LiteralPath $entry.runtime_destination)) {
            if ((Hash $entry.runtime_destination) -ne $entry.runtime_before_sha256) { throw "Runtime changed: $($entry.runtime_destination)" }
        }
    }
    "PASS: $($manifest.entries.Count) primary assets, $($manifest.support_files.Count) support files; hashes, records and runtime snapshots verified."
    exit 0
}
if (Test-Path -LiteralPath "$delivery/manifest.json") { throw 'Delivery exists; use -VerifyOnly to avoid overwriting.' }
New-Item -ItemType Directory -Path $delivery -Force | Out-Null
$entries = [Collections.Generic.List[object]]::new()
$support = [Collections.Generic.List[object]]::new()
function Copy-Delivery($source, $relative, $records, $expectedHash = '') {
    $sourceHash = Hash $source
    if ($expectedHash -and $sourceHash -ne $expectedHash) { throw "Receipt hash mismatch: $source" }
    $target = "$delivery/$relative"
    if (Test-Path -LiteralPath $target) { throw "Refusing overwrite: $target" }
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $target
    if ((Hash $target) -ne $sourceHash) { throw "Copy mismatch: $target" }
    [ordered]@{ source=$source; path=$target; sha256=$sourceHash; bytes=(Get-Item -LiteralPath $target).Length; records=@($records) }
}
$names = @{
 IC01='bola_de_fogo';IC02='tormenta_de_fogo';IC03='lamina_de_sombra';IC04='romper_armadura';IC05='esmagar_defesas';IC06='dominio_da_vontade'
 IC07='cajado_familia_infernum';IC08='wave_of_terror';IC09='colar_visao_verdadeira';IC10='detector_arcano';IC11='dispositivo_antimagia_gilly';IC12='dispositivo_das_docas';IC13='coracao_da_dominancia'
 I01='lliira_juramento';I02='tou_um_caminho';AR01='arcanista';SE01='eco';SE02='camara_selada';SE03='camara_aberta'
 SE04='ruina_dagruve';SE05='ruina_docas';SE06='ruina_shedaklah';SE07='ruina_molor';SE08='ruina_durao';SE09='ruina_feng_tu';SE10='ruina_shendilavri';SE11='ruina_goranthis'
 EV01='pacto_sangue';EV02='relicario';EV03='peregrino';EV04='contador';EV05='carroca';EV06='eclipse_pedra';AL01='altar_active'
}
$approvalPath = '.atena/generated/fila028-acceptance-2026-10-10/approved-prepared-assets.json'
$approved = Read-Json $approvalPath
foreach ($item in $approved.entries) {
    $code = $item.code
    $folder = if ($code -match '^IC0[1-6]$') {'assets/icons/weapons'} elseif ($code -match '^IC') {'assets/icons/items'} elseif ($code -match '^I0') {'assets/icons/boons'} elseif ($code -eq 'AL01') {'assets/animations/interactions'} else {'assets/interactions'}
    $destination = "$folder/$($names[$code]).png"
    $copy = Copy-Delivery $item.path "fila028/$([IO.Path]::GetFileName($item.path))" (@($approvalPath) + @($approved.acceptance_registers) + @('.atena/generated/CHATGPT-FILA-028-eventos-arcanista-icones-segredos-e-altar.md')) $item.sha256
    $beforeHash = if (Test-Path -LiteralPath $destination) { Hash $destination } else { $null }
    $copy.id = $code
    $copy.name = $names[$code]
    $copy.revision = $item.derived_revision
    $copy.source_version = $item.source_version
    $copy.content_state = $item.content_state
    $copy.runtime_destination = $destination
    $copy.runtime_before_sha256 = $beforeHash
    $copy.status = if ($beforeHash -eq $copy.sha256) {'ALREADY_IDENTICAL_RUNTIME_FILE_VERIFY_WIRING'} else {'PENDING_RUNTIME_IMPLEMENTATION'}
    $copy.admission_gate = 'Visual preparation accepted; implement under separate runtime scope/checkpoint. Handoff approval does not promote canon or grant all future runtime changes.'
    $copy.integration = if ($code -eq 'AL01') {'6 horizontal frames, 900 ms loop. Preserve altar logic/grounding; do not use superseded AL01_v02.'} elseif ($code -match '^IC|^I0') {'Wire dedicated icon in data/UI; remove borrowed icon_like fallback only for this item; verify 48 px readability.'} elseif ($code -match '^SE') {'Wire secrets/scenery and chamber locked/open states; preserve spawn/collision rules and ground anchor.'} else {'Wire overlay and event IDs against actual data; preserve interactions and ground anchor; do not conflate ART-032 happenings.'}
    $entries.Add($copy)
}
$pilotState = '.atena/state/plan-103-demo-completa-e-polida.yaml'
foreach ($action in @('move_e','move_se','move_s','attack')) {
    $source = ".atena/generated/m1-movimento/piloto-durvall/candidata_v03/durvall/$action.png"
    $copy = Copy-Delivery $source "durvall-v03/$action.png" @($pilotState, '.atena/specs/SPEC-176-movimento-dos-herois-marco-m1-do-plan-103.md')
    $copy.id = "DURVALL-$action"
    $copy.name = "durvall/$action"
    $copy.revision = 'piloto-v03/grade-v01'
    $copy.content_state = 'DRAFT_PROVISIONALLY_ACCEPTED_G_D3'
    $copy.status = 'LAB_ONLY_PENDING_FULL_DIRECTION_SET_AND_RUNTIME_GATE'
    $copy.runtime_destination = "assets/animations/heroes/durvall/$action.png"
    $copy.runtime_before_sha256 = Hash $copy.runtime_destination
    $copy.admission_gate = 'D22: approved for now; reassess after final directions. Do not replace runtime until M1 checkpoint permits.'
    $copy.integration = '512x512 cells; 6 frames for moves, 4 attack frames. Preserve sword handedness; no mirrored substitute for missing W/SW/NW. Five missing directions stay pending, not replaced by historical candidates.'
    $entries.Add($copy)
    $support.Add((Copy-Delivery ".atena/generated/m1-movimento/piloto-durvall/retorno/codex/durvall_${action}_grade_v01.png" "durvall-v03/sources/${action}_grade_v01.png" @($pilotState)))
}
$altarReceipt = '.atena/generated/fila028-altar-correction-2026-10-10/approved-altar.json'
foreach ($frame in (Read-Json $altarReceipt).frames) {
    $support.Add((Copy-Delivery $frame.path "fila028/altar-frames/$([IO.Path]::GetFileName($frame.path))" @($altarReceipt) $frame.sha256))
}
Save-Json ([ordered]@{id='CLAUDE-ART-HANDOFF-2026-10-16';revision='v01';date='2026-10-16';content_state='DRAFT_HANDOFF_WITH_PER_ASSET_STATES';approval_mode='per-plan';entries=$entries.ToArray();support_files=$support.ToArray();notes=@('No runtime files changed.','CANON_PREPARATION_VISUAL_ONLY does not imply runtime admission.','Paths proposed from prompt contract; Claude must verify actual data IDs and wiring.')}) "$delivery/manifest.json"

# Exhaustive local generated-image inventory. Equality is evidence of a file in
# assets/, not proof that gameplay displays it. Review boards remain evidence.
$runtimeHashes = @{}
foreach ($file in Get-ChildItem assets -Recurse -File | Where-Object Extension -In '.png','.webp','.jpg','.jpeg') {
    $h = Hash $file.FullName
    if (-not $runtimeHashes.ContainsKey($h)) { $runtimeHashes[$h] = [Collections.Generic.List[string]]::new() }
    $runtimeHashes[$h].Add((Relative-Path $file.FullName))
}
$selected = @{}
foreach ($entry in @($entries.ToArray()) + @($support.ToArray())) { $selected[$entry.source] = $entry.path }
$audit = [Collections.Generic.List[object]]::new()
foreach ($file in Get-ChildItem .atena/generated -Recurse -File | Where-Object { $_.Extension -in '.png','.webp','.jpg','.jpeg' -and $_.FullName -notlike '*\art-candidates\claude-handoff-v01\*' }) {
    $path = Relative-Path $file.FullName
    $h = Hash $file.FullName
    $group = ($path -split '/')[2]
    $status = if ($selected.ContainsKey($path)) {'SELECTED_FOR_HANDOFF'} elseif ($runtimeHashes.ContainsKey($h)) {'IDENTICAL_FILE_IN_ASSETS_VERIFY_WIRING_IF_NEEDED'} elseif ($path -match 'durvall-animation-package|leoric-animation-package') {'HOLD_HISTORICAL_CANDIDATE_REVIEW_GATE'} elseif ($path -match 'm1-movimento') {'M1_TEMPLATE_REFERENCE_OR_SUPERSEDED_RETURN'} elseif ($path -match 'fila028') {'FILA028_SOURCE_REVIEW_OR_SUPERSEDED_DERIVATIVE_USE_ACCEPTED_34_ONLY'} elseif ($path -match 'art-candidates/ficha-c|ficha-c-integration') {'FICHA_C_SOURCE_OR_EVIDENCE_ADMITTED_PLAN072'} elseif ($path -match 'art-candidates/enemies-shendilavri') {'HISTORICAL_ENEMY_SOURCE_ADMITTED_PLAN053'} elseif ($path -match 'art032|fila026|hero-|arlindo|erik|pulso|ampulheta|vfx-projectiles|s007|shendilavri|goranthis|pilares') {'ADMITTED_FAMILY_SOURCE_BACKUP_OR_EVIDENCE_NOT_NEW_RUNTIME_WORK'} else {'SUPPORT_EXPERIMENT_OR_HISTORICAL_REVIEW_SEE_GROUP_DISPOSITION'}
    $audit.Add([ordered]@{path=$path;group=$group;sha256=$h;bytes=$file.Length;classification=$status;identical_assets=if($runtimeHashes.ContainsKey($h)){@($runtimeHashes[$h].ToArray())}else{@()}})
}
Save-Json ([ordered]@{scope='All PNG/WebP/JPEG physically present under .atena/generated before handoff copies; git-ignored files included';runtime_equality_limit='Byte equality identifies existing assets, not complete runtime wiring';image_count=$audit.Count;entries=$audit.ToArray()}) "$delivery/generated-image-audit.json"
$audit.ToArray() | ForEach-Object { [pscustomobject]$_ } | Group-Object group | ForEach-Object { [pscustomobject]@{group=$_.Name;images=$_.Count;identical_in_assets=@($_.Group | Where-Object {$_.identical_assets.Count -gt 0}).Count;selected=@($_.Group | Where-Object classification -EQ 'SELECTED_FOR_HANDOFF').Count} } | Export-Csv "$delivery/group-summary.csv" -NoTypeInformation -Encoding utf8
"Prepared $($entries.Count) primary assets and $($support.Count) support files; audited $($audit.Count) generated images."
