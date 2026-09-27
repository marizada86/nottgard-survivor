param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'
$manifestPath = Join-Path $ProjectRoot '.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json'
$auditDirectory = Join-Path $ProjectRoot '.atena/generated/asset-audit'
$evidenceDirectory = Join-Path $ProjectRoot '.atena/evidence'
$auditPath = Join-Path $auditDirectory 'ASSET-AUDIT-001.json'
$evidencePath = Join-Path $evidenceDirectory 'EVID-054-spec-044-auditoria-de-registros-2026-09-27.md'
$candidateRoots = @(
    (Join-Path $ProjectRoot '.atena/generated/art-candidates'),
    (Join-Path $ProjectRoot '.atena/generated/asset-candidates'),
    (Join-Path $ProjectRoot '.atena/generated/animation-candidates')
) | Where-Object { Test-Path -LiteralPath $_ }

New-Item -ItemType Directory -Force -Path $auditDirectory | Out-Null
New-Item -ItemType Directory -Force -Path $evidenceDirectory | Out-Null

Add-Type -AssemblyName System.Drawing

function Get-ImageMetadata([string]$Path) {
    $image = [System.Drawing.Image]::FromFile($Path)
    try {
        $hasAlpha = (($image.PixelFormat -band [System.Drawing.Imaging.PixelFormat]::Alpha) -ne 0) -or
            (($image.PixelFormat -band [System.Drawing.Imaging.PixelFormat]::PAlpha) -ne 0)
        return [ordered]@{
            width = $image.Width
            height = $image.Height
            alpha = $hasAlpha
        }
    }
    finally {
        $image.Dispose()
    }
}

function Get-CandidateResolution([string]$CandidatePath, [string]$AssetId) {
    $symbolic = $CandidatePath -match 'vNN|<|>|\*|\?'
    $declaredFullPath = Join-Path $ProjectRoot $CandidatePath
    if (-not $symbolic -and (Test-Path -LiteralPath $declaredFullPath)) {
        return [ordered]@{ state = 'declared_present'; path = $CandidatePath; symbolic = $false }
    }

    $escapedAsset = [regex]::Escape($AssetId)
    foreach ($root in $candidateRoots) {
        $match = Get-ChildItem -LiteralPath $root -Recurse -File -Filter '*.png' |
            Where-Object { $_.BaseName -match "^$escapedAsset(_v\d+(_[a-z]+)?)?$" } |
            Select-Object -First 1
        if ($null -ne $match) {
            return [ordered]@{
                state = if ($symbolic) { 'recovered_from_symbolic_path' } else { 'recovered_from_missing_path' }
                path = $match.FullName.Substring($ProjectRoot.Length + 1).Replace('\', '/')
                symbolic = $symbolic
            }
        }
    }

    return [ordered]@{
        state = if ($symbolic) { 'symbolic_unresolved' } else { 'missing' }
        path = $null
        symbolic = $symbolic
    }
}

$manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$records = foreach ($entry in $manifest.entries) {
    $finalFullPath = Join-Path $ProjectRoot $entry.final_path
    $finalExists = Test-Path -LiteralPath $finalFullPath
    $actualHash = $null
    $metadata = $null
    if ($finalExists) {
        $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $finalFullPath).Hash.ToLowerInvariant()
        $metadata = Get-ImageMetadata $finalFullPath
    }

    $candidate = Get-CandidateResolution $entry.candidate_path $entry.asset_id
    $hashMatches = $finalExists -and ($actualHash -eq $entry.sha256.ToLowerInvariant())
    $classification = if (-not $finalExists) {
        'final_ausente'
    }
    elseif (-not $hashMatches) {
        'hash_divergente'
    }
    elseif ($candidate.state -eq 'symbolic_unresolved') {
        'caminho_simbolico'
    }
    elseif ($candidate.state -eq 'missing') {
        'candidato_ausente'
    }
    else {
        'verificavel'
    }

    [pscustomobject][ordered]@{
        asset_id = $entry.asset_id
        family = $entry.family
        final_path = $entry.final_path
        final_exists = $finalExists
        declared_sha256 = $entry.sha256
        actual_sha256 = $actualHash
        hash_matches = $hashMatches
        declared_dimensions = $entry.dimensions
        actual_dimensions = if ($null -eq $metadata) { $null } else { "{0}x{1}" -f $metadata.width, $metadata.height }
        declared_alpha = $entry.alpha
        actual_alpha = if ($null -eq $metadata) { $null } else { $metadata.alpha }
        generation_mode = $entry.generation_mode
        prompt_id = $entry.prompt_id
        historical_status = $entry.status
        selected_version = $entry.selected_version
        declared_candidate_path = $entry.candidate_path
        candidate_resolution = $candidate
        traceability_classification = $classification
        qa_notes = @($entry.qa_notes)
        approval_decision = 'unreviewed'
    }
}

$criticalIds = @(
    'nyrelia_idle', 'nyrelia_move_n', 'nyrelia_move_ne', 'nyrelia_move_e', 'nyrelia_move_se', 'nyrelia_move_s',
    'nyrelia_attack', 'nyrelia_active', 'nyrelia_death',
    'rocha_01', 'rocha_02', 'rocha_03', 'pilar_abissal_01', 'pilar_abissal_02', 'pilar_abissal_03'
)
$critical = @($records | Where-Object { $_.asset_id -in $criticalIds })
$familySummary = @($records | Group-Object family | Sort-Object Name | ForEach-Object {
    [ordered]@{
        family = $_.Name
        total = $_.Count
        classifications = @($_.Group | Group-Object traceability_classification | Sort-Object Name | ForEach-Object {
            [ordered]@{ classification = $_.Name; count = $_.Count }
        })
    }
})
$classificationSummary = [ordered]@{}
$records | Group-Object traceability_classification | Sort-Object Name | ForEach-Object { $classificationSummary[$_.Name] = $_.Count }

$report = [ordered]@{
    schema_version = 1
    generated_at = (Get-Date).ToUniversalTime().ToString('o')
    source_manifest = '.atena/generated/ASSET-PRODUCTION-MANIFEST-001.json'
    declared_expected_png_files = $manifest.expected_png_files
    record_count = @($records).Count
    record_count_difference = @($records).Count - [int]$manifest.expected_png_files
    approval_state = 'unreviewed'
    classifications = $classificationSummary
    families = $familySummary
    critical_review = $critical
    records = $records
}
$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $auditPath -Encoding utf8

$criticalLines = foreach ($record in $critical) {
    "| {0} | {1} | {2} | {3} | {4} |" -f $record.asset_id, $record.final_path, $record.traceability_classification, $record.hash_matches, $record.candidate_resolution.state
}
$classificationLines = foreach ($name in $classificationSummary.Keys) {
    "| {0} | {1} |" -f $name, $classificationSummary[$name]
}

$evidence = @"
# EVID-054 - Auditoria de registros para SPEC-044

Data: $(Get-Date -Format 'yyyy-MM-dd')

## Escopo executado

- manifesto auditado: .atena/generated/ASSET-PRODUCTION-MANIFEST-001.json;
- registros declarados: $($manifest.expected_png_files) PNGs esperados;
- registros efetivamente encontrados: $(@($records).Count);
- diferenca: $(@($records).Count - [int]$manifest.expected_png_files);
- relatorio detalhado: .atena/generated/asset-audit/ASSET-AUDIT-001.json.

## Classificacao de rastreabilidade

| Classificacao | Registros |
| --- | ---: |
$($classificationLines -join "`n")

Verificavel neste relatorio significa que o arquivo final existe, confere com
o hash declarado e tem uma candidata declarada ou recuperada. Nao significa
aprovacao artistica ou promocao a asset oficial.

## Lote critico - ainda sem decisao humana

| Asset | Arquivo final | Rastreabilidade | Hash | Candidata |
| --- | --- | --- | --- | --- |
$($criticalLines -join "`n")

## Limites da evidencia

- A auditoria nao alterou PNGs, manifestos historicos, cenas ou logica de jogo.
- Nenhum registro foi promovido a approved; todos permanecem unreviewed.
- A decisao artistica exige revisao visual e escolha explicita do dono por lote.
- A aprovacao de um PNG nao aprova automaticamente seu placement no Estige.
"@
Set-Content -LiteralPath $evidencePath -Value $evidence -Encoding utf8

Write-Output "audit=$auditPath"
Write-Output "evidence=$evidencePath"
Write-Output "records=$(@($records).Count)"
Write-Output "difference=$(@($records).Count - [int]$manifest.expected_png_files)"
foreach ($name in $classificationSummary.Keys) { Write-Output "$name=$($classificationSummary[$name])" }
