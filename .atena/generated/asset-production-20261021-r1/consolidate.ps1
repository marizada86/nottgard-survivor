param([switch]$Deliver)
$ErrorActionPreference = 'Stop'
$prod = $PSScriptRoot
$utf8 = New-Object System.Text.UTF8Encoding($false)
function Write-Utf8($Path, $Text) { [IO.File]::WriteAllText($Path,$Text,$utf8) }
Add-Type -AssemblyName System.Drawing
$old = Get-Content (Join-Path $prod 'manifest.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$items = @(Get-ChildItem $prod -Filter *.json | Where-Object BaseName -Match '^[UVQCN]\d{2}' | Sort-Object Name | ForEach-Object {Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json})
$rows = @{}
foreach ($line in Get-Content (Join-Path $prod 'ASSET-GENERATION-LIST-20261021-r1.md') -Encoding UTF8) {
 if ($line -match '^\| ([UVQCN]\d{2}) \|') { $rows[$Matches[1]]=[string]::Concat($line) }
}
$audit = @()
foreach ($item in $items) {
 $png = Join-Path $prod $item.file
 if (!(Test-Path -LiteralPath $png) -or !(Test-Path -LiteralPath (Join-Path $prod $item.prompt_file))) {throw "Missing files: $($item.id)"}
 foreach ($ref in $item.references) {if (!(Test-Path -LiteralPath $ref)) {throw "Missing reference: $ref"}}
 $img = [Drawing.Image]::FromFile($png)
 try {$audit += [pscustomobject]@{file=$item.file;width=$img.Width;height=$img.Height;bytes=(Get-Item $png).Length;sha256=(Get-FileHash $png -Algorithm SHA256).Hash;selected=($item.file -notin $old.superseded)}} finally {$img.Dispose()}
 $code=$item.id.Substring(0,3)
 if (!$rows.ContainsKey($code)) {throw "Missing contract: $code"}
 $item | Add-Member contract_row $rows[$code] -Force
 $item | Add-Member contract_document 'ASSET-GENERATION-LIST-20261021-r1.md' -Force
}
if ($items.Count -ne 129 -or @($audit | Where-Object selected).Count -ne 125) {throw 'Unexpected source counts'}
$manifest=[ordered]@{
 revision='DRAFT/r1';status='SOURCES_COMPLETE_AWAITING_HUMAN_VISUAL_ACCEPTANCE';contract='ASSET-GENERATION-LIST-20261021-r1.md'
 authorization='per-plan; aprovado, pode gerar; generation continuation explicitly approved'
 source_count=$items.Count;selected_count=125;superseded=$old.superseded;remaining_character_poses=0
 human_visual_acceptance='PENDING';canonical_promotion=$false;runtime_admission=$false
 references_note=$old.references_note
 reuse=@(@{id='N11';source='F:/dev/abyss-megadungeon/assets/enemies/mimico.png';action='REUSE_EXISTING_NO_GENERATION';acceptance='PENDING'})
 preparation_pending=@('background extraction and normalization','crop and final dimensions','animation registration and intermediate frames','nine-slice measurements','U10 seamless repeat check','human visual acceptance')
 artifacts=$items
}
Write-Utf8 (Join-Path $prod 'manifest.json') ($manifest | ConvertTo-Json -Depth 8)
Write-Utf8 (Join-Path $prod 'png-audit.json') ($audit | ConvertTo-Json -Depth 10)
$cards=foreach($item in $items) {
 $a=$audit | Where-Object file -EQ $item.file
 $group=$item.id.Substring(0,1)
 $hold=if($a.selected){'Candidata para revisão'}else{'Substituída — usar v02'}
 $cls=if($a.selected){''}else{'superseded'}
 $row=[Net.WebUtility]::HtmlEncode($item.contract_row)
 "<article class='$cls' data-group='$group'><h3>$($item.id) · $($item.revision)</h3><a href='$($item.file)'><img loading='lazy' src='$($item.file)' alt='$($item.id) DRAFT'></a><p>$hold · $($a.width)×$($a.height)</p><p><a href='$($item.prompt_file)'>Prompt</a> · <a href='$($item.id).json'>Proveniência</a></p><details><summary>Contrato e referências</summary><p>$row</p><ul>"+(($item.references | ForEach-Object {"<li>"+[Net.WebUtility]::HtmlEncode($_)+"</li>"}) -join '')+"</ul></details></article>"
}
$html=@'
<!doctype html><html lang="pt-BR"><meta charset="utf-8"><meta name="viewport" content="width=device-width">
<title>Nottgard — candidatas DRAFT r1</title>
<style>
body{margin:0;background:#14151b;color:#eee;font:16px system-ui}header{padding:28px;max-width:1050px}h1{font-size:28px}p{line-height:1.5}a{color:#e8c783}nav{position:sticky;top:0;background:#24232b;padding:12px;z-index:2;display:flex;gap:12px;flex-wrap:wrap}button{padding:9px;background:#42382b;color:#fff;border:1px solid #b08d52;border-radius:5px;cursor:pointer}.grid{padding:20px;display:grid;grid-template-columns:repeat(auto-fit,minmax(270px,1fr));gap:18px}article{background:#24252d;border:1px solid #504938;border-radius:8px;padding:14px;overflow-wrap:anywhere}article img{width:100%;height:340px;object-fit:contain;background:#383940}.small article img{height:150px}article h3{font-size:16px}.superseded{opacity:.55}summary{cursor:pointer}details{font-size:12px}li{margin:8px 0}
</style><header><h1>Nottgard · revisão de fontes DRAFT r1</h1><p>129 PNGs; 125 candidatas e quatro versões substituídas. As 33 poses restantes do lote N foram geradas. N11 reutiliza o mímico existente.</p><p>Revise identidade, roupa, cores, equipamento e leitura. Abra cada PNG para ampliar; use a prévia de 150 px para observar a silhueta. Informe os IDs aceitos e as correções desejadas. O aceite visual não promove conteúdo a CANON.</p><p>Fontes maiores com fundos de extração. Escala final, transparência, alinhamento entre poses e animação ainda não preparados. Margens menores que as pedidas em várias fontes; sem corte aparente nas 33 poses novas. A prévia de 150 px é uma inspeção estática, sem comprovar animação.</p><p><a href="manifest.json">Manifesto</a> · <a href="png-audit.json">Auditoria PNG</a> · <a href="completion.md">Evidências e pendências</a> · <a href="ASSET-GENERATION-LIST-20261021-r1.md">Contrato</a></p></header>
<nav><button onclick="filter('')">Todos</button><button onclick="filter('U')">UI</button><button onclick="filter('V')">Vault</button><button onclick="filter('Q')">Quartel</button><button onclick="filter('C')">Conteúdo</button><button onclick="filter('N')">Personagens N</button><button onclick="document.body.classList.toggle('small')">Prévia 150 px / ampliar</button></nav><main class="grid">
'@
$html += ($cards -join [Environment]::NewLine)
$html += '</main><script>function filter(g){document.querySelectorAll("article").forEach(a=>a.hidden=!!g&&a.dataset.group!==g)}</script></html>'
Write-Utf8 (Join-Path $prod 'index.html') $html
if ($Deliver) {
 $dest='F:\dev\abyss-megadungeon\assets_incoming'
 if (!(Test-Path -LiteralPath $dest -PathType Container)) {throw 'Expected incoming directory missing'}
 $copied=0;$existing=0
 foreach($a in $audit) {
  $target=Join-Path $dest $a.file
  if(Test-Path -LiteralPath $target) {
   if((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $a.sha256){throw "Destination conflict (preserved): $target"}
   $existing++
  } else {Copy-Item -LiteralPath (Join-Path $prod $a.file) -Destination $target; $copied++}
  if((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -ne $a.sha256){throw "Copy verification failed: $target"}
 }
 Write-Utf8 (Join-Path $prod 'delivery-audit.json') ([ordered]@{destination=$dest;state='DRAFT';files=129;copied=$copied;existing_identical=$existing;sha256_verified=$true;runtime_modified=$false;delivered_files=$audit} | ConvertTo-Json -Depth 12)
}
[pscustomobject]@{sources=$items.Count;selected=125;pending_generation=0;gallery='index.html';delivery=$Deliver.IsPresent}
